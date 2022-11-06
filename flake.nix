{
  description = "My very first centralized infrastructure configuration!";
  outputs = { self, nixpkgs }: {

    nixosConfigurations."ashes" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./ashes.nix ];
    };
  };
}
