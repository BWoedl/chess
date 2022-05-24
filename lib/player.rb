# frozen_string_literal: true

class Player
  attr_accessor :name, :number, :color

  def initialize(name, number = 1, color = 'white')
    @name = name
    @number = number
    @color = color
  end
end
