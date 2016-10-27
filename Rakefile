task :cert do
  certbot = `sudo which certbot`
  certbot = certbot != '' ? certbot : `sudo which letsencrypt`
  sh "sudo #{certbot.strip} \
      certonly --standalone -d raviqqe.com -d git.raviqqe.com \
      -d www.raviqqe.com --email raviqqe@gmail.com \
      --non-interactive --agree-tos"
end
