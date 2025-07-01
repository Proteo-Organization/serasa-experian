# frozen_string_literal: true

require_relative 'serasa_experian/version'
require_relative 'serasa_experian/configuration'
require_relative 'serasa_experian/client'
require_relative 'serasa_experian/authentication'
require_relative 'serasa_experian/reports/base'
require_relative 'serasa_experian/reports/person/report'
require_relative 'serasa_experian/reports/companies/report'

module SerasaExperian
  class << self
    attr_accessor :configuration

    def configure
      self.configuration ||= Configuration.new
      yield(configuration)
    end
  end
end
