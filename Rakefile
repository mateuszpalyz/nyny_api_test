require 'bundler/gem_tasks'
require 'rake/testtask'
require 'yaml'
require 'logger'

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['test/test_*.rb']
end

task :default => :test

MIGRATIONS_DIR = 'db/migrate'

namespace :db do
  task :env do
    ENV['RACK_ENV'] ||= 'development'
    DATABASE_ENV = ENV['RACK_ENV']
    require 'database'
  end

  task :migrate => :env do
    ActiveRecord::Migration.verbose = true
    ActiveRecord::Migrator.migrate MIGRATIONS_DIR, ENV['VERSION'] ? ENV['VERSION'].to_i : nil
  end

  task :rollback => :env do
    init_connection
    step = ENV['STEP'] ? ENV['STEP'].to_i : 1
    ActiveRecord::Migrator.rollback MIGRATIONS_DIR, step
  end
end
