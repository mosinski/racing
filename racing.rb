require 'ruby2d'
require './lib/line2'

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

def drawQuad(color, x1, y1, w1, x2, y2, w2)
  Quad.new(
    x1: x1-w1, y1: y1,
    x2: x2-w2, y2: y2,
    x3: x2+w2, y3: y2,
    x4: x1+w1, y4: y1,
    color: color
  )
end

lines = []

for i in 0..1600
  line = Line2.new
  line.z = i * segL

  if (i > 300 && i < 700)
    line.curve = 0.5
  end

  if (i > 1100)
    line.curve -= 0.7
  end

  if (i < 300 && i % 20 == 0)
    #line.spriteX -= 2.5
    #line.sprite = object[5]
  end

  if (i % 17 == 0)
    #line.spriteX = 2.0
    #line.sprite = object[6]
  end

  if (i > 300 && i % 20 == 0)
    #line.spriteX -= 0.7
    #line.sprite = object[4]
  end

  if (i > 800 && i % 20 == 0)
    #line.spriteX -= 1.2
    #line.sprite = object[1]
  end

  if (i == 400)
    #line.spriteX -= 1.2
    #line.sprite = object[7]
  end

  if (i > 750)
    line.y = Math.sin(i/30.0) * 1500
  end

  lines << line
end

H = 1500
N = lines.count
x = 0
dx = 0
pos = 0
speed = 0
playerX = 0
startPos = pos / segL
camH = lines[startPos].y + H
maxy = 768 #get(:height)

on :key_held do |event|
  case event.key.to_sym
  when :left
    playerX -= 0.1
  when :right
    playerX += 0.1
  when :up
    speed += 200 if speed < 1000
  when :down
    speed -= 200 if speed > -400
  when :tab
    #speed *= 3
  end
end

update do
  clear
  Image.new('images/bg.png', width: 1024)
  pos += speed;

  while (pos >= N * segL) do
    pos -= N * segL
  end

  while (pos < 0) do
    pos += N * segL
  end

  startPos = pos / segL

  #if (speed>0) sBackground.move(-lines[startPos].curve*2,0);
  #if (speed<0) sBackground.move( lines[startPos].curve*2,0);

  for i in startPos..startPos + 300
    l = lines[i % N];
    l.project(playerX * roadW - x, camH, startPos * segL - (i >= N ? N * segL : 0), camD)
    #x += dx;
    #dx += l.curve;

    #l.clip = maxy

    #puts l.Y

    if (l.Y >= maxy)
      next
    end

    #maxy = l.Y

    grass  = ((i/3) % 2) > 0 ? '#10c810' : '#009a00'
    rumble = ((i/3) % 2) > 0 ? '#ffffff' : '#000000'
    road   = ((i/3) % 2) > 0 ? '#6b6b6b' : '#696969'

    p = lines[(i-1) % N]

    drawQuad(grass, 0, p.Y, get(:width), 0, l.Y, get(:width))
    drawQuad(rumble, p.X, p.Y, p.W*1.2, l.X, l.Y, l.W * 1.2)
    drawQuad(road, p.X, p.Y, p.W, l.X, l.Y, l.W)
  end
end

show
