module Rename
  module Generators
    class AppToGenerator < Rails::Generators::Base
      argument :new_name, :type => :string, :default => "#{Rails.application.class.parent}"

      def app_to
        old_root_directory = "#{Rails.root}"
        old_name = Regexp.escape("#{Rails.application.class.parent}")
        rename_to = new_name.downcase.gsub(/\s/, "_").camelize.capitalize
        new_root_directory = old_root_directory.gsub(/\/#{old_name.downcase}/, "/#{new_name.downcase}")

        changes = list_of_changes(rename_to, old_name)

        #Inside the application
        in_root do
          for change in changes
            if change[0] == 'environments'
              for env_name in ['development', 'production', 'test']
                change[0] = "config/environments/#{env_name}.rb"
                replace_on_file(change)
              end
            else
              replace_on_file(change)
            end
          end
        end
        puts "Renaming directory"
        File.rename "#{old_root_directory}", "#{new_root_directory}"
      end

      private
      def list_of_changes(rename_to, old_name)
        return [
            ['Rakefile', /(#{old_name})(::Application.load_tasks)/mi, "#{rename_to}::Application.load_tasks"],
            ['config.ru', /(run) (#{old_name})(::Application)/mi, "run #{rename_to}::Application"],
            ['config/routes.rb', /(#{old_name})(::Application.routes)/mi, "#{rename_to}::Application.routes"],
            ['config/application.rb', /(module) (#{old_name})/mi, "module #{rename_to}"],
            ['config/environment.rb', /(#{old_name})(::Application.initialize!)/mi, "#{rename_to}::Application.initialize!"],
            ['config/initializers/secret_token.rb', /(#{old_name})(::Application.config.secret_token)/mi, "#{rename_to}::Application.config.secret_token"],
            ['config/initializers/session_store.rb', /(#{old_name})(::Application.config.session_store)/mi, "#{rename_to}::Application.config.session_store"],
            ['environments', /(#{old_name})(::Application.configure)/mi, "#{rename_to}::Application.configure"]
        ]
      end

      def replace_on_file(change)
        gsub_file change[0], change[1] do |match|
          change[2]
        end
      end
    end

  end
end