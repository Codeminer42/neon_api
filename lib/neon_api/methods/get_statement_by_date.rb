module NeonApi
  # GetStatementByDate returns statements considering a start and end date interval.
  # See https://apiparceiros.neonpagamentos.com.br/doc/#item-3-7-2
  #
  # start_date and end_date arguments can be strings representing a ISO8601 date
  # or DateTime objects.
  #
  # Example retrieving statements from August/2019:
  #   NeonApi::GetStatementByDate.get('2019-08-01', '2019-09-01')
  #   NeonApi::GetStatementByDate.get(DateTime.new(2019,8,1), DateTime.new(2019,9,1))
  module GetStatementByDate
    URL = 'V1/Statement/GetStatementByDate'

    def self.get(start_date, end_date, load_receipt = true, load_geo_location = true)
      NeonApi.client.send_request(payload(start_date, end_date, load_receipt, load_geo_location), URL)
    end

    def self.payload(start_date, end_date, load_receipt, load_geo_location)
      {
        'ClientID':        NeonApi.client.client_id,
        'StartDate':       datetime_format(start_date),
        'EndDate':         datetime_format(end_date),
        'LoadReceipt':     load_receipt,
        'LoadGeoLocation': load_geo_location
      }.to_json
    end

    def self.datetime_format(datetime)
      datetime = DateTime.parse(datetime) unless datetime.is_a?(DateTime)
      datetime.iso8601
    end
  end
end
