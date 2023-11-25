# frozen_string_literal: true

require_relative "inova_reverse_geocoder/version"

module InovaReverseGeocoder
  class Error < StandardError; end
    attr_accessor :lat, :long, :locale, :data, :distrcit, :city, :country, :address_components, :full_address, :results

    class InovaReverseGeocoder
      def initialize(lat: 0, long: 0, locale: "en", api_key: nil)
        @lat = lat
        @long = long
        @locale = locale
        @api_key = api_key
      end

      def execute()
        url = URI("https://maps.googleapis.com/maps/api/geocode/json")
        url.query = URI.encode_www_form({ latlng: [@lat.to_s, @long.to_s].join(","), key: @api_key, language: @locale, result_type: "administrative_area_level_3|administrative_area_level_2" })
        res = Net::HTTP::get_response(url)
        puts res.body
        json_data = res.body if res.is_a?(Net::HTTPSuccess)
        @data = JSON.parse(json_data)
        @results = @data["results"]
        # puts @results
        return if @results.nil?
        @result = @results.first if @results.any?
        @result ||= {}
        @address_components = @result["address_components"] if @result.present? && @result.any?
      end

      def full_address
        @result["formatted_address"] || ""
      end

      def district_key
        district.downcase.gsub(" ", "_")
      end

      def city_key
        city.downcase.gsub(" ", "_")
      end

      def country_key
        country.downcase.gsub(" ", "_")
      end

      def district
        unless @address_components.any?
          return ""
        end
        values = ["administrative_area_level_3", "administrative_area_level_2", "administrative_area_level_1", "country"]
        return name_for_values(values)
      end

      def city
        unless @address_components.any?
          return ""
        end
        values = ["administrative_area_level_1", "country"]
        return name_for_values(values)
      end

      def country
        unless @address_components.any?
          return ""
        end
        values = ["country"]
        return name_for_values(values)
      end

      def name_for_values(values)
        value = @address_components.select { |r| (r["types"] & values).any? }.first
        return (value.present? && value.any?) ? value["long_name"] : ""
      end
    end
end
