task default: "server:monitor"

namespace :server do
  desc "Restart the web server"
  task :restart do
    exec 'sudo restart flippd'
  end

  desc "Automatically restart the web server when a source file changes"
  task :monitor do
    exec 'rerun rake server:restart'
  end

  desc "Dumps the last 100 lines of the server's log file"
  task :logs do
    exec 'sudo tail -n 100 /var/log/upstart/flippd-web-1.log'
  end
end

desc "Run the tests"
task :test do
  exec 'bundle exec rspec'
end
