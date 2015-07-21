task default: "server:monitor"

namespace :server do
  desc "Restart the web server"
  task :restart do
    exec 'vagrant ssh -c "sudo restart flippd && sudo tail -f /var/log/upstart/flippd-web-1.log"'
  end

  desc "Automatically restart the web server when a source file changes"
  task :monitor do
    exec "rerun rake server:restart"
  end
end
