task :cert do
  certbot = `sudo which certbot`
  certbot = certbot != '' ? certbot : `sudo which letsencrypt`
  sh "sudo #{certbot.strip} \
      certonly --standalone -d raviqqe.com -d git.raviqqe.com \
      -d www.raviqqe.com --email raviqqe@gmail.com \
      --non-interactive --agree-tos"
end

task :default do
  %w(git_daemon nginx_proxy notes nsd).each do |dir|
    sh "cd #{dir} && rake rerun"
  end
end
