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
        parsed_body = parse_json(response.body)

        case response
        when Net::HTTPSuccess
          { status: response.code.to_i, body: parsed_body }
        when Net::HTTPClientError, Net::HTTPServerError
          { status: response.code.to_i, error: handle_http_error(response) }
        else
          { status: response.code.to_i, error: "Unexpected response: #{response.code} - #{response.message}" }
        end
      end

      def handle_http_error(response)
        parse_json(response.body)['error'] || response.body
      end

      def parse_json(body)
        JSON.parse(body)
      rescue JSON::ParserError
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
