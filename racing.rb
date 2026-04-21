require 'ruby2d'
require './lib/background'
require './lib/player'
require './lib/car'
require './lib/track'
require './lib/roadside_trees'
require './lib/y_screen_ruler'
require './lib/race_menu'
require './lib/track_minimap'

##
# Window
##

# Match window size here and when calling YScreenRuler (for labeled Y lines in screenshots)
WIN_W = 1024
WIN_H = 768

# Set to false to hide horizontal Y lines (debug overlay, above the road, z 3000+)
Y_SCREEN_RULER = false
Y_RULER_STEP   = 100 # pixels between each horizontal line

set title: 'Racing',
    width: WIN_W,
    height: WIN_H,
    resizable: false

roadW = 2000;
segL = 200;

H = 1500
N = 1600
# Z base so road strips sit above the background (0) and sort by depth (higher = nearer / drawn on top).
ROAD_STRIP_Z = 100.0
# How many road segments the draw loop extends forward; must match the `for` range size.
VIEW_LOOKAHEAD = 300
# z increment per one segment of distance. Screen-Y alone is wrong for hills: a far tree and a
# nearer strip can have similar l.Y, so we key depth off segment index i (nearer = larger z).
Z_PER_SEGMENT = 2.0

menu = RaceMenu.new(WIN_W, WIN_H)
game_started = false
track = nil
car = Car.new
player = Player.new
roadside_trees = RoadsideTrees.new
YScreenRuler.install!(WIN_W, WIN_H, step: Y_RULER_STEP, z: 1_800) if Y_SCREEN_RULER

debug = Text.new('', x: 10, y: 10, z: 2001, color: 'red')
minimap = nil
gearText = Text.new('N', x: 870, y: 720, z: 2001, size: 30, font: 'assets/fonts/LCD.TTF', color: 'red')
speedText = Text.new('0', x: 900, y: 700, z: 2001, size: 55, font: 'assets/fonts/LCD.TTF', color: 'black')
x = 0
dx = 0
pos = 0
bestTime = 0
currentTime = 0
lapTimes = Array.new(5, 0)
maxy = get(:height)
cheated = false

on :key_down do |event|
  next if game_started

  case event.key.to_sym
  when :up, :w
    menu.move(-1)
  when :down, :s
    menu.move(1)
  when :return, :space
    layout = menu.selected_layout
    menu.hide!
    game_started = true
    track = Track.new(layout: layout)
    minimap = TrackMinimap.new(track, roadW, segL, get(:width))
    car = Car.new
    pos = 0
    x = 0
    dx = 0
    currentTime = 0
    bestTime = 0
    cheated = false
    car.y = track.lines[0].y + H
  end
end

on :key_held do |event|
  next unless game_started

  case event.key.to_sym
  when :left
    car.turn_left
  when :right
    car.turn_right
  when :up
    car.accelerate
  when :down
    car.brake
  when :tab
    #speed *= 3 if speed < 200
  end
end

on :key_up do |event|
  next unless game_started

  case event.key.to_sym
  when :down
    car.braking = false
  end
end

update do
  next unless game_started

  currentTime += 1
  prevPos = pos.dup
  pos += car.speed

  while (pos >= N * segL) do
    pos -= N * segL
  end

  while (pos < 0) do
    pos += N * segL
  end

  if car.speed > 0 && prevPos > pos
    if cheated
      cheated = false
    else
      bestTime = currentTime if bestTime == 0 || bestTime > currentTime
      currentTime = 0
    end
  end

  if car.speed < 0 && prevPos < pos
    cheated = true
  end

  startPos = pos / segL
  sp = startPos.to_i
  car.y = H + track.lines[sp % N].y
  x = 0.0
  dx = 0.0
  gForce = 0.0

  #if camH > 1500
  #  player.move(v: :up)
  #elsif camH < 1500
  #  player.move(v: :down)
  #else
  #  player.move(v: :straight)
  #end

  if car.off_road?
    car.speed -= 4 if car.speed > 0
  elsif currentTime.even?
    car.speed -= 1 if car.speed > 0
  end

  player.move(braks: car.braking, v: car.a, h: car.y, speed: car.speed, time: currentTime)
  car.steering_wheel
  car.automatic_transmission
  track.drawBackground(sp, car.speed)
  win_w = get(:width)
  minimap&.update_pos(pos, car.x)

  projected = []
  for i in startPos..(startPos + VIEW_LOOKAHEAD)
    l = track.lines[i % N]
    # Same curve integration for every layout. Planar tracks use per-segment curve from geometry;
    # raw world (px) is only for the 2D minimap — the faux-3D project() expects this scroll model.
    l.project(car.x * roadW - x, car.y, startPos * segL - (i >= N ? N * segL : 0), car.d)
    x += dx
    dx += l.curve

    #l.clip = maxy

    # if (l.Y <= maxy)
     # next
     # end

    p = track.lines[(i-1) % N]
    maxy = l.Y

    # Nearer in the main loop = smaller (i - startPos) = larger z (drawn on top of farther strips + trees).
    d = (i - startPos)
    z_base = ROAD_STRIP_Z + (VIEW_LOOKAHEAD - d) * Z_PER_SEGMENT

    projected << { x: l.X, y: l.Y, p_y: p.Y, w: l.W, scale: l.scale, i: i, z_base: z_base }

    grass  = ((i/3) % 2) > 0 ? '#10c810' : '#009a00'
    rumble = ((i/3) % 2) > 0 ? '#ffffff' : '#000000'
    road   = ((i/3) % 2) > 0 ? '#6b6b6b' : '#696969'

    y_grass0, y_grass1 = [p.Y, l.Y].minmax
    track.drawQuad(i % N, 0, grass, 0, y_grass0, win_w, 0, y_grass1, win_w, z: z_base + 0.0)
    track.draw_road_strip(i % N, 1, rumble, p, l, p.W * 1.2, l.W * 1.2, z: z_base + 0.1)
    track.draw_road_strip(i % N, 2, road, p, l, p.W, l.W, z: z_base + 0.2)
  end

  roadside_trees.draw(projected)

  gForce = -track.lines[sp % N].curve * 0.00015 * car.speed if (car.speed > 0)
  gForce = track.lines[sp % N].curve * 0.00015 * car.speed if (car.speed < 0)
  car.x += gForce
  debug.text = "Speed: #{car.speed} Angle: #{car.a} Height: #{car.y} Current: #{Time.at(currentTime / 60.0).utc.strftime("%M:%S:%L")} Best: #{Time.at(bestTime / 60.0).utc.strftime("%M:%S:%L")}"
  speedText.text = car.speed.abs / 2
  gearText.text = car.model.gear

  # Re-order renderables by z (cheap) instead of 900x Ruby2D#z= per frame (remove+add, very slow).
  Ruby2D::DSL.window.instance_variable_get(:@objects).sort_by!(&:z)
end

show
