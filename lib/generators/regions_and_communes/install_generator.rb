require 'rails/generators'
require 'rails/generators/active_record'

module RegionsAndCommunes
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates (but does not run) migrations to add regions and communes tables.'

    def create_migration_file
      add_migration('create_regions_table')
      add_migration('create_communes_table')
      add_migration('populate_regions_table')
      add_migration('populate_communes_table')
    end

    def self.next_migration_number(dirname)
      ::ActiveRecord::Generators::Base.next_migration_number(dirname)
    end

    protected

    def add_migration(template)
      migration_dir = File.expand_path('db/migrate')

      if self.class.migration_exists?(migration_dir, template)
        warn("ALERT: Migration already exists named '#{template}'." +
                 " Please check your migrations directory before re-running")
      else
        migration_template "#{template}.rb", "db/migrate/#{template}.rb"
      end
    end
  end
end