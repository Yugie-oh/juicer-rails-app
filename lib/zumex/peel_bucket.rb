# frozen_string_literal: true

module Zumex
  # Simulated peel waste bucket
  class PeelBucket
    CAPACITY_LITRES = 15.0
    PEEL_VOLUME_PER_FRUIT_L = 0.25

    attr_reader :peel_count

    def initialize
      @peel_count = 0
    end

    def add_peel
      @peel_count += 1
    end

    def full?
      (@peel_count * PEEL_VOLUME_PER_FRUIT_L) >= CAPACITY_LITRES
    end

    def empty!
      @peel_count = 0
    end

    def utilization_percent
      [100.0 * peel_count * PEEL_VOLUME_PER_FRUIT_L / CAPACITY_LITRES, 100].min.round(1)
    end
  end
end
