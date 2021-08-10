class Player < Sprite
  attr_accessor :h, :v, :s, :l, :i, :j

  def initialize
    @h = :straight
    @v = :straight
    @s = nil
    @l = true
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

  def move(h: self.h, v: self.h, s: self.s, l: self.l, braks: false, angle: 0)
    self.h = h
    self.v = v
    self.s = s
    self.l = l
    self.j = (angle + 3).floor

    animation = "#{self.i}#{self.j}"
    animation += "_brake" if braks
    puts animation.to_sym.inspect
    puts animations[animation.to_sym].inspect

    self.play animation: animation.to_sym, loop: l
  end

  def animations
    {
      :"11" => [],
      :"11_brake" => [],
      :"12" => [],
      :"12_brake" => [],
      :"13" => [],
      :"13_brake" => [],
      :"14" => [],
      :"14_brake" => [],
      :"15" => [],
      :"15_brake" => [],
      :"21" => [
        {
          x: 830, y: 418,
          width: 123, height: 60,
          time: 300
        },
        {
          x: 962, y: 418,
          width: 123, height: 60,
          time: 300
        }
      ],
      :"21_brake" => [],
      :"22" => [
        {
          x: 830, y: 242,
          width: 120, height: 60,
          time: 200
        },
        {
          x: 962, y: 242,
          width: 120, height: 60,
          time: 200
        }
      ],
      :"22_brake" => [],
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
          x: 135, y: 242,
          width: 123, height: 60,
          time: 200
        }
      ],
      :"24_brake" => [],
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
      :"25_brake" => [],
      :"31" => [],
      :"31_brake" => [],
      :"32" => [],
      :"32_brake" => [],
      :"33" => [],
      :"33_brake" => [],
      :"34" => [],
      :"34_brake" => [],
      :"35" => [],
      :"35_brake" => []
    }
  end

  def animations_old
    {
      straight_straight: [
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
      straight_straight_stop: [
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
      left_straight: [
        {
          x: 830, y: 242,
          width: 120, height: 60,
          time: 200
        },
        {
          x: 962, y: 242,
          width: 120, height: 60,
          time: 200
        },
        {
          x: 830, y: 418,
          width: 123, height: 60,
          time: 300
        },
        {
          x: 962, y: 418,
          width: 123, height: 60,
          time: 300
        }
      ],
      left_straight_stop: [],
      right_straight: [
        {
          x: 2, y: 242,
          width: 123, height: 60,
          time: 200
        },
        {
          x: 135, y: 242,
          width: 123, height: 60,
          time: 200
        },
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
      right_straight_stop: [
        {
          x: 272, y: 242,
          width: 120, height: 60,
          time: 200
        },
        {
          x: 414, y: 242,
          width: 120, height: 60,
          time: 200
        }
      ],
      straight_up: [
        {
          x: 2, y: 0,
          width: 123, height: 65,
          time: 200
        },
        {
          x: 135, y: 0,
          width: 123, height: 65,
          time: 200
        }
      ],
      up_straight_stop: [],
      up_left: [],
      up_left_stop: [],
      up_right: [],
      up_right_stop: [],
      down_straight: [
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
      down_straight_stop: [],
      down_left: [],
      down_left_stop: [],
      down_right: [],
      down_right_stop: []
    }
  end
end
