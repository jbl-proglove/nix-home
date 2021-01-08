# i suppose here goes the config specific to a laptop setup with xmonad
# let's stay watchful what that includes.
# fun :-D

{ config, lib, pkgs, attrsets, ... }:
let
  haskellPkgs = with pkgs.haskellPackages ; [
    ghc
    nix-tree
  ];

  xmonadPkgs = with pkgs; [
    haskellPackages.xmobar
    # networkmanager_dmenu
    # networkmanagerapplet
    xcape
    xorg.xkbcomp
    xorg.xmodmap
    xorg.xrandr
    nitrogen
  ];

  otherPkgs = with pkgs; [
    dunst
    compton
  ];

in
{
  imports = [
    # let's start out easy
    ../../program/terminal/tmux/default.nix
    ../../program/xmobar/default.nix
  ];

  nixpkgs.config.allowedUnfree = true;

  home.packages = xmonadPkgs ++ otherPkgs;

  services = {
    
  };

  # not entirely sure whether this is the right place for configuring this.
  # could also be a role, or maybe even a user thing.
  # let's see how it is to use lsd on a daily basis...
  programs.lsd = {
    enable = true;
    enableAliases = true;
  };

  # environment
  home.sessionVariables = {
    EDITOR = "vim";
    BROWSER = "firefox";
    TERMINAL = "alacritty";
  };

  programs.alacritty = {
    enable = true;
    settings = lib.attrsets.recursiveUpdate ( import ../../program/terminal/alacritty/default-settings.nix ) {
      background_opacity = 0.9;
      font.size = 9;
      font.user_thin_strokes = false;
      window.decorations = "full";
    };
  };

  xsession.windowManager.xmonad = {
    enable = true;
    extraPackages = haskellPackages: [
      haskellPackages.xmobar
    ];
  };

  xdg.configFile = {
    # TODO I'm not sure how this should work. the source uses bspwm, and I guess this is some
    # global config - which I don't need for xmonad
    # UPDATE: now I think, this is just fine, I'll put the xmonad config there...
    #"xmonad".source = ../../de/de/xmonad;
    "dunst/dunstrc".source = ../../de/notifications/dunst/dunstrc;
    # this is a deviation from the original source, but I don't get, why the dude added
    # a machine-specific compton config here instead of putting it in the machine/... dir
    "compton/compton.conf".source = ../../de/compositors/compton/compton.conf;
  };
}
