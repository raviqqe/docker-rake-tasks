task :cert do
  certbot = `which certbot`
  certbot = certbot != '' ? certbot : `which letsencrypt`
  sh "sudo #{certbot.strip} \
      certonly --standalone -d raviqqe.com -d git.raviqqe.com \
      -d www.raviqqe.com -d ftp.raviqqe.com --email raviqqe@gmail.com \
      --non-interactive --agree-tos --expand"
end

task :default do
  %w(git_daemon nginx_proxy notes nsd pure_ftpd).each do |dir|
    sh "cd #{dir} && rake rerun"
  end
end
