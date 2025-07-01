# frozen_string_literal: true

require 'spec_helper'
require_relative '../../../lib/serasa_experian/reports/companies/report'
require_relative '../../../lib/serasa_experian/client'

RSpec.describe SerasaExperian::Reports::Companies::Report do
  let(:client) { instance_double(SerasaExperian::Client, base_url: 'https://mock-api.serasaexperian.com.br', access_token: 'mock_access_token') }
  let(:report_service) { described_class.new(client) }

  describe '#fetch' do
    context 'when the request is successful' do
      before do
        stub_request(:get, 'https://mock-api.serasaexperian.com.br/credit-services/business-information-report/v1/reports')
          .with(
            query: hash_including(
              reportName: 'BASIC_REPORT',
              optionalFeatures: 'FEATURE_A,FEATURE_B',
              reportParameters: Base64.strict_encode64({ reportParameters: [{ name: 'LIMITE_CREDITO',
                                                                              value: 'HLC2' }] }.to_json),
              federalUnit: 'SP'
            ),
            headers: {
              'Authorization' => 'Bearer mock_access_token',
              'X-Document-Id' => '12345678000190',
              'Content-Type' => 'application/json'
            }
          )
          .to_return(status: 200, body: { status: 200, report: 'mock_report_data' }.to_json)
      end

      it 'returns the report data' do
        response = report_service.fetch(
          document: '12.345.678/0001-90',
          report_name: 'BASIC_REPORT',
          optional_features: %w[FEATURE_A FEATURE_B],
          report_parameters: [{ name: 'LIMITE_CREDITO', value: 'HLC2' }],
          federal_unit: 'SP'
        )
        response = response[:body]
        expect(response['report']).to eq('mock_report_data')
      end
    end

    context 'when the server returns an error' do
      before do
        stub_request(:get, 'https://mock-api.serasaexperian.com.br/credit-services/business-information-report/v1/reports')
          .with(
            query: hash_including(
              reportName: 'BASIC_REPORT'
            ),
            headers: {
              'Authorization' => 'Bearer mock_access_token',
              'X-Document-Id' => '12345678000190',
              'Content-Type' => 'application/json'
            }
          )
          .to_return(status: 400, body: { status: 400, error: 'Invalid request' }.to_json)
      end

      it 'raises an HTTP error' do
        response = report_service.fetch(
          document: '12.345.678/0001-90',
          report_name: 'BASIC_REPORT'
        )
        expect(response[:error]).to eq('Invalid request')
      end
    end
  end

  describe '#format_optional_features' do
    context 'When parameters are empty' do
      it 'returns nil when features are nil' do
        result = report_service.send(:format_optional_features, nil)
        expect(result).to be_nil
      end

      it 'returns nil when features are empty' do
        result = report_service.send(:format_optional_features, [])
        expect(result).to be_nil
      end
    end
    context 'When there are parameters' do
      it 'When there is only one element' do
        result = report_service.send(:format_optional_features, %w[FEATURE_A])
        expect(result).to eq('FEATURE_A')
      end
    end
    it 'When there are multiple elements' do
      result = report_service.send(:format_optional_features, %w[FEATURE_A FEATURE_B])
      expect(result).to eq('FEATURE_A,FEATURE_B')
    end
  end

  describe '#format_report_parameters' do
    context 'When parameters are empty' do
      it 'returns nil when parameters are nil' do
        result = report_service.send(:format_report_parameters, nil)
        expect(result).to be_nil
      end

      it 'returns nil when parameters are empty' do
        result = report_service.send(:format_report_parameters, [])
        expect(result).to be_nil
      end
    end
    context 'When there are parameters' do
      it 'encodes parameters in Base64 JSON format' do
        parameters = [{ name: 'LIMITE_CREDITO', value: 'HLC2' }]
        result = report_service.send(:format_report_parameters, parameters)
        expected = Base64.strict_encode64({ reportParameters: parameters }.to_json)
        expect(result).to eq(expected)
      end
    end
  end

  describe '#sanitize_document' do
    context 'formats the document correctly' do
      it 'removes non-numeric characters from document' do
        result = report_service.send(:sanitize_document, '12.345.678/0001-90')
        expect(result).to eq('12345678000190')
      end

      it 'returns an empty string for nil input' do
        result = report_service.send(:sanitize_document, nil)
        expect(result).to eq('')
      end
    end
  end
end
