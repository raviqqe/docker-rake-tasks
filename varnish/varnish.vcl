vcl 4.0;

backend web {
  .host = "www.raviqqe.com";
  .port = "8000";
}

backend git {
  .host = "git.raviqqe.com";
  .port = "8001";
}

sub vcl_recv {
  if (req.http.port == "80") {
    return (synth(301, "https://git.raviqqe.com"));
  } elsif (req.http.host ~ "www.raviqqe.com") {
    set req.backend_hint = web;
  } elsif (req.http.host ~ "git.raviqqe.com") {
    set req.backend_hint = git;
  }
}
