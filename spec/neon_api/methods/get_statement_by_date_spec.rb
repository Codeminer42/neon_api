require 'spec_helper'

RSpec.describe NeonApi::GetStatementByDate do
  let(:start_date) { '2019-08-01' }
  let(:end_date)   { '2019-09-01' }
  let(:load_receipt)      { true }
  let(:load_geo_location) { true }
  let(:expected_payload) do
    {
      'ClientID':        nil,
      'StartDate':       '2019-08-01T00:00:00+00:00',
      'EndDate':         '2019-09-01T00:00:00+00:00',
      'LoadReceipt':     true,
      'LoadGeoLocation': true
    }.to_json
  end
  let(:expected_url) { 'V1/Statement/GetStatementByDate' }

  before do
    NeonApi.configure do |config|
      config.token    = 'neon-token'
      config.username = 'neon-username'
      config.password = 'neon-pass'
      config.encrypt_pem = '/etc/public.pem'
      config.decrypt_pem = '/etc/private.pem'
      config.environment = :test
    end

    allow_any_instance_of(NeonApi::Client).to receive(:authenticate).and_return(true)
    allow_any_instance_of(NeonApi::Client).to receive(:send_request)
  end

  describe '.get' do
    it 'sends the payload to the expected URL' do
      expect_any_instance_of(NeonApi::Client).to \
        receive(:send_request).with(expected_payload, expected_url)

      subject.get(start_date, end_date) # defaults load_receipt and load_geo_location to true
    end
  end

  describe '.payload' do
    it 'returns the correct payload in JSON format' do
      expect(subject.payload(start_date, end_date, load_receipt, load_geo_location)).to \
        eq(expected_payload)
    end
  end

  describe '.datetime_format' do
    let(:datetime_str)     { '2019-08-01T23:59:59' }
    let(:datetime_obj)     { DateTime.new(2019, 8, 1, 23, 59, 59) }
    let(:datetime_iso8601) { '2019-08-01T23:59:59+00:00' }

    it 'ensures ISO8601 format for a string date' do
      expect(subject.datetime_format(datetime_str)).to eq(datetime_iso8601)
    end

    it 'ensures ISO8601 format for a DateTime object' do
      expect(subject.datetime_format(datetime_obj)).to eq(datetime_iso8601)
    end
  end
end
