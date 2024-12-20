# frozen_string_literal: true

module SerasaExperian
  module Generators
    class InstallGenerator < Rails::Generators::Base
      source_root File.expand_path('templates', __dir__)

      def copy_initializer
        template 'initializer.rb', 'config/initializers/serasa_experian.rb'
      end
    end
  end
end
