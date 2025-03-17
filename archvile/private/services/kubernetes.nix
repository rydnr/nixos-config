{ config, pkgs, ... }:

{
  services.kubernetes = {
    # enable = config.myCustomFlags.kubernetesEnabled;
    roles = [ "node" ];
    masterAddress = "reno";
    apiserverAddress = "https://reno:6443";
    easyCerts = true;
    apiserver = {
      securePort = 6443;
      advertiseAddress = "reno";
    };
    addons.dns.enable = true;
    kubelet.extraOpts = "--fail-swap-on=false --v=4";
  };

  systemd.services.kubernetes-worker-setup = {
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script = ''
      /run/wrappers/bin/su - chous -c 'ssh reno "sudo cat /var/lib/kubernetes/secrets/apitoken.secret"' | /run/current-system/sw/bin/nixos-kubernetes-node-join
      /run/wrappers/bin/su - chous -c 'scp reno:/var/lib/kubernetes/secrets/cluster-admin.pem ~/.kube/'
      /run/wrappers/bin/su - chous -c 'scp reno:/var/lib/kubernetes/secrets/cluster-admin-key.pem ~/.kube/'
    '';
  };
}
