# frozen_string_literal: true

module SerasaExperian
  class Configuration
    PRODUCTION_BASE_URL = 'https://api.serasaexperian.com.br'
    DEVELOPMENT_BASE_URL = 'https://uat-api.serasaexperian.com.br'

    attr_accessor :client_id, :client_secret, :environment

    def base_url
      environment == :production ? PRODUCTION_BASE_URL : DEVELOPMENT_BASE_URL
    end
  end
end
