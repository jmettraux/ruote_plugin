
#
# opening the Base to make sure we have sequential migration numbers
# even when generating multiples migrations.
#
class Rails::Generator::Commands::Base

  def next_migration_string(padding = 3)

    if ActiveRecord::Base.timestamped_migrations

      s = Time.now.utc.strftime("%Y%m%d%H%M%S")
      loop do
        return s if Dir.glob("#{@migration_directory}/#{s}_*.rb").empty?
        s = (s.to_i + 1).to_s
      end
    else

      "%.#{padding}d" % next_migration_number
    end
  end
end


#
# ./script/generate ruote_plugin {basic|all}
#
class RuotePluginGenerator < Rails::Generator::NamedBase

  def manifest

    record do |m|
      # m.directory "lib"
      # m.template 'README', "README"

      m.migration_template(
        'create_workitems.rb',
        'db/migrate',
        :migration_file_name => 'create_workitems')

      m.migration_template(
        'create_history.rb',
        'db/migrate',
        :migration_file_name => 'create_history')

      if ARGV.first == 'all'

        m.migration_template(
          'create_expressions.rb',
          'db/migrate',
          :migration_file_name => 'create_expressions')

        m.migration_template(
          'create_process_errors.rb',
          'db/migrate',
          :migration_file_name => 'create_process_errors')
      end
    end
  end

  protected

    def banner
      """
Usage:

  #{$0} ruote_plugin {basic|all}"""
    end

    def add_options! (opt)
      #opt.separator ''
      #opt.separator 'Options:'
      #opt.on(
      #  '--engine-db-persistence',
      #  'generate migrations for persistence of engine in database'
      #) { |v|
      #  options[:engine_db_persistence] = v
      #}
    end

    def add_general_options! (opt)
      # removing the default options (for now)
    end
end

