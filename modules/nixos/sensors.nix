{ config, pkgs, ... }:

{
  boot.extraModulePackages = with config.boot.kernelPackages; [ it87 ];
  boot.kernelModules = [ "coretemp" "it87" ];
  # Required so the it87 driver can claim its hardware monitoring resources.
  boot.kernelParams = [ "acpi_enforce_resources=lax" ];
  boot.extraModprobeConfig = ''
    options it87 force_id=0x8623
  '';

  environment.systemPackages = [ pkgs.lm_sensors ];
}
