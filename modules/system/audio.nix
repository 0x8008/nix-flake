{ config, pkgs, ... }:

{
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    extraConfig.pipewire."99-droidcam-audio" = {
      "context.objects" = [
        {
          factory = "adapter";
          args = {
            "factory.name"     = "api.alsa.pcm.source";
            "node.name"        = "droidcam-audio";
            "node.description" = "DroidCam Microphone";
            "media.class"      = "Audio/Source";
            "api.alsa.path"    = "plughw:Loopback,1";
            "audio.rate"       = 16000;
            "audio.channels"   = 1;
            "audio.format"     = "S16LE";
            "audio.position"   = [ "MONO" ];
            "priority.session" = 1500;
            "api.alsa.period-size" = 1024;
          };
        }
      ];
    };
  };
}
