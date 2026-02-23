# frozen_string_literal: true

require "test_helper"

module Zumex
  class VersatileBasicTest < ActiveSupport::TestCase
    test "powers on and off" do
      j = VersatileBasic.new
      assert_not j.powered_on?
      assert j.power_on
      assert j.powered_on?
      j.power_off
      assert_not j.powered_on?
    end

    test "juice_one returns :feeder_empty when feeder empty" do
      j = VersatileBasic.new
      j.power_on
      assert_equal :feeder_empty, j.juice_one
    end

    test "juice_one returns :power_off when off" do
      j = VersatileBasic.new
      j.feeder.load(Fruit.orange)
      assert_equal :power_off, j.juice_one
    end

    test "juices one fruit and updates stats" do
      j = VersatileBasic.new
      j.power_on
      j.feeder.load(Fruit.orange(weight: 150))
      result = j.juice_one
      assert result.is_a?(Integer)
      assert_equal 60, result
      assert_equal 1, j.fruits_juiced
      assert_equal 60, j.juice_collected_ml
    end

    test "safety shutdown prevents juicing" do
      j = VersatileBasic.new
      j.power_on
      j.feeder.load(Fruit.orange)
      j.trigger_motor_seizure!
      assert j.safety_shutdown?
      assert_not j.powered_on?
      assert_equal :safety_shutdown, j.juice_one
    end

    test "restore builds juicer from session hash" do
      h = {
        powered_on: true,
        safety_shutdown: false,
        juice_collected_ml: 100,
        fruits_juiced: 2,
        peel_count: 2,
        feeder_queue: [{ diameter_mm: 70, weight_grams: 150, kind: "orange" }]
      }
      j = VersatileBasic.restore(h)
      assert j.powered_on?
      assert_equal 100, j.juice_collected_ml
      assert_equal 2, j.fruits_juiced
      assert_equal 1, j.feeder.fruit_queue.size
    end
  end
end
