require 'ruby2d'
require './lib/background'
require './lib/player'
require './lib/car'
require './lib/track'

##
# Window
##

set title: 'Racing',
    width: 1024,
    height: 768,
    resizable: false

roadW = 2000;
segL = 200;

H = 1500
N = 1600

car = Car.new
track = Track.new
player = Player.new
debug = Text.new('', x: 10, y: 10, color: 'red')
gearText = Text.new('N', x: 870, y: 720, size: 30, font: 'assets/fonts/LCD.TTF', color: 'red')
speedText = Text.new('0', x: 900, y: 700, size: 55, font: 'assets/fonts/LCD.TTF', color: 'black')
x = 0
dx = 0
pos = 0
bestTime = 0
currentTime = 0
lapTimes = Array.new(5, 0)
startPos = pos / segL
car.y = track.lines[startPos].y + H
maxy = get(:height)

on :key_held do |event|
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
  case event.key.to_sym
  when :down
    car.braking = false
  end
end

cheated = false

update do
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
  car.y = H + track.lines[startPos].y
  x = 0
  dx = 0
  gForce = 0

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

  player.move(braks: car.braking, angle: car.a)
  car.steering_wheel
  car.automatic_transmission
  track.drawBackground(startPos, car.speed)

  for i in startPos..startPos + 300
    l = track.lines[i % N];
    l.project(car.x * roadW - x, car.y, startPos * segL - (i >= N ? N * segL : 0), car.d)
    x += dx;
    dx += l.curve;

    #l.clip = maxy

    # if (l.Y <= maxy)
     # next
    # end

    maxy = l.Y

    grass  = ((i/3) % 2) > 0 ? '#10c810' : '#009a00'
    rumble = ((i/3) % 2) > 0 ? '#ffffff' : '#000000'
    road   = ((i/3) % 2) > 0 ? '#6b6b6b' : '#696969'

    p = track.lines[(i-1) % N]

    track.drawQuad(i % N, 0, grass, 0, p.Y, get(:width), 0, l.Y, get(:width))
    track.drawQuad(i % N, 1, rumble, p.X, p.Y, p.W*1.2, l.X, l.Y, l.W * 1.2)
    track.drawQuad(i % N, 2, road, p.X, p.Y, p.W, l.X, l.Y, l.W)
  end

  gForce = -track.lines[startPos].curve * 0.00015 * car.speed if (car.speed > 0)
  gForce = track.lines[startPos].curve * 0.00015 * car.speed if (car.speed < 0)
  car.x += gForce
  debug.text = "Speed: #{car.speed} Angle: #{car.a} Current: #{Time.at(currentTime / 60.0).utc.strftime("%M:%S:%L")} Best: #{Time.at(bestTime / 60.0).utc.strftime("%M:%S:%L")}"
  speedText.text = car.speed.abs / 2
  gearText.text = car.model.gear
end

show
