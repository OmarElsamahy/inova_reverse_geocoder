# frozen_string_literal: true

require_relative "inova_reverse_geocoder/version"
require 'net/http'
require 'json'

module InovaReverseGeocoder
  class Error < StandardError; end
    attr_accessor :lat, :long, :locale, :data, :distrcit, :city, :country, :address_components, :full_address, :results

    class Configuration
      attr_accessor :api_key

      def initialize
        @api_key = nil
      end
    end

    class << self
      attr_accessor :config
    end

    self.config = Configuration.new

    def self.configure
      yield(config)
    end

    class Geo
      def initialize(lat: 0, long: 0, locale: "en")
        @lat = lat
        @long = long
        @locale = locale
        @api_key = InovaReverseGeocoder.config.api_key
      end

      def execute()
        url = URI("https://maps.googleapis.com/maps/api/geocode/json")
        url.query = URI.encode_www_form({ latlng: [@lat.to_s, @long.to_s].join(","), key: @api_key, language: @locale, result_type: "administrative_area_level_3|administrative_area_level_2" })
        res = Net::HTTP::get_response(url)
        json_data = res.body
        puts res.body.encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
        @data = JSON.parse(json_data)
        @results = @data["results"]
        return if @results.nil?
        @result = @results.first if @results.any?
        @result ||= {}
        @address_components = @result["address_components"] if !@result.empty? && @result.any?
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

      private

      def handle_api_error(response)
        case response.code.to_i
        when 400
          raise "Bad Request: The request was invalid or malformed."
        when 401
          raise "Unauthorized: Your API key is invalid or missing."
        when 403
          raise "Forbidden: The request is understood, but it has been refused."
        when 404
          raise "Not Found: The requested resource could not be found."
        when 429
          raise "Too Many Requests: Your request exceeds the usage limits."
        when 500..599
          raise "Server Error: There was an error on the server side."
        else
          raise "Unknown Error: An unknown error occurred."
        end
      end
    end
end
