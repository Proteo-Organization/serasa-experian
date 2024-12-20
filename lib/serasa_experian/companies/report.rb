# frozen_string_literal: true

require 'base64'
module SerasaExperian
  module Companies
    class Report < Base
      REPORT_ENDPOINT = '/credit-services/business-information-report/v1/reports'

      def fetch(document:, report_name:, optional_features: nil, report_parameters: nil)
        params = {
          reportName: report_name,
          optionalFeatures: format_optional_features(optional_features),
          reportParameters: format_report_parameters(report_parameters)
        }.compact
        headers = build_headers(document)
        get(REPORT_ENDPOINT, params, headers)
      end

      private

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
    end
  end
end
