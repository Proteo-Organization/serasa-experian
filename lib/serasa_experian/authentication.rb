# frozen_string_literal: true

require 'net/http'
require 'json'
require 'base64'

module SerasaExperian
  class Authentication
    AUTH_ENDPOINT = '/security/iam/v1/client-identities/login'

    def initialize(client_id:, client_secret:, base_url:)
      @client_id = client_id
      @client_secret = client_secret
      @base_url = base_url
    end

    def fetch_token
      uri = URI("#{@base_url}#{AUTH_ENDPOINT}")
      response = Net::HTTP.post(uri, nil, headers)

      parsed_response = JSON.parse(response.body)
      unless response.is_a?(Net::HTTPSuccess)
        raise "Authentication failed: #{parsed_response[0]['message'] || 'Unknown error'}"
      end

      parsed_response['accessToken']
    end

    private

    def headers
      {
        'Authorization' => "Basic #{encoded_credentials}",
        'Content-Type' => 'application/json'
      }
    end

    def encoded_credentials
      credentials = "#{@client_id}:#{@client_secret}"
      Base64.strict_encode64(credentials)
    end
  end
end
