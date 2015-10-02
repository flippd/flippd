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
  exec 'bundle exec rspec'
end
