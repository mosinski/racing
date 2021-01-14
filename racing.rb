require 'ruby2d'
require './lib/background'
require './lib/player'
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
camD = 0.84;

H = 1500
N = 1600

background = Background.new
t = Track.new
x = 0
dx = 0
pos = 0
speed = 0
playerX = 0
startPos = pos / segL
camH = t.lines[startPos].y + H
maxy = 768 #get(:height)
player = Player.new

on :key_held do |event|
  case event.key.to_sym
  when :left
    playerX -= 0.1
    player.move(h: :left)
  when :right
    playerX += 0.1
    player.move(h: :right)
  when :up
    speed += 50 if speed < 400
    player.play animation: :straight, loop: true
  when :down
    speed -= 3 if speed > -50
    if speed > 0
      player.play animation: :straight_stop, loop: true
    else
      player.play animation: :straight, loop: speed < 0
    end
  when :tab
    #speed *= 3 if speed < 200
  end
end

update do
  pos += speed

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

  if camH > 1500
    player.move(v: :up)
  elsif camH < 1500
    player.move(v: :down)
  else
    player.move(v: :straight)
  end

  background.move(-t.lines[startPos].curve*2) if (speed > 0)
  background.move(t.lines[startPos].curve*2) if (speed < 0)

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
end

show
