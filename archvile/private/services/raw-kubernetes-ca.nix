{ config, pkgs, ... }:

{
  services.raw-kubernetes-ca = {
    enable = true;
    caName = "raw-kubernetes-ca";
    caPassword = "yHGu5gSsAOPrF1ugz16qG6363ysNBQi7gytvDlRpRZ8h2l/UiuSTNxUbLSG0";
    caExpirationDays = 3650;
    caCountry = "ES";
    caState = "Madrid";
    caLocality = "Madrid";
    caOrganization = "ACM-SL";
    caOrganizationalUnit = "IT";
    caCommonName = "acm-sl.org";
  };
}
