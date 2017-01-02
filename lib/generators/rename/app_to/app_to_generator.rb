require File.expand_path('../shared/common_methods', File.dirname(__FILE__))

module Rename
  module Generators
    class AppToGenerator < Rails::Generators::Base
      include CommonMethods

      def app_to
        warn '[DEPRECATION] `app_to` is deprecated.  Please use `into` instead.'

        validate_name_and_path?
        apply_app_module
        change_app_directory
      end
    end
  end
end