# frozen_string_literal: true

require_relative 'authentication'

module SerasaExperian
  class Client
    attr_reader :base_url, :client_id, :client_secret, :access_token

    def initialize(client_id: nil, client_secret: nil, environment: nil)
      config = SerasaExperian.configuration

      @client_id = resolve_client_id(client_id, config)
      @client_secret = resolve_client_secret(client_secret, config)
      @base_url = resolve_base_url(environment, config)

      validate_credentials!
    end

    def authenticate
      auth = Authentication.new(client_id: @client_id, client_secret: @client_secret, base_url: @base_url)
      @access_token = auth.fetch_token
    end

    private

    def resolve_client_id(client_id, config)
      client_id || config.client_id || rails_credentials(:client_id)
    end

    def resolve_client_secret(client_secret, config)
      client_secret || config.client_secret || rails_credentials(:client_secret)
    end

    def resolve_base_url(environment, config)
      environment ? environment_base_url(environment) : config.base_url
    end

    def validate_credentials!
      raise 'Client ID and Client Secret are required' unless @client_id && @client_secret
    end

    def rails_credentials(key)
      Rails.application.credentials.dig(:serasa_experian, key) if defined?(Rails)
    end

    def environment_base_url(env)
      case env.to_s.to_sym
      when :production
        SerasaExperian::Configuration::PRODUCTION_BASE_URL
      when :development
        SerasaExperian::Configuration::DEVELOPMENT_BASE_URL
      else
        raise ArgumentError, "Invalid environment: #{env}. Use :production or :development."
      end
    end
  end
end
