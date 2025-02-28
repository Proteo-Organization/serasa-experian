# frozen_string_literal: true

require 'spec_helper'
require_relative '../../lib/serasa_experian/authentication'

RSpec.describe SerasaExperian::Authentication do
  let(:client_id) { 'test_client_id' }
  let(:client_secret) { 'test_client_secret' }
  let(:base_url) { 'https://mock-api.serasaexperian.com.br' }
  let(:auth) { described_class.new(client_id: client_id, client_secret: client_secret, base_url: base_url) }

  describe '#fetch_token' do
    context 'when authentication is successful' do
      before do
        stub_request(:post, "#{base_url}/security/iam/v1/client-identities/login")
          .with(headers: { 'Authorization' => "Basic #{Base64.strict_encode64("#{client_id}:#{client_secret}")}" })
          .to_return(status: 200, body: { accessToken: 'mock_token' }.to_json)
      end

      it 'returns a valid token' do
        token = auth.fetch_token
        expect(token).to eq('mock_token')
      end
    end

    context 'when authentication fails' do
      before do
        stub_request(:post, "#{base_url}/security/iam/v1/client-identities/login")
          .to_return(status: 401, body: [{ 'code' => '9', 'message' => 'Wrong Client Id or Client Secret.' }].to_json)
      end

      it 'raises an error' do
        expect { auth.fetch_token }.to raise_error('Authentication failed: Wrong Client Id or Client Secret.')
      end
    end
  end

  describe '#encoded_credentials' do
    context 'encode credentials correctly' do
      it 'returns a Base64 encoded token' do
        token = auth.send(:encoded_credentials)
        expected = Base64.strict_encode64("#{client_id}:#{client_secret}")
        expect(token).to eq(expected)
      end
    end
  end
end
