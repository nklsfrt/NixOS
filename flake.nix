{
  description = "My very first centralized infrastructure configuration!";
  inputs = {
    nixpkgs.url = "nixpkgs/nixos-22.05";
  };

  outputs = { self, nixpkgs }: {

    nixosConfigurations."ashes" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./ashes.nix ];
    };
  };
}
