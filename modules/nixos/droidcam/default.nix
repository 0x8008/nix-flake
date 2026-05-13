{
  nixpkgs.overlays = [
    (final: prev: {
      droidcam = prev.droidcam.overrideAttrs (old: {
        patches = (old.patches or [ ]) ++ [
          ./fix-tjTransform-heap-corruption.patch
        ];
      });
    })
  ];

  programs.droidcam.enable = true;

  boot.extraModprobeConfig = ''
    options v4l2loopback exclusive_caps=1 card_label="DroidCam"
  '';
}
