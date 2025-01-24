# frozen_string_literal: true

# Configuração inicial da gem SerasaExperian / Initial configuration of the SerasaExperian gem
SerasaExperian.configure do |config|
  # Defina as credenciais fixas aqui, se desejar / Set fixed credentials here, if desired
  config.client_id = ENV['SERASA_CLIENT_ID']
  config.client_secret = ENV['SERASA_CLIENT_SECRET']

  # Ou deixe vazio para usar as credenciais do Rails.credentials / Or leave empty to use Rails.credentials
  # config.client_id = nil
  # config.client_secret = nil

  # Configuração do ambiente / Environment configuration
  config.environment = Rails.env.production? ? :production : :development
end
