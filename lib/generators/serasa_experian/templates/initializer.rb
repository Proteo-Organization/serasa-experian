# frozen_string_literal: true

SerasaExperian.configure do |config|
  config.client_id = ENV['SERASA_CLIENT_ID']
  config.client_secret = ENV['SERASA_CLIENT_SECRET']
  config.environment = Rails.env.production? ? :production : :development
end
