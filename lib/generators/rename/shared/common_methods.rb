require 'active_support/concern'

module CommonMethods
  extend ActiveSupport::Concern

  included do
    desc 'Rename your Rails application'

    argument :new_name, :type => :string, :default => ''
  end

  protected

  def perform
    prepare_app_vars
    validate_name_and_path?
    apply_new_module_name
    remove_references
    rename_directory
  end

  def app_parent
    if Rails.version.to_f >= 3.3
      Rails.application.class.to_s.deconstantize
    else
      Rails.application.class.parent.name
    end
  end

  def prepare_app_vars
    @new_key         = new_name.gsub(/\W/, '_')
    @old_module_name = app_parent
    @old_dir         = File.basename(Dir.getwd)
    @new_module_name = @new_key.squeeze('_').camelize
    @new_dir         = new_name.gsub(/[&%*@()!{}\[\]'\\\/"]+/, '')
    @new_path        = Rails.root.to_s.split('/')[0...-1].push(@new_dir).join('/')
  end

  def validate_name_and_path?
    if new_name.blank?
      raise Thor::Error, "[Error] Application name can't be blank."
    elsif new_name =~ /^\d/
      raise Thor::Error, '[Error] Please give a name which does not start with numbers.'
    elsif @new_module_name.size < 1
      raise Thor::Error, '[Error] Please enter at least one alphabet.'
    elsif reserved_names.include?(@new_module_name.downcase)
      raise Thor::Error, '[Error] Please give a name which does not match any of the reserved Rails keywords.'
    elsif Object.const_defined?(@new_module_name)
      raise Thor::Error, "[Error] Constant '#{@new_module_name}' is already in use, please choose another name."
    elsif file_exist?(@new_path)
      raise Thor::Error, "[Error] Folder '#{@new_dir}' already in use, please choose another name."
    end
  end

  # rename_app_to_new_app_module
  def apply_new_module_name
    in_root do
      puts 'Search and replace exact module name...'
      Dir['*', 'config/**/**/*.rb', '.{rvmrc}'].each do |file|
        # file = File.join(Dir.pwd, file)
        replace_into_file(file, /(#{@old_module_name}*)/m, @new_module_name)
      end
      #Application layout
      %w(erb haml slim).each do |ext|
        replace_into_file("app/views/layouts/application.html.#{ext}", /#{@old_module_name}/, @new_module_name)
      end
      #Readme
      %w(md markdown mdown mkdn).each do |ext|
        replace_into_file("README.#{ext}", /#{@old_module_name}/, @new_module_name)
      end

      puts 'Search and replace underscore seperated module name in files...'
      #session key
      replace_into_file('config/initializers/session_store.rb', /(('|")_.*_session('|"))/i, "'_#{@new_key}_session'")
      #database
      replace_into_file('config/database.yml', /#{@old_module_name.underscore}/i, @new_name.underscore)
      #Channel and job queue
      %w(config/cable.yml config/environments/production.rb).each do |file|
        replace_into_file(file, /#{@old_module_name.underscore}_production/, "#{@new_module_name.underscore}_production")
      end
      # package.json name entry
      old_package_name_regex = /\Wname\W *: *\W(?<name>[-_\p{Alnum}]+)\W *, */i
      new_package_name       = %("name":"#{@new_module_name.underscore}",)
      replace_into_file('package.json', old_package_name_regex, new_package_name)
    end
  end

  private

  def reserved_names
    @reserved_names = %w[application destroy benchmarker profiler plugin runner test]
  end

  def file_exist?(name)
    File.respond_to?(:exist?) ? File.exist?(name) : File.exists?(name)
  end

  def remove_references
    print 'Removing references...'

    begin
      FileUtils.rm_r('.idea')
    rescue Exception => ex
    end
    puts 'Done!'
  end

  def rename_directory
    print 'Renaming directory...'

    begin
      # FileUtils.mv Dir.pwd, app_path
      gem_set_file = '.ruby-gemset'
      replace_into_file(gem_set_file, @old_dir, @new_dir) if file_exist?(gem_set_file)
      File.rename(Rails.root.to_s, @new_path)
      puts 'Done!'
      puts "New application path is '#{@new_path}'"
    rescue Exception => ex
      puts "Error:#{ex.inspect}"
    end
  end

  def replace_into_file(file, search_exp, replace)
    return if File.directory?(file) || !file_exist?(file)

    begin
      gsub_file file, search_exp, replace
    rescue Exception => ex
      puts "Error: #{ex.message}"
    end
  end
end
