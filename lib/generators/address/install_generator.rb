require 'rails/generators'
require 'rails/generators/active_record'

module Address
  class InstallGenerator < ::Rails::Generators::Base
    include ::Rails::Generators::Migration

    source_root File.expand_path('../templates', __FILE__)

    desc 'Generates (but does not run) migration to add polymorphic addresses table.'

    def create_migration_file
      add_migration('create_addresses_table')
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