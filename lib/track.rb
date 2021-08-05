require './lib/line2'

class Track
  attr_accessor :lines, :quads, :background

  def initialize
    @lines = []
    @quads = []
    @background = Background.new

    drawLines
    drawQuads
  end

  def drawLines
    for i in 0..1599
      line = Line2.new
      line.z = i * 200

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

      self.lines << line
    end
  end

  def drawQuads
    for i in 0..1599
      self.quads << Array.new(3) {
        Quad.new(
          x1: 0, y1: 0,
          x2: 0, y2: 0,
          x3: 0, y3: 0,
          x4: 0, y4: 0
        )
      }
    end
  end

  def drawQuad(i, j, color, x1, y1, w1, x2, y2, w2)
    quad = self.quads[i][j]
    quad.x1 = x1-w1
    quad.y1 = y1
    quad.x2 = x2-w2
    quad.y2 = y2
    quad.x3 = x2+w2
    quad.y3 = y2
    quad.x4 = x1+w1
    quad.y4 = y1
    quad.color = color
  end

  def drawBackground(pos, speed)
    if speed > 0
      background.move(-self.lines[pos].curve * (speed / 200.0))
    elsif speed < 0
      background.move(self.lines[pos].curve * (speed / 200.0))
    end
  end
end
