# frozen_string_literal: true

class SimulatorController < ApplicationController
  include SimulatorHelper

  before_action :ensure_juicer

  def show
    # Renders simulator/show
  end

  def power_toggle
    j = current_juicer
    if j.safety_shutdown?
      j.clear_safety_shutdown
      j.power_on
      flash[:notice] = "Safety cleared — powered on."
    elsif j.powered_on?
      j.power_off
      flash[:notice] = "Power off."
    else
      j.power_on
      flash[:notice] = "Power on."
    end
    save_juicer_to_session(j)
    redirect_to simulator_path
  end

  def load
    count = [(params[:count] || 20).to_i, 1].max
    count = 66 if count > 66
    oranges = count.times.map { Zumex::Fruit.orange(weight: 150) }
    loaded = current_juicer.feeder.load_batch(oranges)
    save_juicer_to_session(current_juicer)
    flash[:notice] = "Loaded #{loaded} oranges (#{current_juicer.feeder.current_load_kg.round(2)} kg)."
    redirect_to simulator_path
  end

  def juice_batch
    j = current_juicer
    batch_size = [(params[:count] || 10).to_i, 1].max
    batch_size = 66 if batch_size > 66

    total_ml = 0
    juiced = 0
    batch_size.times do
      result = j.juice_one
      break if result.is_a?(Symbol)
      total_ml += result
      juiced += 1
    end

    save_juicer_to_session(j)

    if j.safety_shutdown?
      flash[:alert] = "Safety shutdown — juicing stopped."
    elsif juiced.zero?
      flash[:alert] = "Could not juice (power off, safety shutdown, feeder empty, or jug full)."
    else
      flash[:notice] = "Juiced #{juiced} fruits — +#{total_ml} ml total."
    end
    redirect_to simulator_path
  end

  def empty_jug
    current_juicer.empty_juice!
    save_juicer_to_session(current_juicer)
    flash[:notice] = "Jug emptied — ready to juice."
    redirect_to simulator_path
  end

  def reset
    reset_simulator_session
    flash[:notice] = "Machine reset."
    redirect_to simulator_path
  end

  def safety
    j = current_juicer
    if j.safety_shutdown?
      j.clear_safety_shutdown
      save_juicer_to_session(j)
      flash[:notice] = "Safety cleared — power on to continue."
    else
      j.trigger_motor_seizure!
      save_juicer_to_session(j)
      flash[:alert] = "Safety shutdown triggered."
    end
    redirect_to simulator_path
  end

  private

  def ensure_juicer
    current_juicer
  end
end
