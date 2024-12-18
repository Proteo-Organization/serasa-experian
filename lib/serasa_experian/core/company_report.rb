# frozen_string_literal: true

require 'faraday'
require 'openssl'
require 'json'
require 'fileutils'
require 'base64'
require 'byebug'

module SerasaExperian
  module Core
    class CompanyReport
      def initialize
        @base_url = SerasaExperian.configuration.base_url
        @username = SerasaExperian.configuration.clientID
        @password = SerasaExperian.configuration.clientSecret
        @login_path = '/security/iam/v1/client-identities/login'
        @access_token = nil
      end

      def authenticate
        url = File.join(@base_url, @login_path)

        conn = Faraday.new(url: url) do |faraday|
          faraday.request :url_encoded
          faraday.headers['Content-Type'] = 'application/json'
          faraday.headers['Authorization'] = basic_auth_header
          faraday.adapter Faraday.default_adapter
        end

        response = conn.post

        json_response = JSON.parse(response.body)
        @access_token = json_response['accessToken']
      rescue Faraday::Error => e
        raise "Error during authentication: #{e.message}"
      end

      def current_token
        @access_token
      end

      private

      def basic_auth_header
        encoded_credentials = Base64.strict_encode64("#{@username}:#{@password}")
        "Basic #{encoded_credentials}"
      end
    end
  end
end
