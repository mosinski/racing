require './lib/cars/ferrari'

class Car
  attr_accessor :model, :speed, :x, :y, :d, :a, :accelerating, :braking

  def initialize
    @model = Ferrari.new
    @speed = 0
    @a = 0
    @x = 0
    @y = 0
    @d = 0.84
    @braking = false
  end

  def automatic_transmission
    if self.speed > self.model.current_gear[:speed]
      self.model.gear_up
    elsif self.speed < self.model.prev_gear[:speed]
      self.model.gear_down
    end
  end

  def turn_left
    self.x -= self.speed * 0.0002
    self.a -= (self.speed * 0.0008).round(1) if self.a > -2
  end

  def turn_right
    self.x += self.speed * 0.0002
    self.a += (self.speed * 0.0008).round(1) if self.a < 2
  end

  def accelerate
    if self.speed <= self.model.current_gear[:speed]
      self.speed += self.model.current_gear[:acceleration]
    end
  end

  def brake
    if self.speed > -50
      self.speed -= self.model.breaks
      self.braking = true
    end
  end

  def off_road?
    self.x > 1 || self.x < -1
  end

  def steering_wheel
    if self.a > 0
      self.a = (self.a - 0.1).round(1)
    elsif self.a < 0
      self.a = (self.a + 0.1).round(1)
    end
  end
end
