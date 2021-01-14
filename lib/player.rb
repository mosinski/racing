class Player < Sprite
  attr_accessor :h, :v, :s, :l

  def initialize
    @h = :straight
    @v = :straight
    @s = nil
    @l = false

    super(
      'images/ferrari.png',
      y: 686,
      x: 432,
      animations: animations
    )

    move
  end

  def move(h: self.h, v: self.h, s: self.s, l: self.l)
    self.h = h
    self.v = v
    self.s = s
    self.l = l

    animation = [h, v, s].compact.join("_").to_sym
    self.play animation: animation, loop: l
  end

  def animations
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
      down_straight: [],
      down_straight_stop: [],
      down_left: [],
      down_left_stop: [],
      down_right: [],
      down_right_stop: []
    }
  end
end
