require './lib/cars/ferrari'

class Car
  attr_accessor :model, :speed

  def initialize
    @model = Ferrari.new
    @speed = 0
  end
end
