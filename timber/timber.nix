{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../common.nix
      ./hardware.nix
    ];

  boot = {
    # Use the systemd-boot EFI boot loader.
    loader = {
      systemd-boot = {
        enable = true;
        # Don't keep more than 3 previous configurations as boot entries.
        configurationLimit = 3;
      };
      efi = {
        efiSysMountPoint = "/boot";
        canTouchEfiVariables = false;
      };
    };
    initrd.kernelModules = [ "nvidia" "nvidia_modeset" "nvidia_uvm" "nvidia_drm" ];
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = [ "nvidia-drm.modeset=1" ];
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "vault" ];
  };

  fileSystems."/home".neededForBoot = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8/UTF-8"
      "de_DE.UTF-8/UTF-8"
    ];
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
    };
  };
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkbOptions in tty.
  # };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.videoDrivers =  [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
  	enable = true;
  	alsa.enable = true;
  	pulse.enable = true;
  };

  users.users.nase = {
    home = "/home/niklas";
  };
  
  users.users.root.hashedPassword = "$6$GKt/5QJ1wA0.E/Zw$g5oPpo42B1KOm547s2wvEwpw8Us7bP4FvfPkZPKx3jKaAP57Sis/MzxgBXmvZ2WyTCInIEsF2cQG1SE3jiYMg0";
  
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
     foot
     htop
     vscode
     librewolf-wayland
     pavucontrol
     helvum
     iosevka-bin
     tdesktop
     signal-desktop
   ];

  networking.hostName = "timber";
  networking.hostId = "68a8af9f";

}

