{

  description = "My very first centralized infrastructure configuration!";

  inputs = {
    nixpkgs.url = github:NixOS/nixpkgs;
  };

  outputs = { self, nixpkgs }: {
  
    nixosConfigurations."ashes" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./ashes/ashes.nix ];
    };
    
    nixosConfigurations."timber" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./timber/timber.nix ];
    };
    
  };
}
