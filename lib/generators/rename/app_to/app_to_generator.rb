require File.expand_path('../shared/common_methods', File.dirname(__FILE__))

module Rename
  module Generators
    class AppToGenerator < Rails::Generators::Base
      include CommonMethods

      def app_to
        warn '[DEPRECATION] `app_to` is deprecated.  Please use `into` instead.'
        perform
      end
    end
  end
end