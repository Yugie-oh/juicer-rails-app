ENV["BUNDLE_GEMFILE"] ||= File.expand_path("../Gemfile", __dir__)

# Suppress libvips/GLib warnings about missing optional DLLs (heif, jxl, magick, etc.) on Windows.
# Seed and the app work fine without those plugins.
ENV["G_MESSAGES_DEBUG"] ||= "fatal"

require "bundler/setup" # Set up gems listed in the Gemfile.
require "bootsnap/setup" # Speed up boot time by caching expensive operations.
