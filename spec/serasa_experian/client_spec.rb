# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/serasa_experian/client'
require_relative '../../lib/serasa_experian/authentication'

RSpec.describe SerasaExperian::Client do
  let(:client_id) { 'test_client_id' }
  let(:client_secret) { 'test_client_secret' }
  let(:environment) { :development }
  let(:client) { described_class.new(client_id: client_id, client_secret: client_secret, environment: environment) }

  describe '#authenticate' do
    context 'when credentials are correct' do
      before do
        allow_any_instance_of(SerasaExperian::Authentication)
          .to receive(:fetch_token).and_return('mock_access_token')
      end

      it 'authenticates and sets the access token' do
        client.authenticate
        expect(client.access_token).to eq('mock_access_token')
      end
    end

    context 'when credentials are incorrect' do
      before do
        allow_any_instance_of(SerasaExperian::Authentication)
          .to receive(:fetch_token).and_raise('Authentication failed')
      end

      it 'raises an authentication error' do
        expect { client.authenticate }.to raise_error('Authentication failed')
      end
    end
  end
end
