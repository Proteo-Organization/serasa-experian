# frozen_string_literal: true

require_relative 'authentication'

module SerasaExperian
  class Client
    attr_accessor :access_token
    attr_reader :base_url, :client_id, :client_secret

    def initialize(client_id: nil, client_secret: nil, environment: nil)
      config = SerasaExperian.configuration

      @client_id = client_id || config.client_id
      @client_secret = client_secret || config.client_secret
      @base_url = environment ? environment_base_url(environment) : config.base_url
    end

    def authenticate
      auth = Authentication.new(client_id: @client_id, client_secret: @client_secret, base_url: @base_url)
      @access_token = auth.fetch_token
    end

    private

    def environment_base_url(env)
      env == :production ? Configuration::PRODUCTION_BASE_URL : Configuration::DEVELOPMENT_BASE_URL
    end
  end
end
