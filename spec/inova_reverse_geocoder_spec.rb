# frozen_string_literal: true

RSpec.describe InovaReverseGeocoder do
# spec/inova_reverse_geocoder_spec.rb
require 'inova_reverse_geocoder'
require 'net/http'

  describe '#initialize' do
    it 'sets default values' do
      geocoder = InovaReverseGeocoder::Geo.new
      expect(geocoder)
    end
  end

  describe '#execute' do
    it 'fetches and parses data' do
      geocoder = InovaReverseGeocoder::Geo.new(lat: 37.7749, long: 22.4194, locale: 'en',api_key: "")
      geocoder.execute
      puts geocoder
      puts geocoder.full_address
      expect(geocoder.results).to_not be_nil
    end
  end
end
