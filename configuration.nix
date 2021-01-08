# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # boot from boot partition on sda3
  boot.loader.grub.device = /dev/sda3;

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "safina"; # = ship
  networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  time.timeZone = "Europe/Amsterdam";

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp3s0.useDHCP = true;
  networking.interfaces.wlp2s0.useDHCP = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";
  console = {
  #  font = "Lat2-Terminus16";
    keyMap = "de";
  };

  

  services.xserver.enable = true;
  services.xserver.windowManager = {
    xmonad.enable = true;
    xmonad.enableContribAndExtras = true;
    xmonad.extraPackages = hpkgs: [
      hpkgs.xmonad-contrib
      hpkgs.xmonad-extras
      hpkgs.xmonad
      # here starts the more experimental part...
      # termonad is looking nice for a terminal emulator...
      # hpkgs.termonad
    ];
  };

  services.xserver.desktopManager.xterm.enable = false;

  services.xserver.displayManager = {
    defaultSession = "none+xmonad";
  };

  services.udisks2.enable = true;
  services.devmon.enable = true;

# TODO can I move this to home-manager?
  fonts.fonts = with pkgs; [
    opensans-ttf
    (nerdfonts.override { fonts = ["FiraCode" "DroidSansMono"]; })
#    fira-code
#    fira-code-symbols
  ];

  # Configure keymap in X11
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.noah = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ]; # Enable ‘sudo’ for the user.
  };

  users.users.julius = {
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" ];
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    wget
    vim
    home-manager
    curl
    git
    #curlie
    firefox
# TODO can I move this to home-manager?
    nerdfonts
#    fira-code
#    fira-code-symbols
    #dunst
    #rofi
    #rofi-calc
    #jq
    #yq
    #zsh
    #terminator
    #tmux
    #tmuxinator
    #pass
    #httpie
    # this is where experimentation starts. Some of it should probably also go to the user configs
    #ansible
    #ansible-lint
    # Try this as an alternative to terminator or termonad
    alacritty
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [ 22 ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?

}

