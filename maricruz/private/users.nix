{ config, pkgs, ... }:

{
  #  home-manager.useUserProfiles = true;
  #  home-manager.useGlobalPkgs = true;
  #  home-manager.users.chous = { pkgs, ... }: {
  #    home.packages = [ pkgs.atool pkgs.httpie ];
  #    programs.bash.enable = true;
  #    home.stateVersion = "22.11";
  #  };

  #  users.defaultUserShell = "/run/current-system/sw/bin/zsh";

  users.extraUsers.chous = {
    isNormalUser = true;
    uid = 1000;
    description = "Jose San Leandro";
    #shell = "/run/current-system/sw/bin/fish";
    shell = "/run/current-system/sw/bin/bash";
    #shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [
      "wheel"
      "dialout"
      "video"
      "networkmanager"
      "docker"
      "audio"
      "users"
      "cron"
      "lp"
      "disk"
      "libvirtd"
      "vboxusers"
      "cdrom"
      "davfs2"
      "adbusers"
    ]; # "nixbld" ];
    openssh.authorizedKeys.keys = [
      "ssh-dss AAAAB3NzaC1kc3MAAAEBAIqmNNJj5gRn8bnj0MS6dN6SNiCN9QxyrTq1OBX1y2vOpxnl1yPvpwDUpXgO21srnnYmPg9WzBuHL7J/PIgChAQDKUhwduH071X3hfhlFeYyjWIFbPYMNC/WIeSVo+nmiQkThe+7kxyuhycPsUURpTC4Sp1l3RdAW+dy1AUK+wOmy12XnH4e5jksVIl00vxG/8BhTMS9vPIihTSRIvEpl1TA1MEKO2Eawy9WOuipGdrz/UXlR7eJd0/wuwUax1RGDPnrtqCrFp7jd+T/+FZrtY2/vRTBiv/VVsB1rNref1kD+dpyfnFicUO9CtnjPbd4m1SU6TzpTOPFRgFY4xqbg1kAAAAVAP9bvk+GKpsUPaSxSnz/KPu7pQ13AAABAGieCveem19/hJoy2dodXYz518qTOyHrJYcNA93YP0yGvbef0axK+MTjYnAZYd7kBtFc2wDOqdXTsh75ixhjC9o573pqFe5sqTbQ4dFwZcXHMKiSX4c15GTQGQXC1Jo8feKWgDAofjwjSxOGntedFhXFjP/j+aIj+DD3ad4Dm0EKaLmB/DZyK4IZUYFv8gl1Cim72uyXquDYJLEHo42ZEerqCMt3C+ofZOf2Vycx8SippDZ33Hj/oGxLivC5OeQ27Kz189EciloRGqQuxlNVSDN0GyjaEv9WPhC+dFmZVfrIwe83oxS5Dcv/SNs+3DC//oBQyTGRnSUy6YFy3yfBhiUAAAD/BB1b5Vum8SxQF7H3WXGsV/d/unOOU7DbbymKfMIDANT0L4/EjEEWgiFLA5v5s/i/48USiHrQ2QO+7fghVvgmB+FDa62tnOMhdU7pTeOjXaBGwMZsTD24Yo89hrRhocmsYLu/qa5EeKrLzBDuZQvLr4AmufuXWBhEqUvL5+UMZnwux3nkRPpeXYTtTUw/+PFY6oqaY9fn6xdjxU94H7GZAzUADjsfPO9vUsMulK1xNIgRcMYPe1S1GfvnJm20or2vmSfFCgf3oiRDYSzUQy+ZYIjqB8AGL4/Qt5U660wM7kcT/o1a/HQZReQAGYknOj4KGktl9Cu624jlpq67uWzJ chous@bollox"
      "ssh-dss AAAAB3NzaC1kc3MAAACBALn+D1dwm0eJ5JwdorlxSGgDAH47PrtvrULa++XUOxjo612yEzWa94vj14yOB/Wiemq0Sn/rPebPG6a8yO3QkuoS0Ke179Le0HoLU3z4H6/vqI4xQrzyhr/BHiun/QZ67H9m6TX5sfW4b92atenR70asXvb0e+XpCDQMdEb/M5hhAAAAFQCVWf1+ywBa46efrH2qQUkQ8QUAFwAAAIEAr3S5GMZrw779zJ+PprwcgZP3Xwp23+TpjyFTd40DypkDL+jU5H332UdyGfdJGS8nK8O0b0cb7iDDo35QzCn1ek5+vpGvk2u+a3vcGXUCYoC/ao0amsYViC6r5g+JBwJWiN58p6zI6BWcZ7c8oVXBlUsrJKnGfHH5PH+Fr8N90IcAAACAMujZdfveja4AlULOzQITJJ1g+D0hHWdz1h/2CSZjCN/LXJH13E9gtz8ideCWm5xoguTTh5SEm8yQAIP1YdXiT3uwDkk9uxc8Sj71MjBmT4eryfYPpGpicivayD8tBlzBrySJoKgIFhnP9x5ksDSRYaxXNr55Hfjx4RCblswQTxg= chous@jlean"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDXpGtNLOxE28Kcvzi035hpErX6lNEPYgi1Ov/jBpa+HuiTznOnUtrKuGnFdXOUho66fCOmChv8JV8qoy9w9e7DnLW8Hrhd/4dzbnXtWEObjy9+hSvpQfSVwzPHhXEpPHkH4npnGkg84Dbndw4dBaSaJB4xPHJ7L+Uc8D6xr1L927yOxj5e/0+WPQPiyGCipjBFrtwJd+1GKjpycwOWHUtWadleD/0ZCxnx9ggeIv2fu8+kgGBOXabUXLHUE1aVX3SQfxpumuADs+s9htqYEqA7eLQ81l+l4iGeLSIfFnhn07Cr3TSY3BmuzVRnUxAVFyT3Aux2Kpcp1Q2lFHLrM4ZKuUiLeo5OAu/UIAN0cBvbhgBpV469pCtOpglOvCi2q5bxhmp0nTUhP6zibaln9iyTm3N/p/Xj2Nj+OGk8pKT3H9zXIofWmW6jd1SGV3v/30PvRrBjLTRoV6PHs9SZTbwAGZHJQhqS64JZzOREdmFf8hySfuH6KT8bvTxSFRz4VXOgfrtbHXsyqx1GI2viG7XlK/KJMmhEaVonxdg1pBT8ew7rg4q99fZUId4vl7Gu7Rcc/Dy2cT4ZMNySmxVfokMY3uIN0pnfWZXwRaMeDAw2JyP92S2rTEgGfgoS14FcqDUbAWJkIUOFDIQSYudKBrSnPqyb6XFmq35kn7KSttxkRw== chous@feynman"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC+e3Kfwy2yh9sQvYiONZuw6yxnud18Fkq5TUiI2mp5Sr1juKasSTee807i8A6/gno37ll3YIB23GLj4+R6I68QSM0tUfK5zWIX7wzPcgxZYjXsOrB3lTSJMQs0GsMqcn3i36jiD6EsCsXFu5nbWOuqLjzhjqGyWRAzD/rsC34VOI6b50tZ0kBkuxxyLYrEzX7HZ6YbI0TM7UZnNxzGoqpbEJJu52ID92UdJXXqJ1fM5YchFV2qHSNFoh0QvXbH9U+tvCENiNrRzb/ejFs9sj7iav7V4+fKrjc1zKR59ZtjsX/SIO40+2Vsg/evI8SzH5IEtn7TNylRRxUaiMBG/65L jose.sanleandro@witworks.es"
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDjRHss8gaJYy3IGpZ6LEeMtwK1Ki6jOnE8THPoHnN9yq/+ScHm5hZFrmAf9thqnIya7qXMNs1LlsF+s92El068DKQGsGZ0bJhNk44aZBe8eunBtZQAOpgcYMYiy1DGfi0UgevuTGrSdXsn5UtcwTZhg8GWPrTFqYl1kAOaUiN+mwUdzId9TL5yAsiWXfv2i7rJ6GOS3W4C2lx11EgLyA9aNmch1xYrh2h2FU71wp4H7Sw2XVrWvENsFy7cOs78S8G8q7r3TRtIQ+qRSzGezEuPk68Uz5evjVkqcLW1f0NiDfMM4KNRJXfIofRWwDeaT9LptT8bZ3AXQ7uUp71946B/ github@acm-sl.org"
    ];
  };

  users.extraUsers.pharo = {
    isNormalUser = true;
    uid = 1001;
    description = "Pharo testing";
    #shell = "/run/current-system/sw/bin/fish";
    #shell = "/run/current-system/sw/bin/bash";
    shell = "/run/current-system/sw/bin/zsh";
    extraGroups = [
      "wheel"
      "video"
      "networkmanager"
      "docker"
      "audio"
      "users"
      "cron"
      "lp"
      "disk"
      "libvirtd"
      "vboxusers"
      "cdrom"
    ]; # "nixbld" ];
  };

  users.groups = { davfs2 = { }; };
  users.users.davfs2 = {
    isSystemUser = true;
    group = "davfs2";
  };

  nix.settings.trusted-users = [ "root" "chous" ];
}
