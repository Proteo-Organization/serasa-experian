# frozen_string_literal: true

# Configuração inicial da gem SerasaExperian
SerasaExperian.configure do |config|
  config.client_id = ENV['SERASA_CLIENT_ID'] # Substitua pelas credenciais padrão, se necessário
  config.client_secret = ENV['SERASA_CLIENT_SECRET']
  config.environment = Rails.env.production? ? :production : :development
end
