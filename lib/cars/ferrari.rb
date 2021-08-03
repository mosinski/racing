class Ferrari
  attr_accessor :gears, :gear, :breaks

  def initialize
    @gears = {
      R: { speed: 50, acceleration: 1 },
      N: { speed: 0, acceleration: 0 },
      1 => { speed: 80, acceleration: 5 },
      2 => { speed: 150, acceleration: 4 },
      3 => { speed: 220, acceleration: 3 },
      4 => { speed: 300, acceleration: 2 },
      5 => { speed: 380, acceleration: 1 },
      6 => { speed: 420, acceleration: 1 },
    }
    @gear = :N
    @breaks = 3
  end

  def gear_up
    puts "In gear up"
    puts "UP: #{gears.keys[gear_index + 1]}"
    if up = gears.keys[gear_index + 1]
      self.gear = up
    end
  end

  def gear_down
    if down = gears.keys[gear_index - 1]
      self.gear = down
    end
  end

  def current_gear
    gears[self.gear]
  end

  def prev_gear
    if down = gears.keys[gear_index - 1]
      gears[down]
    end
  end

  def gear_index
    gears.keys.index(gear)
  end
end
