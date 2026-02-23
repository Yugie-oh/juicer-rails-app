# frozen_string_literal: true

# Seed the Zumex Versatile Basic product from the juicer-demo spec
Product.find_or_create_by!(brand: "Zumex", model: "Versatile Basic", colour: "Orange") do |p|
  p.sku = "ZUMEX-VB-ORANGE"
  p.finish = "Glossy"
  p.price = 115_080
  p.currency = "ZAR"
  p.rrp = 123_408
  p.width_cm = 55.0
  p.depth_cm = 47.0
  p.height_cm = 85.0
  p.weight_kg = 54.0
  p.wattage = 380
  p.ip_rating = "IPX4"
  p.fruits_per_minute = 22
  p.feeder_capacity_kg = 10.0
  p.fruit_diameter_min_mm = 65
  p.fruit_diameter_max_mm = 81
  p.warranty_years = 2
  p.warranty_type = "commercial"
  p.lead_time_days = 12
  p.description = "Commercial citrus juicer for medium-to-high consumption. Automated workflow with high-capacity feeder and simple start/stop controls. Original System: cut, press, extract for higher yield and better flavour."
  p.features = [
    "Up to 22 fruits per minute",
    "10 kg feeder capacity",
    "65–81 mm fruit diameter",
    "ASP antibacterial silver polymer coating",
    "Double detection safety system",
    "Motor seizure detection",
    "Removable peel buckets and drip tray"
  ]
end
