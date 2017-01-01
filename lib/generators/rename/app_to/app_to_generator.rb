require File.expand_path('../shared/common_methods', File.dirname(__FILE__))

module Rename
  module Generators
    class Error < Thor::Error
    end

    class AppToGenerator < Rails::Generators::Base
      include CommonMethods

      def app_to
        warn "[DEPRECATION] `app_to` is deprecated.  Please use `into` instead."

        valid?
        new_app_module
        new_app_directory
      end
    end
  end
end