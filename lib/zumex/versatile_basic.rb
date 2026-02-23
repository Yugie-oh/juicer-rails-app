# frozen_string_literal: true

module Zumex
  # Main juicer simulation — Zumex Versatile Basic Commercial Citrus Juicer
  class VersatileBasic
    FRUITS_PER_MINUTE = 22
    FRUIT_DIAMETER_MIN_MM = 65
    FRUIT_DIAMETER_MAX_MM = 81
    WATTAGE = 380
    WEIGHT_KG = 54.0
    JUICE_CAPACITY_ML = 2000

    attr_reader :feeder, :peel_bucket, :dimensions
    attr_accessor :motor_error_simulation, :unsafe_action_simulation

    def initialize(colour: :orange)
      @colour = colour
      @powered_on = false
      @juicing = false
      @safety_shutdown = false
      @feeder = Feeder.new
      @peel_bucket = PeelBucket.new
      @dimensions = Dimensions.new(55.0, 47.0, 85.0)
      @juice_collected_ml = 0
      @fruits_juiced = 0
      @motor_error_simulation = false
      @unsafe_action_simulation = false
    end

    def power_on
      return false if @safety_shutdown
      @powered_on = true
      true
    end

    def power_off
      @powered_on = false
      @juicing = false
      true
    end

    def powered_on?
      @powered_on
    end

    def juicing?
      @juicing
    end

    def safety_shutdown?
      @safety_shutdown
    end

    def juice_one
      return :power_off unless @powered_on
      return :safety_shutdown if @safety_shutdown
      return :motor_error if @motor_error_simulation
      return :unsafe_action if @unsafe_action_simulation
      return :feeder_empty if feeder.empty?

      fruit = feeder.take_next
      return :invalid_fruit unless fruit&.valid_for_versatile_basic?

      juice_ml = (fruit.weight_grams * 0.4).round
      return :juice_full if @juice_collected_ml + juice_ml > JUICE_CAPACITY_ML

      @juice_collected_ml += juice_ml
      @fruits_juiced += 1
      peel_bucket.add_peel

      juice_ml
    end

    def start_juicing
      return false unless @powered_on
      return false if @safety_shutdown
      @juicing = true
      true
    end

    def stop_juicing
      @juicing = false
      true
    end

    def juice_batch(count)
      results = []
      count.times do
        result = juice_one
        break if result.is_a?(Symbol)
        results << result
      end
      results
    end

    def clear_safety_shutdown
      @safety_shutdown = false
    end

    def trigger_motor_seizure!
      @safety_shutdown = true
      @juicing = false
      @powered_on = false
    end

    def juice_collected_ml
      @juice_collected_ml
    end

    def empty_juice!
      @juice_collected_ml = 0
    end

    def fruits_juiced
      @fruits_juiced
    end

    def juice_full?
      @juice_collected_ml >= JUICE_CAPACITY_ML ||
        (feeder.fruit_queue.any? && @juice_collected_ml + (feeder.fruit_queue.first.weight_grams * 0.4).round > JUICE_CAPACITY_ML)
    end

    def spec
      {
        brand: "Zumex",
        model: "Versatile Basic",
        colour: @colour,
        wattage: WATTAGE,
        weight_kg: WEIGHT_KG,
        fruits_per_minute: FRUITS_PER_MINUTE,
        feeder_capacity_kg: Feeder::CAPACITY_KG,
        fruit_diameter_min_mm: FRUIT_DIAMETER_MIN_MM,
        fruit_diameter_max_mm: FRUIT_DIAMETER_MAX_MM,
        dimensions: dimensions.to_s,
      }
    end

    def to_s
      "Zumex Versatile Basic (#{@colour}) - #{@fruits_juiced} fruits juiced, #{@juice_collected_ml} ml collected"
    end

    # Restore juicer state from a session hash (symbol or string keys)
    def self.restore(hash)
      return new(colour: :orange) unless hash.is_a?(Hash)

      juicer = new(colour: :orange)
      juicer.instance_variable_set(:@powered_on, hash[:powered_on] || hash["powered_on"])
      juicer.instance_variable_set(:@safety_shutdown, hash[:safety_shutdown] || hash["safety_shutdown"])
      juicer.instance_variable_set(:@juice_collected_ml, (hash[:juice_collected_ml] || hash["juice_collected_ml"]).to_i)
      juicer.instance_variable_set(:@fruits_juiced, (hash[:fruits_juiced] || hash["fruits_juiced"]).to_i)

      peel_count = (hash[:peel_count] || hash["peel_count"]).to_i
      peel_count.times { juicer.peel_bucket.add_peel }

      queue = hash[:feeder_queue] || hash["feeder_queue"] || []
      queue.each do |f|
        kind = (f[:kind] || f["kind"] || "orange").to_sym
        weight = (f[:weight_grams] || f["weight_grams"] || 150).to_i
        diam = (f[:diameter_mm] || f["diameter_mm"] || 70).to_i
        fruit = Zumex::Fruit.new(diam, weight, kind)
        juicer.feeder.load(fruit)
      end

      juicer
    end
  end
end
