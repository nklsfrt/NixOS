{ config, pkgs, ... }:

{
	imports =
		[
			./hardware-ashes.nix
		];

	system.stateVersion = "22.05";

	nix.settings = {
		experimental-features = [ "nix-command" "flakes" ];
		auto-optimize-store = true;
	};

	nix.gc = {
		automatic = true;
		dates = "weekly";
		options = "--delete-older-than 30d";
	};

	# Boot configuration - Selecting kernel packages, providing kernel parameters etc.
	
	boot.kernelParams = [ "nohibernate" ];
	boot.loader.grub = {
		devices = [ "/dev/sda" ];
		configurationLimit = 16;
	};

	# Network configuration - Specify necessary routes for Hetzners IPv6 implementation

	networking = {
		hostName = "ashes";
		interfaces.ens3.ipv6.addresses = [{ address = "2a01:4f8:1c1c:4bd6::1"; prefixLength = 64;}];
		# Set the default gateway for ipv6
		defaultGateway6 = { address = "fe80::1"; interface = "ens3"; };
		nameservers = [
				"2a01:4ff:ff00::add:1"
				"2a01:4ff:ff00::add:2"
		];
		firewall = {
			enable = true;
			interfaces = {
				"ens3".allowedTCPPorts = [ 80 443 ];
			};
		};
	};
	

	# Service configuration - Specify needed services 
	services.openssh.enable = true;
	
	# User configuration

	users.users.nase = {
		name = "nase";
		extraGroups = [ "wheel" ];
		isNormalUser = true;
		shell = pkgs.fish;
		openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvAJm/S7F8FJj5veaT1lqN+3+/etph6BriSxYPzzQAe nase@timber" ];
	};
	
	users.users.root.openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGvAJm/S7F8FJj5veaT1lqN+3+/etph6BriSxYPzzQAe nase@timber" ];
	# users.users.root.password = "myconfigsfucked";


	# Package configuration - specify packages to be made available systemwide
	
	environment.systemPackages = with pkgs; [
		git
		tmux
		micro
		exa
		bat
		fish
	];

	programs.fish.enable = true;


	# Virtualization

	virtualisation.podman = {
		enable = true;
		dockerCompat = false;
	};
}
