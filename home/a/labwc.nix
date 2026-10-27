{ lib, pkgs, ... }:

let
  # Generated with toINI so the color keys stay exact.
  fuzzelIni = lib.generators.toINI { } {
    main = {
      font = "Inter:size=10";
      icons-enabled = false;
      terminal = "foot";
      width = 36;
      lines = 8;
      horizontal-pad = 16;
      vertical-pad = 12;
      inner-pad = 8;
    };
    colors = {
      background = "0b0b0bff";
      text = "c8c8c8ff";
      match = "ffffffff";
      selection = "1a1a1aff";
      selection-text = "ffffffff";
      selection-match = "ffffffff";
      border = "262626ff";
    };
    border = {
      width = 1;
      radius = 0;
    };
  };
in
{
  xdg.configFile."labwc/rc.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <labwc_config>
      <core>
        <gap>0</gap>
        <adaptiveSync>no</adaptiveSync>
        <allowTearing>no</allowTearing>
      </core>

      <theme>
        <name>mono</name>
        <cornerRadius>0</cornerRadius>
        <dropShadows>no</dropShadows>
        <titlebar>
          <layout>icon:iconify,max,close</layout>
          <showTitle>yes</showTitle>
        </titlebar>
        <font place="ActiveWindow"><name>Inter</name><size>10</size></font>
        <font place="InactiveWindow"><name>Inter</name><size>10</size></font>
        <font place="MenuHeader"><name>Inter</name><size>10</size></font>
        <font place="MenuItem"><name>Inter</name><size>10</size></font>
        <font place="OnScreenDisplay"><name>Inter</name><size>10</size></font>
      </theme>

      <desktops>
        <popupTime>0</popupTime>
        <names>
          <name>1</name>
          <name>2</name>
          <name>3</name>
          <name>4</name>
        </names>
      </desktops>

      <resize>
        <!-- The visible border is thin, so extend the invisible grab zone
             just outside the window and make the corner targets generous. -->
        <minimumArea>12</minimumArea>
        <cornerRange>18</cornerRange>
      </resize>

      <keyboard>
        <default />
        <keybind key="W-Return"><action name="Execute" command="foot" /></keybind>
        <keybind key="W-d"><action name="Execute" command="fuzzel" /></keybind>
        <keybind key="W-e"><action name="Execute" command="thunar" /></keybind>
        <keybind key="W-q"><action name="Close" /></keybind>
        <keybind key="W-f"><action name="ToggleFullscreen" /></keybind>
        <keybind key="W-m"><action name="ToggleMaximize" /></keybind>
        <keybind key="W-Left"><action name="SnapToEdge" direction="left" combine="yes" /></keybind>
        <keybind key="W-Right"><action name="SnapToEdge" direction="right" combine="yes" /></keybind>
        <keybind key="W-C-Left"><action name="ResizeRelative" left="-10" /></keybind>
        <keybind key="W-C-Right"><action name="ResizeRelative" right="10" /></keybind>
        <keybind key="W-C-Up"><action name="ResizeRelative" top="-10" /></keybind>
        <keybind key="W-C-Down"><action name="ResizeRelative" bottom="10" /></keybind>
        <keybind key="W-1"><action name="GoToDesktop" to="1" /></keybind>
        <keybind key="W-2"><action name="GoToDesktop" to="2" /></keybind>
        <keybind key="W-3"><action name="GoToDesktop" to="3" /></keybind>
        <keybind key="W-4"><action name="GoToDesktop" to="4" /></keybind>
        <keybind key="W-S-1"><action name="SendToDesktop" to="1" follow="yes" /></keybind>
        <keybind key="W-S-2"><action name="SendToDesktop" to="2" follow="yes" /></keybind>
        <keybind key="W-S-3"><action name="SendToDesktop" to="3" follow="yes" /></keybind>
        <keybind key="W-S-4"><action name="SendToDesktop" to="4" follow="yes" /></keybind>
        <keybind key="W-S-r"><action name="Reconfigure" /></keybind>
        <keybind key="W-S-l"><action name="Execute" command="lock-screen" /></keybind>
        <keybind key="Print"><action name="Execute" command="screenshot" /></keybind>
        <keybind key="XF86AudioRaiseVolume"><action name="Execute" command="wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+" /></keybind>
        <keybind key="XF86AudioLowerVolume"><action name="Execute" command="wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-" /></keybind>
        <keybind key="XF86AudioMute"><action name="Execute" command="wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle" /></keybind>
        <keybind key="XF86AudioPlay"><action name="Execute" command="playerctl play-pause" /></keybind>
        <keybind key="XF86AudioNext"><action name="Execute" command="playerctl next" /></keybind>
        <keybind key="XF86AudioPrev"><action name="Execute" command="playerctl previous" /></keybind>
      </keyboard>

      <mouse>
        <!-- Plain left-drag on the border resizes (see the Border context
             below); Super+Left-drag moves and Super+Right-drag resizes from
             anywhere in the window. -->
        <default />
        <context name="Border">
          <mousebind button="Left" action="Press">
            <action name="Focus" />
            <action name="Raise" />
          </mousebind>
          <mousebind button="Left" action="Drag">
            <action name="Resize" />
          </mousebind>
        </context>
        <context name="Root">
          <mousebind button="Right" action="Press">
            <action name="ShowMenu" menu="root-menu" />
          </mousebind>
        </context>
      </mouse>
    </labwc_config>
  '';

  xdg.configFile."labwc/menu.xml".text = ''
    <?xml version="1.0" encoding="UTF-8"?>
    <openbox_menu>
      <menu id="root-menu">
        <item label="Terminal"><action name="Execute" command="foot" /></item>
        <item label="Launcher"><action name="Execute" command="fuzzel" /></item>
        <separator />
        <item label="Firefox"><action name="Execute" command="firefox" /></item>
        <item label="Files"><action name="Execute" command="thunar" /></item>
        <item label="Archive Manager"><action name="Execute" command="file-roller" /></item>
        <item label="Telegram"><action name="Execute" command="telegram-desktop" /></item>
        <item label="Vesktop"><action name="Execute" command="vesktop" /></item>
        <item label="Steam"><action name="Execute" command="steam" /></item>
        <separator />
        <item label="Reconfigure"><action name="Reconfigure" /></item>
        <item label="Exit"><action name="Exit" /></item>
      </menu>
    </openbox_menu>
  '';

  xdg.configFile."labwc/environment".text = ''
    XDG_CURRENT_DESKTOP=labwc
    XDG_SESSION_DESKTOP=labwc
    XDG_SESSION_TYPE=wayland
    XKB_DEFAULT_LAYOUT=pl
  '';

  xdg.configFile."labwc/autostart" = {
    executable = true;
    text = ''
      ${pkgs.kanshi}/bin/kanshi &
      waybar &
      swaybg -c '#0b0b0b' &
      mako &
    '';
  };

  # The panel is 2560x1440 at up to 240 Hz, but its EDID marks 1440p60 as the
  # preferred mode, so wlroots starts at 60 Hz. kanshi pins 240 Hz and re-applies
  # it after a VT switch, which resets the mode.
  xdg.configFile."kanshi/config".text = ''
    profile default {
      output "DP-1" mode 2560x1440@240Hz position 0,0
    }
  '';

  # labwc reads Openbox 3 themes from $XDG_DATA_HOME/themes.
  xdg.dataFile."themes/mono/openbox-3/themerc".text = ''
    border.width: 1

    window.titlebar.padding.width: 6
    window.titlebar.padding.height: 6

    window.active.border.color: #2a2a2a
    window.inactive.border.color: #1a1a1a

    window.active.title.bg: Solid
    window.active.title.bg.color: #141414
    window.inactive.title.bg: Solid
    window.inactive.title.bg.color: #0b0b0b

    window.active.label.text.color: #e6e6e6
    window.inactive.label.text.color: #6a6a6a
    window.label.text.justify: center

    window.button.width: 24
    window.button.height: 24
    window.button.hover.bg.color: #ffffff18
    window.active.button.unpressed.image.color: #c8c8c8
    window.inactive.button.unpressed.image.color: #5a5a5a

    window.active.shadow.size: 0
    window.inactive.shadow.size: 0

    menu.border.width: 1
    menu.border.color: #2a2a2a
    menu.items.bg.color: #0f0f0f
    menu.items.text.color: #c8c8c8
    menu.items.active.bg.color: #1f1f1f
    menu.items.active.text.color: #ffffff
    menu.separator.color: #2a2a2a
    menu.title.bg.color: #1a1a1a
    menu.title.text.color: #e6e6e6

    osd.bg.color: #0f0f0f
    osd.label.text.color: #e6e6e6
    osd.border.color: #2a2a2a
    osd.border.width: 1
  '';

  xdg.configFile."waybar/config.jsonc".text = ''
    {
      "layer": "top",
      "position": "top",
      "height": 30,
      "spacing": 4,
      "modules-left": [ "custom/launcher", "ext/workspaces", "wlr/taskbar" ],
      "modules-right": [ "tray", "pulseaudio", "network", "cpu", "memory", "clock" ],

      "custom/launcher": {
        "format": "≡",
        "tooltip": false,
        "on-click": "fuzzel"
      },

      "ext/workspaces": {
        "format": "{name}",
        "sort-by-id": true,
        "on-click": "activate"
      },

      "wlr/taskbar": {
        "format": "{icon} {title:.30}",
        "icon-size": 22,
        "icon-theme": "WhiteSur-dark",
        "tooltip-format": "{title}",
        "on-click": "activate",
        "on-click-middle": "close",
        "all-outputs": true
      },

      "tray": {
        "icon-size": 16,
        "spacing": 8
      },

      "pulseaudio": {
        "format": "vol {volume}%",
        "format-muted": "muted",
        "on-click": "pavucontrol"
      },

      "network": {
        "format-wifi": "wifi {essid}",
        "format-ethernet": "eth",
        "format-disconnected": "off",
        "tooltip-format": "{ifname}"
      },

      "cpu": {
        "format": "cpu {usage}%",
        "interval": 2
      },

      "memory": {
        "format": "mem {percentage}%",
        "interval": 5
      },

      "clock": {
        "format": "{:%H:%M}",
        "tooltip-format": "{:%Y-%m-%d}"
      }
    }
  '';

  xdg.configFile."waybar/style.css".text = ''
    * {
      font-family: "Inter", sans-serif;
      font-size: 11px;
      min-height: 0;
    }

    window#waybar {
      background: #0b0b0b;
      color: #c8c8c8;
      border-bottom: 1px solid #262626;
    }

    #custom-launcher {
      padding: 0 12px;
      color: #e6e6e6;
      font-size: 15px;
    }

    #workspaces button {
      padding: 0 8px;
      color: #6a6a6a;
      background: transparent;
      border: none;
      border-bottom: 1px solid transparent;
      border-radius: 0;
    }

    #workspaces button.active {
      color: #ffffff;
      border-bottom-color: #ffffff;
    }

    #workspaces button:hover {
      color: #ffffff;
      background: #1a1a1a;
    }

    #taskbar button {
      padding: 0 6px;
      background: transparent;
      border-bottom: 1px solid transparent;
      border-radius: 0;
    }

    #taskbar button.active {
      border-bottom-color: #e6e6e6;
    }

    #taskbar button:hover {
      background: #1a1a1a;
    }

    #tray,
    #pulseaudio,
    #network,
    #cpu,
    #memory,
    #clock {
      padding: 0 8px;
      color: #c8c8c8;
    }

    #clock {
      color: #e6e6e6;
    }

    #pulseaudio.muted,
    #network.disconnected {
      color: #6a6a6a;
    }

    #cpu.warning,
    #memory.warning {
      color: #a0a0a0;
    }

    #cpu.critical,
    #memory.critical {
      color: #ffffff;
    }
  '';

  xdg.configFile."fuzzel/fuzzel.ini".text = fuzzelIni;

  xdg.configFile."foot/foot.ini".text = ''
    [main]
    font=JetBrains Mono:size=12
    pad=8x8

    [colors-dark]
    alpha=1.0
    background=0b0b0b
    foreground=c8c8c8
    regular0=1a1a1a
    regular1=8a8a8a
    regular2=a0a0a0
    regular3=b8b8b8
    regular4=6a6a6a
    regular5=909090
    regular6=aaaaaa
    regular7=d0d0d0
    bright0=333333
    bright1=ffffff
    bright2=ffffff
    bright3=ffffff
    bright4=8a8a8a
    bright5=c0c0c0
    bright6=e0e0e0
    bright7=ffffff
  '';

  xdg.configFile."mako/config".text = ''
    font=Inter 10
    background-color=#0b0b0b
    text-color=#c8c8c8
    border-color=#262626
    border-size=1
    border-radius=0
    padding=12
    margin=8
    default-timeout=5000
  '';
}
