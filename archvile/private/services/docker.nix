{ config, pkgs, ... }:

{
  # Enable Docker 
  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    liveRestore = false;
    # extraOptions = "--insecure-registry=nexus.acm-sl.org";
    #extraOptions = "--insecure-registry=nexus.osoco.es --tlsverify --tlscacert=/etc/docker/ca.pem --tlscert=/etc/docker/server-cert.pem --tlskey=/etc/docker/server-key.pem -H tcp://0.0.0.0:2376 -H unix:///var/run/docker.sock";
    #extraOptions = "--insecure-registry=dockerhub.osoco.es --insecure-registry=docker.osoco.es";
  };
}
