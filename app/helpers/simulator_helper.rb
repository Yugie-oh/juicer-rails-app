# frozen_string_literal: true

module SimulatorHelper
  def current_juicer
    @current_juicer ||= juicer_from_session
  end

  def save_juicer_to_session(juicer)
    session[:simulator] = {
      powered_on: juicer.powered_on?,
      safety_shutdown: juicer.safety_shutdown?,
      juice_collected_ml: juicer.juice_collected_ml,
      fruits_juiced: juicer.fruits_juiced,
      peel_count: juicer.peel_bucket.peel_count,
      feeder_queue: juicer.feeder.fruit_queue.map { |f| { diameter_mm: f.diameter_mm, weight_grams: f.weight_grams, kind: f.kind.to_s } }
    }
  end

  def reset_simulator_session
    session.delete(:simulator)
  end

  private

  def juicer_from_session
    data = session[:simulator]
    Zumex::VersatileBasic.restore(data)
  end
end
