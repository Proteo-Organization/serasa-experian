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
        uri = URI("#{client.base_url}#{path}")
        uri.query = URI.encode_www_form(params)
        request = Net::HTTP::Get.new(uri, headers)
        response = Net::HTTP.start(uri.hostname, uri.port, use_ssl: true) { |http| http.request(request) }
        handle_response(response)
      end

      def handle_response(response)
        case response
        when Net::HTTPSuccess
          JSON.parse(response.body)
        when Net::HTTPClientError, Net::HTTPServerError
          handle_http_error(response)
        else
          raise "Unexpected response: #{response.code} - #{response.message}"
        end
      end

      def handle_http_error(response)
        error_body = parse_error_body(response.body)
        raise "HTTP Error #{response.code}: #{error_body}"
      end

      def parse_error_body(body)
        JSON.parse(body)['error']
      rescue StandardError
        body
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
