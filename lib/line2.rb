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
    @scale = 0
    @spriteX = 0.0
  end

  def project(camX, camY, camZ, camD)
    self.scale = camD / self.z - camZ
    self.X = (1 + self.scale * (self.x - camX)) * 1024 / 2
    self.Y = (1 - self.scale * (self.y - camY)) * 768 / 2
    self.W = self.scale * 2000 * 1024 / 2
  end
end
