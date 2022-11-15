{ config, pkgs, ... }:

{
	imports =
		[
			./hardware-ashes.nix
			/abilities/common.nix
			# /role/web-presence.nix
		];


	# Boot configuration - Selecting kernel packages, providing kernel parameters etc.
	
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
}
