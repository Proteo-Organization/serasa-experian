# frozen_string_literal: true

require 'faraday'
require 'json'
require_relative 'serasa_experian/version'
require_relative 'serasa_experian/core/authentication'

module SerasaExperian
  class << self
    attr_accessor :configuration

    def setup
      self.configuration ||= Configuration.new
      yield(configuration) if block_given?
    end
  end

  class Configuration
    attr_accessor :environment, :client_id, :client_secret

    def initialize
      @environment = :development
      @client_id = '66ed6b4b0f7e962f81f68ab5'
      @client_secret = '05c5cc11MyzvnE-3f48-40c4-9735-e7f7c9252861'
    end

    def base_url
      production? ? Constants::PRODUCTION_BASE_URL : Constants::DEVELOPMENT_BASE_URL
    end

    private

    def production?
      environment == :production
    end
  end
end
