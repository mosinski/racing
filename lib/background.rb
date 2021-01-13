class Background
  attr_accessor :images

  def initialize(x = 0, y = 0)
    @images = [
      Image.new(
        'images/bg.png',
        width: 1024,
        y: y,
        x: x
      ),
      Image.new(
        'images/bg.png',
        width: 1024,
        y: y,
        x: x - 1024
      )
    ]
  end

  def move(x)
    self.images.each do |image|
      image.x += x

      if image.x < -1024
        image.x += 2048
      elsif image.x > 1024
        image.x -= 2048
      end
    end
  end
end
