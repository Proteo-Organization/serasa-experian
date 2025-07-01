# frozen_string_literal: true

require 'base64'
module SerasaExperian
  module Reports
    module Person
      class Report < Reports::Base
        REPORT_ENDPOINT = '/credit-services/person-information-report/v1/creditreport'
      end
    end
  end
end
