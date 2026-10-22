{
  description = "NixOS configuration for the C612 desktop";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Use the release branch. It has the exact kernel builds in the binary
    # cache. Do not override its nixpkgs input: the CachyOS patches must
    # match the kernel version.
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nix-cachyos-kernel,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in
    {
      overlays.default = final: _prev: {
        posy-cursors-improved = final.callPackage ./pkgs/posy-cursors-improved.nix { };
      };

      nixosConfigurations.c612 = nixpkgs.lib.nixosSystem {
        inherit system;

        modules = [
          ./hosts/c612
          home-manager.nixosModules.home-manager
          {
            nixpkgs.overlays = [
              self.overlays.default
              nix-cachyos-kernel.overlays.pinned
            ];
            nixpkgs.config.allowUnfree = true;

            home-manager = {
              useGlobalPkgs = true;
              useUserPackages = true;
              users.a = import ./home/a;
            };
          }
        ];
      };

      formatter.${system} = pkgs.nixfmt;
    };
}
