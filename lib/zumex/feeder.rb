# frozen_string_literal: true

module Zumex
  # Simulated feeder component
  class Feeder
    CAPACITY_KG = 10.0

    attr_reader :fruit_queue

    def initialize
      @fruit_queue = []
    end

    def load(fruit)
      return false unless fruit.is_a?(Zumex::Fruit)
      return false unless fruit.valid_for_versatile_basic?
      return false if current_load_kg + (fruit.weight_grams / 1000.0) > CAPACITY_KG

      @fruit_queue << fruit
      true
    end

    def load_batch(fruits)
      added = 0
      fruits.each do |f|
        break if current_load_kg >= CAPACITY_KG
        added += 1 if load(f)
      end
      added
    end

    def take_next
      @fruit_queue.shift
    end

    def current_load_kg
      @fruit_queue.sum { |f| f.weight_grams / 1000.0 }
    end

    def empty?
      @fruit_queue.empty?
    end

    def capacity_remaining_kg
      [ CAPACITY_KG - current_load_kg, 0 ].max
    end
  end
end
