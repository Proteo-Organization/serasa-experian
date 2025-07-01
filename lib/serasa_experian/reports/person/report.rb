# frozen_string_literal: true

require 'base64'
module SerasaExperian
  module Reports
    module Companies
      class Report < Reports::Base
        REPORT_ENDPOINT = '/credit-services/business-information-report/v1/reports'
      end
    end
  end
end
