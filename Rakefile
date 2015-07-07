task default: "server:monitor"

namespace :server do
  desc "Restart the web server"
  task :restart do
    puts `vagrant ssh -c "sudo restart flippd"`
  end

  desc "Automatically restart the web server when a source file changes"
  task :monitor do
    puts `rerun -x rake server:restart`
  end
end
