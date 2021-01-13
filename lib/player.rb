class Player < Sprite
  def initialize
    super(
      'images/ferrari.png',
      y: 686,
      x: 432,
      animations: {
        straight: [
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
        straight_stop: [
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
        left: [
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
        right: [
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
        right_stop: [
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
      }
    )
  end
end
