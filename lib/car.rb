require './lib/cars/ferrari'

class Car
  attr_accessor :model, :speed

  def initialize
    @model = Ferrari.new
    @speed = 0
  end

  def automatic_transmission
    if self.speed > self.model.current_gear[:speed]
      self.model.gear_up
    elsif self.speed < self.model.prev_gear[:speed]
      self.model.gear_down
    end
  end
end
