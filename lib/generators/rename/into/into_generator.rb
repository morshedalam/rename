require File.expand_path('../shared/common_methods', File.dirname(__FILE__))

module Rename
  module Generators
    class IntoGenerator < Rails::Generators::Base
      include CommonMethods

      def into
        perform
      end
    end
  end
end
