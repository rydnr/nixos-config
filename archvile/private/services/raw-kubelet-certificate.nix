{ config, pkgs, ... }:

{
  services.raw-kubelet-certificate = {
    enable = true;
    certName = "raw-kubelet";
    caCrtFile = /etc/ssl/ca/certs/raw-kubernetes-ca.crt;
    caKeyFile = /etc/ssl/ca/private/raw-kubernetes-ca.key;
    caPassword = "yHGu5gSsAOPrF1ugz16qG6363ysNBQi7gytvDlRpRZ8h2l/UiuSTNxUbLSG0";
    certExpirationDays = 3650;
    certCountry = "ES";
    certState = "Madrid";
    certLocality = "Madrid";
    certOrganization = "ACM-SL";
    certOrganizationalUnit = "IT";
    certCommonName = "system:kubelet";
  };
}
