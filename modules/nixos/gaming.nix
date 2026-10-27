{ pkgs, ... }:

{
  programs.steam.enable = true;

  programs.gamemode = {
    enable = true;
    # Allow gamemoded to lower the nice value of game processes.
    enableRenice = true;

    settings = {
      general.renice = 10;

      # Pin the Vega 64 to its highest DPM level while a game is active. This
      # is hotter and louder than "auto", and GameMode resets it afterwards.
      # The GPU is card1 on this host (there is no card0).
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 1;
        amd_performance_level = "high";
      };
    };
  };

  programs.gamescope = {
    enable = true;
    capSysNice = true;
  };

  environment.systemPackages = with pkgs; [
    mangohud
    protonup-qt
  ];
}
