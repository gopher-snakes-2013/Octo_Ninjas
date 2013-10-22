
require 'sinatra/activerecord/rake'

begin
  require "rspec/core/rake_task"
  desc "Run all examples"
  RSpec::Core::RakeTask.new(:spec) do |t|
    t.rspec_opts = %w[--color]
    t.pattern = 'spec/*_spec.rb'
  end

  task :default => :spec
  rescue LoadError
end

desc 'Start IRB with app loaded'
task 'console' do
  exec 'irb -r ./app.rb'
end

desc 'create the database'
task "db:create" do
  %x(createdb ninjadb)
end

desc "drop the database"
task "db:drop" do
  %x(dropdb ninjadb)
end

task :environment do
  require './app'
  require 'sinatra/activerecord'
end

Rake::Task["db:migrate"].enhance [:environment]
Rake::Task["db:rollback"].enhance [:environment]
