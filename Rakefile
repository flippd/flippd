task default: "test"

desc "Restart the web server"
task :restart do
  exec 'sudo restart flippd'
end

desc "Print the last 100 lines of the web server's log file"
task :log do
  exec 'sudo tail -n 100 /var/log/upstart/flippd-web-1.log'
end

desc "Run the tests"
task :test do
  exec 'MODE=test bundle exec rspec'
end

desc "Start an interactive session with the database"
task :db do
  exec 'mysql --user=root --password=root --database=flippd'
end

namespace :db do
  namespace :schema do
    desc "Empties the database and recreates the schema from the latest version of app/models"
    task :load do
      require_relative "app/db/init"
      DataMapper.auto_migrate!
    end
  end
end
