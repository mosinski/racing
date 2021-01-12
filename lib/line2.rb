class Line2
  attr_accessor :x, :y, :z
  attr_accessor :X, :Y, :W
  attr_accessor :curve, :clip, :scale
  attr_accessor :sprite, :spriteX

  def initialize
    @x, @y, @z = 0, 0, 0
    @X, @Y, @W = 0, 0, 0
    @curve = 0
    @clip = 0
    @scale = 0.0
    @spriteX = 0.0
  end

  def project(camX, camY, camZ, camD)
    self.scale = camD / (z - camZ)
    self.X = (1 + scale * (x - camX)) * 512
    self.Y = (1 - scale * (y - camY)) * 384
    self.W = scale * 2000 * 512
  end
end
