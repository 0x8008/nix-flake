{ pkgs, ... }:

{
  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = true;
  };

  programs.ssh = {
    startAgent = true;
    askPassword = "${pkgs.kdePackages.ksshaskpass}/bin/ksshaskpass";
  };

  environment.systemPackages = [ pkgs.kdePackages.ksshaskpass ];
}
