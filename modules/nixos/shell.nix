{ pkgs, ... }:

{
  programs.zsh.enable = true;

  environment.systemPackages = with pkgs; [
    git
    wget
    unrar
    rar
    claude-code
    antigravity-fhs
  ];
}
