# frozen_string_literal: true

module Zumex
  # Value object for physical dimensions (cm)
  Dimensions = Struct.new(:width_cm, :depth_cm, :height_cm) do
    def to_s
      "#{width_cm} × #{depth_cm} × #{height_cm} cm (W × D × H)"
    end
  end
end
