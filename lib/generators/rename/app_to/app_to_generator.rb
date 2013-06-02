module Rename
  module Generators
    class AppToGenerator < Rails::Generators::Base
      argument :new_name, :type => :string

      def app_to
        return if !valid_app_name?
        new_module_name()
        new_basename()
      end

      private

      def valid_app_name?
        if new_name.to_s.strip.blank?
          puts "Please enter new application name"
          return false
        elsif new_name.match(/^[A-Za-z]/).nil?
          puts "Invalid application name"
          return false
        elsif new_name.size < 3
          puts "New application name too short"
          return false
        elsif new_name.scan(/[0-9A-Za-z]/).size < 3
          puts "Name should have minimum 3 alphanumeric characters"
          return false
        end

        return true
      end

      def new_module_name()
        search_exp = /(#{Regexp.escape("#{Rails.application.class.parent}")})/m
        module_name = new_name.gsub(/[^0-9A-Za-z]/, ' ').split(' ').map { |w| w.capitalize }.join('')

        in_root do
          puts "Search and Replace Module in to..."

          #Search and replace module in to file
          Dir["*", "config/**/**/*.rb", ".{rvmrc}"].each do |file|
            search_and_replace_module_into_file(file, search_exp, module_name)
          end

          #Rename session key
          session_key_file = 'config/initializers/session_store.rb'
          search_exp = /((\'|\")_.*_session(\'|\"))/i
          session_key = "'_#{module_name.gsub(/[^0-9A-Za-z_]/, '_').downcase}_session'"
          search_and_replace_module_into_file(session_key_file, search_exp, session_key)
        end
      end

      def new_basename()
        basename = new_name.gsub(/[^0-9A-Za-z_]/, '-')

        change_basename(basename)
        change_directory_name(basename)

        puts "Done!"
      end

      def change_basename(basename)
        puts "Renaming basename..."

        in_root do
          Dir.glob(".idea/*", File::FNM_DOTMATCH).each do |file|
            search_and_replace_module_into_file(file, File.basename(Dir.getwd), basename)
          end

          search_and_replace_module_into_file(".ruby-gemset", File.basename(Dir.getwd), basename)
        end
      end

      def change_directory_name(basename)
        begin
          print "Renaming directory..."
          new_path = Rails.root.to_s.split('/')[0...-1].push(basename).join('/')
          File.rename(Rails.root.to_s, new_path)
        rescue Exception => ex
          puts "Error:#{ex.message}"
        end
      end

      def search_and_replace_module_into_file(file, search_exp, new_module_name)
        return if File.directory?(file)

        begin
          gsub_file file, search_exp, new_module_name
        rescue Exception => ex
          puts "Error: #{ex.message}"
        end
      end
    end
  end
end