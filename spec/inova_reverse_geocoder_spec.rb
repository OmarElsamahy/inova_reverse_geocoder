# frozen_string_literal: true

RSpec.describe InovaReverseGeocoder do
# spec/inova_reverse_geocoder_spec.rb
require 'inova_reverse_geocoder'
  describe '#initialize' do
    it 'sets default values' do
      geocoder = InovaReverseGeocoder.new
      expect(geocoder.lat).to eq(0)
      expect(geocoder.long).to eq(0)
      expect(geocoder.locale).to eq('en')
    end

    it 'sets provided values' do
      geocoder = InovaReverseGeocoder.new(lat: 12.34, long: 56.78, locale: 'en')
      expect(geocoder.lat).to eq(12.34)
      expect(geocoder.long).to eq(56.78)
      expect(geocoder.locale).to eq('en')
    end
  end

  describe '#execute' do
    it 'fetches and parses data' do
      # Mock the HTTP response for testing
      allow(Net::HTTP).to receive(:get_response).and_return(double(body: '{"results": [{"formatted_address": "Test Address"}]}'))

      geocoder = InovaReverseGeocoder.new(lat: 37.7749, long: -122.4194, locale: 'en',api_key: "AIzaSyBvXscZI6LkvHPCk2L4f358Ky3kbaM2rGk")
      geocoder.execute
      puts geocoder.full_address
      expect(geocoder.results).to_not be_nil
      expect(geocoder.full_address).to eq('Test Address')
    end
  end
end
