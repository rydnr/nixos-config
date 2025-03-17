{ config, pkgs, ... }:

{
  services.raw-kubelet = {
    enable = true;
    address = "0.0.0.0";
    authentication = {
      webhook = {
        enabled = true;
        cache-ttl = "10s";
      };
      x509 = {
        client-ca-file = /etc/ssl/ca/certs/raw-kubernetes-ca.crt;
      };
    };
    authorization = {
      mode = "Webhook";
    };
    cluster-dns = [ "10.0.0.254" ];
    cluster-domain = "cluster.local";
    container-runtime-endpoint = "unix:///run/containerd/containerd.sock";
    cgroup-driver = "systemd";
    fail-swap-on = false;
    hairpin-mode = "hairpin-veth";
    healthz-bind-address = "127.0.0.1";
    healthz-port = 10248;
    hostname-override = "archvile";
    kubeConfigOpts = {
      caCrtFile = "/etc/ssl/ca/certs/raw-kubernetes-ca.crt";
      server = "https://reno:6443";
      certCrtFile = "/etc/ssl/certs/raw-kubelet.crt";
      certKeyFile = "/etc/ssl/private/raw-kubelet.key";
    };
    port = 10250;
    register-node = true;
    register-with-taints = [ "node-role.kubernetes.io/master=true:NoSchedule" "unschedulable=true:NoSchedule" ];
    root-dir = "/var/lib/kubernetes";
    tls-cert-file = /etc/ssl/certs/raw-kubelet.crt;
    tls-private-key-file = /etc/ssl/private/raw-kubelet.key;
  };
}
