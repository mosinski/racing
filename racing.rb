require 'ruby2d'
require './lib/background'
require './lib/player'
require './lib/track'
require './lib/car'

##
# Window
##

set title: 'Racing',
    width: 1024,
    height: 768,
    resizable: false

roadW = 2000;
segL = 200;
camD = 0.84;

H = 1500
N = 1600

background = Background.new
t = Track.new
car = Car.new
debug = Text.new('', x: 10, y: 10, color: 'red')
gearText = Text.new('N', x: 870, y: 720, size: 30, font: 'fonts/LCD-Bold/LCDWinTT/LCD2U___.TTF', color: 'red')
speedText = Text.new('0', x: 900, y: 700, size: 55, font: 'fonts/LCD-Bold/LCDWinTT/LCD2U___.TTF', color: 'black')
x = 0
dx = 0
pos = 0
speed = 0
playerX = 0
bestTime = 0
currentTime = 0
lapTimes = Array.new(5, 0)
startPos = pos / segL
camH = t.lines[startPos].y + H
maxy = 768 #get(:height)
player = Player.new
start = false

on :key do |event|
  start = true
end

on :key_held do |event|
  case event.key.to_sym
  when :left
    playerX -= (car.speed * 0.0002)
    player.move(h: :left)
  when :right
    playerX += (car.speed * 0.0002)
    player.move(h: :right)
  when :up
    puts "Gear max speed: #{car.model.current_gear[:speed]}, Current Speed: #{car.speed}"
    if car.speed < car.model.current_gear[:speed]
      puts "Inscreasing speed"
      car.speed += car.model.current_gear[:acceleration]
    else
      puts "Switch gear"
      car.model.gear_up
    end
    player.play animation: :straight, loop: true
  when :down
    if car.speed > car.model.prev_gear[:speed]
      car.speed -= car.model.breaks if car.speed > -50
    else
      car.model.gear_down
    end
    if car.speed > 0
      player.play animation: :straight_stop, loop: true
    else
      player.play animation: :straight, loop: car.speed < 0
    end
  when :tab
    #speed *= 3 if speed < 200
  end
end

update do
  currentTime += 1 if start
  pos += car.speed

  while (pos >= N * segL) do
    pos -= N * segL
  end

  while (pos < 0) do
    pos += N * segL
  end

  startPos = pos / segL
  camH = 1500 + t.lines[startPos].y
  x = 0
  dx = 0
  gForce = 0

  if camH > 1500
    player.move(v: :up)
  elsif camH < 1500
    player.move(v: :down)
  else
    player.move(v: :straight)
  end

  if playerX > 1 || playerX < -1
    car.speed -= 4 if car.speed > 0
  end

  background.move(-t.lines[startPos].curve * (car.speed / 200.0)) if (car.speed > 0)
  background.move(t.lines[startPos].curve * (car.speed / 200.0)) if (car.speed < 0)

  for i in startPos..startPos + 300
    l = t.lines[i % N];
    l.project(playerX * roadW - x, camH, startPos * segL - (i >= N ? N * segL : 0), camD)
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

    p = t.lines[(i-1) % N]

    t.drawQuad(i % N, 0, grass, 0, p.Y, get(:width), 0, l.Y, get(:width))
    t.drawQuad(i % N, 1, rumble, p.X, p.Y, p.W*1.2, l.X, l.Y, l.W * 1.2)
    t.drawQuad(i % N, 2, road, p.X, p.Y, p.W, l.X, l.Y, l.W)
  end

  gForce = -t.lines[startPos].curve * 0.00015 * car.speed if (car.speed > 0)
  gForce = t.lines[startPos].curve * 0.00015 * car.speed if (car.speed < 0)
  playerX += gForce
  debug.text = "Speed: #{car.speed} Gear: #{car.model.gear} GForce: #{gForce} Current: #{Time.at(currentTime / 60.0).utc.strftime("%M:%S:%L")} Best: #{Time.at(bestTime / 60.0).utc.strftime("%M:%S:%L")} | #{bestTime}"
  speedText.text = car.speed.abs / 2
  gearText.text = car.model.gear
  #debug.text = "DX: #{dx} Pos: #{pos} Start Pos: #{startPos}"

  if start && startPos == 0 && car.speed > 0 && currentTime > 60
    bestTime = currentTime if bestTime == 0 || bestTime > currentTime
    currentTime = 0
  end
end

show
