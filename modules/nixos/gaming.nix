{ pkgs, ... }:

{
  programs.steam.enable = true;

  programs.gamemode = {
    enable = true;
    # Let gamemode change the CPU governor for the game process.
    enableRenice = true;
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
