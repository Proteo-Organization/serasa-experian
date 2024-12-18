require 'faraday'
require 'openssl'
require 'securerandom'

module SerasaExperian
  module Core
    class Connection
      def self.setup_connection(document)
        auth_client = Serasa::Core::Authentication.new
        auth_client.authenticate

        token = auth_client.current_token

        Faraday.new(url: url) do |faraday|
          faraday.headers['Content-Type'] = 'application/json'
          faraday.headers['Authorization'] = "Bearer #{token}"
          faraday.headers['X-Document-Id'] = document
          faraday.request :json
          faraday.adapter Faraday.default_adapter
        end
      end
    end
  end
end
