# frozen_string_literal: true

module Zumex
  # Represents a citrus fruit for juicing simulation
  Fruit = Struct.new(:diameter_mm, :weight_grams, :kind) do
    def self.orange(weight: 150)
      new(70, weight, :orange)
    end

    def self.lemon(weight: 120)
      new(65, weight, :lemon)
    end

    def self.grapefruit(weight: 250)
      new(81, weight, :grapefruit)
    end

    def valid_for_versatile_basic?
      (65..81).cover?(diameter_mm)
    end
  end
end
