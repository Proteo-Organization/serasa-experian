# frozen_string_literal: true

require 'net/http'
require 'json'

module SerasaExperian
  module Companies
    class Base
      attr_reader :client

      def initialize(client)
        @client = client
      end

      private

      def get(path, params = {}, headers)
        uri = URI("#{@client.base_url}#{path}")
        uri.query = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(uri, headers)
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
        JSON.parse(response.body)
      end

      def headers
        {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{client.access_token}"
        }
      end
    end
  end
end
