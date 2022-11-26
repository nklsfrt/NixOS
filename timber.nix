{ config, pkgs, lib, ... }:

{
  imports =
    [
      ./hardware-timber.nix
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
    kernelPackages = config.boot.zfs.package.latestCompatibleLinuxPackages;
    kernelParams = [ "nohibernate" "nvidia-drm.modeset=1" ];
    supportedFilesystems = [ "zfs" ];
    zfs.extraPools = [ "vault" ];
  }

  fileSystems."/home".neededForBoot = true;

  # Set your time zone.
  time.timeZone = "Europe/Vienna";

  nix = {
   package = pkgs.nixFlakes;
   extraOptions = lib.optionalString (config.nix.package == pkgs.nixFlakes)
     "experimental-features = nix-command flakes";
  };

  # Select internationalisation properties.
  i18n = {
    defaultLocale = "en_US.UTF-8";
    supportedLocales = [
      "en_US.UTF-8"
      "de_DE.UTF-8"
    ];
    extraLocaleSettings = {
      LC_TIME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8"
    };
  }
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
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.fish;
    hashedPassword = "$6$p6HY8TeVeozfWc4g$L0YDMa4zaU83L5rNxfesj.sGCn8bo3yB93VJxQ8/gslgScGq7BTeHsOngb3gRBCsbs4F5oRP/ywIyQZeoPUGF/";
  };

  programs.fish.enable = true;
  
  users.users.root.hashedPassword = "$6$GKt/5QJ1wA0.E/Zw$g5oPpo42B1KOm547s2wvEwpw8Us7bP4FvfPkZPKx3jKaAP57Sis/MzxgBXmvZ2WyTCInIEsF2cQG1SE3jiYMg0";
  
  # Enable unfree packages
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    (pkgs.systemd.overrideAttrs (oldAttrs: {
      withHomed = true;
    }))
     git
     wget
     fish
     foot
     micro
     htop
     vscode
     exa
     bat
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

