class Player < Sprite
  def initialize
    super(
      'images/ferrari.png',
      y: 686,
      x: 432,
      animations: {
        straight: [
          {
            x: 0, y: 65,
            width: 120, height: 60,
            time: 200
          },
          {
            x: 134, y: 65,
            width: 120, height: 60,
            time: 200
          }
        ]
      }
    )
  end
end
