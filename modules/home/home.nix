{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "a";
  home.homeDirectory = "/home/a";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  home.stateVersion = "26.05"; # Please read the comment before changing.

  # The home.packages option allows you to install Nix packages into your
  # environment.
  home.packages = [
    # pkgs.hello
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # ".screenrc".source = dotfiles/screenrc;
  };

  home.sessionVariables = {
    # EDITOR = "nano";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.zsh = {
    enable = true;
    
    shellAliases = {
      rebuild-nix = "cd ~/Documents/nix-flake && sudo nixos-rebuild switch --flake \".#$(hostname)\"";
    };

    initContent = ''
      # 1. Enable Colors, VCS, and Variable Substitution
      autoload -U colors && colors
      autoload -Uz vcs_info
      setopt PROMPT_SUBST  # <--- This was the missing key!

      # 2. Configure Git/VCS display
      zstyle ':vcs_info:*' enable git 
      # Format: [branch-name]
      zstyle ':vcs_info:git:*' formats ' %F{magenta}[%b]%f'
      zstyle ':vcs_info:git:*' actionformats ' %F{magenta}[%b|%a]%f'

      # 3. The Precmd Hook
      precmd() {
          vcs_info
      }

      # 4. PROMPT (Left Side)
      # [user@machine] /full/directory: 
      PROMPT='%F{cyan}[%n@%m]%f %F{blue}%d%f: '

      # 5. RPROMPT (Right Side)
      # [error] [git] [clock]
      RPROMPT='%(?..%F{red}[%?]%f)''${vcs_info_msg_0_} %F{243}[%T]%f'
      bindkey  "^[[H"   beginning-of-line
      bindkey  "^[[F"   end-of-line
      bindkey  "^[[3~"  delete-char
    '';
  };
}
