{ pkgs, ... }:{

  system.stateVersion = "22.05";

	nix.settings = {
		experimental-features = [ "nix-command flakes" ];
		auto-optimise-store = true;
	};

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};

  # User configuration

	users.users.nase = {
		name = "nase";
		extraGroups = [ "wheel" ];
		isNormalUser = true;
		shell = pkgs.fish;
    hashedPassword = "$6$tmq77efFOO.hfxev$s/0Ob1FwKdXUGNHloQd3ozesGLxBeMNXm0LtSaoecEuKlMJUbNqYH5UvxN4oW2dPvqxhT0JtNHNwS5DPQEJFd1";
		openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvAJm/S7F8FJj5veaT1lqN+3+/etph6BriSxYPzzQAe nase@timber" ];
	};

  # Package configuration

	environment.systemPackages = with pkgs; [
		git
		tmux
		micro
		exa
		bat
		fish
	];
  
	services.openssh.enable = true;
  programs.fish.enable = true;
}