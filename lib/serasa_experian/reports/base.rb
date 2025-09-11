# frozen_string_literal: true

require 'net/http'
require 'json'

module SerasaExperian
  module Reports
    class Base
      attr_reader :client

      def initialize(client)
        @client = client
      end

      def fetch(document:, report_name:, optional_features: nil, report_parameters: nil, federal_unit: nil)
        params = {
          reportName: report_name,
          optionalFeatures: format_optional_features(optional_features),
          reportParameters: format_report_parameters(report_parameters),
          federalUnit: federal_unit
        }.compact
        headers = build_headers(document)
        get(self.class::REPORT_ENDPOINT, params, headers)
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
        if response.is_a?(Net::HTTPSuccess)
          { status: response.code.to_i, body: parsed_body }
        else
          { status: response.code.to_i, error: handle_http_error(response) }
        end
      end

      def handle_http_error(response)
        response.body
      end

      def parse_json(body)
        JSON.parse(body)
      rescue JSON::ParserError
        body
      end

      def format_optional_features(features)
        return nil if features.nil? || features.empty?

        features.join(',')
      end

      def format_report_parameters(parameters)
        return nil if parameters.nil? || parameters.empty?

        json = { reportParameters: parameters }.to_json
        Base64.strict_encode64(json)
      end

      def build_headers(document)
        {
          'Content-Type' => 'application/json',
          'Authorization' => "Bearer #{@client.access_token}",
          'X-Document-Id' => sanitize_document(document)
        }
      end

      def sanitize_document(document)
        document.to_s.gsub(/\D/, '')
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
