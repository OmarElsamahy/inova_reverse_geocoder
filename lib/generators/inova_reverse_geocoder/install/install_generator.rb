# frozen_string_literal: true

require "rails/generators"

module InovaReverseGeocoder
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path("templates", __dir__)

      def create_initializer_file
        copy_file "inova_reverse_geocoder_initializer.rb", "config/initializers/inova_reverse_geocoder.rb"
      end
    end
  end
end
