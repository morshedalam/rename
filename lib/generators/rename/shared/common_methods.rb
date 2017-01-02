require 'active_support/concern'

module CommonMethods
  extend ActiveSupport::Concern

  included do
    desc 'Rename your Rails application'

    argument :new_name, :type => :string, :default => ''
  end

  protected

  def app_name
    @app_name = new_name.gsub(/\W/, '_').squeeze('_').camelize
  end

  def app_key
    @app_key = new_name.gsub(/\W/, '_')
  end

  def app_dir
    @app_dir = new_name.gsub(/[&%*@()!{}\[\]'\\\/"]+/, '')
  end

  def app_path
    @app_path = Rails.root.to_s.split('/')[0...-1].push(app_dir).join('/')
  end

  def validate_name_and_path?
    if new_name.blank?
      raise Thor::Error, "[Error] Application name can't be blank."
    elsif new_name =~ /^\d/
      raise Thor::Error, '[Error] Please give a name which does not start with numbers.'
    elsif app_name.size < 1
      raise Thor::Error, '[Error] Please enter at least one alphabet.'
    elsif reserved_names.include?(app_name.downcase)
      raise Thor::Error, '[Error] Please give a name which does not match any of the reserved Rails keywords.'
    elsif Object.const_defined?(app_name)
      raise Thor::Error, "[Error] Constant #{app_name} is already in use, please choose another name."
    elsif File.exists?(app_path)
      raise Thor::Error, '[Error] Already in use, please choose another name.'
    end
  end

  def reserved_names
    @reserved_names = %w[application destroy benchmarker profiler plugin runner test]
  end

  # rename_app_to_new_app_module
  def apply_app_module
    mod = "#{Rails.application.class.parent}"

    in_root do
      puts 'Search and replace module in...'

      #Search and replace module in to file
      Dir['*', 'config/**/**/*.rb', '.{rvmrc}'].each do |file|
        # file = File.join(Dir.pwd, file)
        puts "->#{file} ->>#{mod} ->>>#{app_name}"
        replace_into_file(file, /(#{mod}*)/m, app_name)
      end

      #Rename session key
      session_key_file = 'config/initializers/session_store.rb'
      search_exp       = /(('|")_.*_session('|"))/i
      session_key      = "'_#{app_key}_session'"
      replace_into_file(session_key_file, search_exp, session_key)
    end
  end

  # rename_app_to_new_app_directory
  def change_app_directory
    rename_references
    rename_directory
  end

  def rename_references
    puts 'Renaming references...'
    old_basename = File.basename(Dir.getwd)

    in_root do
      Dir.glob('.idea/*', File::FNM_DOTMATCH).each do |file|
        replace_into_file(file, old_basename, app_dir)
      end

      gem_set_file = '.ruby-gemset'
      replace_into_file(gem_set_file, old_basename, app_dir) if File.exist?(gem_set_file)
    end
  end

  def rename_directory
    print 'Renaming directory...'

    begin
      # FileUtils.mv Dir.pwd, app_path
      File.rename(Rails.root.to_s, app_path)
      puts 'Done!'
      puts "New application path is '#{app_path}'"
    rescue Exception => ex
      puts "Error:#{ex.inspect}"
    end
  end

  def replace_into_file(file, search_exp, replace)
    return if File.directory?(file)

    begin
      gsub_file file, search_exp, replace
    rescue Exception => ex
      puts "Error: #{ex.message}"
    end
  end
end
