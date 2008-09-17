
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

      if options[:engine_db]

        # TODO : continue here
      end
    end
  end

  protected

    def banner
      'write me !'
    end

    def add_options! (opt)
      opt.separator ''
      opt.separator 'Options:'
      opt.on(
        '--engine-db-persistence',
        'generate migrations for persistence of engine in database'
      ) { |v|
        options[:engine_db_persistence] = v
      }
    end

    def add_general_options! (opt)
      # removing the default options (for now)
    end
end

