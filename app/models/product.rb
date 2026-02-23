# frozen_string_literal: true

class Product < ApplicationRecord
  validates :brand, :model, presence: true
  validates :sku, uniqueness: { allow_blank: true }

  scope :juicers, -> { where("model IS NOT NULL") }

  def display_name
    [ brand, model, colour ].compact.join(" ")
  end

  def dimensions_s
    return nil unless width_cm? && depth_cm? && height_cm?
    "#{width_cm} × #{depth_cm} × #{height_cm} cm (W × D × H)"
  end
end
