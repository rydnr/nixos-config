{
  services.k3s = {
    enable = false;
    role = "server";
    extraFlags = toString [
      #     "--disable traefik"  # Disable default Traefik if you plan to use another ingress
      #     "--disable servicelb"  # Disable built-in service load balancer
    ];
  };

  networking.firewall.allowedTCPPorts =
    [ 6443 80 443 ]; # Adjust ports as needed
  networking.firewall.allowedUDPPorts =
    [ 8472 ]; # Required for flannel networking
}
