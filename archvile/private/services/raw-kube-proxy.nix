{ config, pkgs, ... }:

{
  services.raw-kube-proxy = {
    enable = true;
    kubeConfigOpts = {
      caCrtFile = "/etc/ssl/ca/certs/raw-kubernetes-ca.crt";
      server = "https://reno:6443";
      certCrtFile = "/etc/ssl/certs/raw-kube-proxy.crt";
      certKeyFile = "/etc/ssl/private/raw-kube-proxy.key";
    };
    bind-address = "0.0.0.0";
    cluster-cidr = "10.1.0.0/16";
    hostname-override = "archvile";
  };
}
