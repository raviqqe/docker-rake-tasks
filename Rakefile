task :cert do
  certbot = `which certbot`
  certbot = certbot != '' ? certbot : `which letsencrypt`
  sh "sudo #{certbot.strip} \
      certonly --standalone -d raviqqe.com -d git.raviqqe.com \
      -d www.raviqqe.com -d ftp.raviqqe.com --email raviqqe@gmail.com \
      --non-interactive --agree-tos --expand"
end

image_dirs = %w(git_daemon nginx_proxy notes nsd pure_ftpd)

%i(rerun push).each do |name|
  task name do
    image_dirs.each do |dir|
      sh "cd #{dir} && rake #{name}"
    end
  end
end
