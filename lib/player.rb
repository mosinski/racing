class Player < Sprite
  attr_accessor :h, :v, :s

  def initialize
    @h = 1500
    @v = 3

    super(
      'images/ferrari.png',
      y: 686,
      x: 432,
      animations: animations
    )
  end

  def move(h: self.h, v: self.h, s: self.s, braks: false, time: 0, speed: 0)
    return unless skip?(speed, time)
    row = calculate_h(h)
    self.v = (v + 3).floor
    self.h = h

    animation = "#{row}#{self.v}"
    #animation = "21"
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
      :"13" => [
        {
          x: 2, y: 2,
          width: 120, height: 65,
          time: 200
        },
        {
          x: 136, y: 2,
          width: 120, height: 65,
          time: 200
        }
      ],
      :"13_brake" => [
        {
          x: 273, y: 2,
          width: 120, height: 65,
          time: 200
        },
        {
          x: 413, y: 2,
          width: 120, height: 65,
          time: 200
        }
      ],
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
          width: 120, height: 59,
          time: 200
        },
        {
          x: 964, y: 242,
          width: 120, height: 59,
          time: 200
        }
      ],
      :"22_brake" => [
        {
          x: 554, y: 242,
          width: 120, height: 59,
          time: 200
        },
        {
          x: 692, y: 242,
          width: 120, height: 59,
          time: 200
        }
      ],
      :"23" => [
        {
          x: 2, y: 65,
          width: 120, height: 59,
          time: 200
        },
        {
          x: 135, y: 65,
          width: 120, height: 59,
          time: 200
        }
      ],
      :"23_brake" => [
        {
          x: 272, y: 65,
          width: 120, height: 59,
          time: 200
        },
        {
          x: 414, y: 65,
          width: 120, height: 59,
          time: 200
        }
      ],
      :"24" => [
        {
          x: 2, y: 242,
          width: 123, height: 59,
          time: 200
        },
        {
          x: 136, y: 242,
          width: 123, height: 59,
          time: 200
        }
      ],
      :"24_brake" => [
        {
          x: 273, y: 242,
          width: 123, height: 59,
          time: 200
        },
        {
          x: 412, y: 242,
          width: 123, height: 59,
          time: 200
        }
      ],
      :"25" => [
        {
          x: 2, y: 419,
          width: 123, height: 59,
          time: 200
        },
        {
          x: 135, y: 419,
          width: 123, height: 59,
          time: 200
        }
      ],
      :"25_brake" => [
        {
          x: 273, y: 419,
          width: 123, height: 59,
          time: 200
        },
        {
          x: 413, y: 419,
          width: 123, height: 59,
          time: 200
        }
      ],
      :"31" => [
        {
          x: 830, y: 479,
          width: 123, height: 50,
          time: 300
        },
        {
          x: 964, y: 479,
          width: 123, height: 50,
          time: 300
        }
      ],
      :"31_brake" => [
        {
          x: 553, y: 479,
          width: 123, height: 50,
          time: 300
        },
        {
          x: 692, y: 479,
          width: 123, height: 50,
          time: 300
        }
      ],
      :"32" => [
        {
          x: 830, y: 302,
          width: 120, height: 50,
          time: 200
        },
        {
          x: 964, y: 302,
          width: 120, height: 50,
          time: 200
        }
      ],
      :"32_brake" => [
        {
          x: 553, y: 302,
          width: 120, height: 50,
          time: 200
        },
        {
          x: 692, y: 302,
          width: 120, height: 50,
          time: 200
        }
      ],
      :"33" => [
        {
          x: 1, y: 125,
          width: 123, height: 50,
          time: 200
        },
        {
          x: 135, y: 125,
          width: 123, height: 50,
          time: 200
        }
      ],
      :"33_brake" => [
        {
          x: 273, y: 125,
          width: 120, height: 50,
          time: 200
        },
        {
          x: 412, y: 125,
          width: 120, height: 50,
          time: 200
        }
      ],
      :"34" => [
        {
          x: 2, y: 302,
          width: 123, height: 50,
          time: 200
        },
        {
          x: 136, y: 302,
          width: 123, height: 50,
          time: 200
        }
      ],
      :"34_brake" => [
        {
          x: 273, y: 302,
          width: 123, height: 50,
          time: 200
        },
        {
          x: 412, y: 302,
          width: 123, height: 50,
          time: 200
        }
      ],
      :"35" => [
        {
          x: 2, y: 479,
          width: 123, height: 51,
          time: 200
        },
        {
          x: 136, y: 479,
          width: 123, height: 51,
          time: 200
        }
      ],
      :"35_brake" => [
        {
          x: 273, y: 479,
          width: 123, height: 51,
          time: 200
        },
        {
          x: 412, y: 479,
          width: 123, height: 51,
          time: 200
        }
      ]
    }
  end

  def calculate_h(h)
    if h > self.h
      1
    elsif h < self.h
     3
    else
     2
    end
  end

  def skip?(speed, time)
    if speed == 0
      true
    elsif speed < 60
      time % 30 == 0
    elsif speed < 120
      time % 4 == 0
    elsif speed < 200
      time % 2 == 0
    else
      true
    end
  end
end
