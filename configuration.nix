# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:
let

  baseconfig = { allowUnfree = true; };
  unstable = import <unstable> { config = baseconfig; };

in {
  imports = [ <home-manager/nixos> ];

  nixpkgs.config = baseconfig // {
    allowUnfree = true;
    allowBroken = true;

    packageOverrides = super:
      let self = super.pkgs;
      in {
        myHaskellEnv = pkgs.haskellPackages.ghcWithHoogle (haskellPackages:
          with haskellPackages; [
            arrows
            async
            criterion
            lens
            generic-deriving
            singletons
            logict
            either
            either-unwrap
            ghc-core
            mueval
            prelude-extras
            protolude
            idris
            cabal-install
            haskintex
            stack
            cabal2nix
          ]);
      };
  };

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "Hydrogen"; # Define your hostname.
  networking.firewall.enable = true;
  networking.wireless.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_IE.UTF-8";
  console = {
    font = "latarcyrheb-sun32";
    keyMap = "uk";
  };

  fonts.fonts = with pkgs; [ iosevka font-awesome-ttf ];

  time.timeZone = "Europe/Dublin";

  environment.systemPackages = with pkgs;
    [
      # unfree
      google-chrome
      spotify
    ] ++ [
      networkmanagerapplet
      pass
      browserpass
      gnupg1
      irssi
      gnuplot
      libreoffice
      simplescreenrecorder
      git
      vim
      brackets
      graphviz
      gifsicle
      vlc
      rhythmbox
      ispell
      bluez
      blueman
      pandoc
      gnupg
    ] ++ [
      # Dev Stuff
      nodejs
      gcc
      llvm
      cmake
      gnumake
      gnum4
    ] ++ [
      # System Tools
      nixops
      wget
      dhcpcd
      file
      less
      rlwrap
      findutils
      perf-tools
      htop
      pkgconfig
      numactl
      diffutils
      screen
      tmux
      xorg.libpciaccess
      hfsprogs
      # dmg2img
      mkinitcpio-nfs-utils
      ripgrep
      htop
      zsh
      p7zip
      dpkg
      jq
      tshark
      pciutils
      parted
      gparted
      binutils
      unzip
      tree
    ];

  services.openssh.enable = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "ctrl:swapcaps";
  services.xserver.libinput.enable = true;
  services.xserver.windowManager.i3.enable = true;
  services.xserver.displayManager.lightdm.enable = true;

  users.users.padraic = {
    isNormalUser = true;
    home = "/home/padraic";
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
    password = "test";
  };

  home-manager.users.padraic = { pkgs, ... }: { programs.zsh.enable = true; };

  system.stateVersion = "20.09";

}

