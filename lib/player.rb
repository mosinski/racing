class Player < Sprite
  attr_accessor :h, :v, :s, :i, :j

  def initialize
    @h = :straight
    @v = :straight
    @s = nil
    @i = 2
    @j = 3

    super(
      'images/ferrari.png',
      y: 686,
      x: 432,
      animations: animations
    )

    #move
  end

  def move(h: self.h, v: self.h, s: self.s, braks: false, angle: 0)
    self.h = h
    self.v = v
    self.s = s
    self.j = (angle + 3).floor

    animation = "#{self.i}#{self.j}"
    #animation = "25"
    animation += "_brake" if braks
    puts animation.to_sym.inspect
    puts animations[animation.to_sym].inspect

    self.play animation: animation.to_sym, loop: true
  end

  def animations
    {
      :"11" => [
        {
          x: 830, y: 354,
          width: 123, height: 65,
          time: 300
        },
        {
          x: 963, y: 354,
          width: 123, height: 65,
          time: 300
        }
      ],
      :"11_brake" => [
        {
          x: 555, y: 354,
          width: 123, height: 65,
          time: 300
        },
        {
          x: 692, y: 354,
          width: 123, height: 65,
          time: 300
        }
      ],
      :"12" => [
        {
          x: 830, y: 177,
          width: 123, height: 65,
          time: 200
        },
        {
          x: 963, y: 177,
          width: 123, height: 65,
          time: 200
        }
      ],
      :"12_brake" => [
        {
          x: 555, y: 177,
          width: 123, height: 65,
          time: 200
        },
        {
          x: 692, y: 177,
          width: 123, height: 65,
          time: 200
        }
      ],
      :"13" => [],
      :"13_brake" => [],
      :"14" => [
        {
          x: 2, y: 177,
          width: 123, height: 65,
          time: 200
        },
        {
          x: 135, y: 177,
          width: 123, height: 65,
          time: 200
        }
      ],
      :"14_brake" => [
        {
          x: 273, y: 177,
          width: 123, height: 65,
          time: 200
        },
        {
          x: 413, y: 177,
          width: 123, height: 65,
          time: 200
        }
      ],
      :"15" => [
        {
          x: 2, y: 354,
          width: 123, height: 65,
          time: 300
        },
        {
          x: 135, y: 354,
          width: 123, height: 65,
          time: 300
        }
      ],
      :"15_brake" => [
        {
          x: 273, y: 354,
          width: 123, height: 65,
          time: 300
        },
        {
          x: 413, y: 354,
          width: 123, height: 65,
          time: 300
        }
      ],
      :"21" => [
        {
          x: 830, y: 419,
          width: 123, height: 59,
          time: 300
        },
        {
          x: 964, y: 419,
          width: 123, height: 59,
          time: 300
        }
      ],
      :"21_brake" => [
        {
          x: 554, y: 419,
          width: 123, height: 59,
          time: 300
        },
        {
          x: 692, y: 419,
          width: 123, height: 59,
          time: 300
        }
      ],
      :"22" => [
        {
          x: 830, y: 242,
          width: 120, height: 60,
          time: 200
        },
        {
          x: 964, y: 242,
          width: 120, height: 60,
          time: 200
        }
      ],
      :"22_brake" => [
        {
          x: 554, y: 242,
          width: 120, height: 60,
          time: 200
        },
        {
          x: 692, y: 242,
          width: 120, height: 60,
          time: 200
        }
      ],
      :"23" => [
        {
          x: 2, y: 65,
          width: 120, height: 60,
          time: 200
        },
        {
          x: 135, y: 65,
          width: 120, height: 60,
          time: 200
        }
      ],
      :"23_brake" => [
        {
          x: 272, y: 65,
          width: 120, height: 60,
          time: 200
        },
        {
          x: 414, y: 65,
          width: 120, height: 60,
          time: 200
        }
      ],
      :"24" => [
        {
          x: 2, y: 242,
          width: 123, height: 60,
          time: 200
        },
        {
          x: 136, y: 242,
          width: 123, height: 60,
          time: 200
        }
      ],
      :"24_brake" => [
        {
          x: 273, y: 242,
          width: 123, height: 60,
          time: 200
        },
        {
          x: 412, y: 242,
          width: 123, height: 60,
          time: 200
        }
      ],
      :"25" => [
        {
          x: 2, y: 419,
          width: 123, height: 60,
          time: 200
        },
        {
          x: 135, y: 419,
          width: 123, height: 60,
          time: 200
        }
      ],
      :"25_brake" => [
        {
          x: 273, y: 419,
          width: 123, height: 60,
          time: 200
        },
        {
          x: 413, y: 419,
          width: 123, height: 60,
          time: 200
        }
      ],
      :"31" => [],
      :"31_brake" => [],
      :"32" => [],
      :"32_brake" => [],
      :"33" => [
        {
          x: 2, y: 180,
          width: 123, height: 60,
          time: 200
        },
        {
          x: 135, y: 180,
          width: 123, height: 60,
          time: 200
        }
      ],
      :"33_brake" => [],
      :"34" => [],
      :"34_brake" => [],
      :"35" => [],
      :"35_brake" => []
    }
  end
end
