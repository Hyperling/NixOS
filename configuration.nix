# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";
  boot.loader.grub.useOSProber = true;

  # Setup keyfile
  boot.initrd.secrets = {
    "/crypto_keyfile.bin" = null;
  };

  # Enable grub cryptodisk
  boot.loader.grub.enableCryptodisk=true;

  boot.initrd.luks.devices."luks-39ae7203-d5af-47bf-95f6-b4f0eefebfc6".keyFile = "/crypto_keyfile.bin";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Phoenix";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "en_US.UTF-8";
    LC_IDENTIFICATION = "en_US.UTF-8";
    LC_MEASUREMENT = "en_US.UTF-8";
    LC_MONETARY = "en_US.UTF-8";
    LC_NAME = "en_US.UTF-8";
    LC_NUMERIC = "en_US.UTF-8";
    LC_PAPER = "en_US.UTF-8";
    LC_TELEPHONE = "en_US.UTF-8";
    LC_TIME = "en_US.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome.enable = true;

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "altgr-intl";
  };

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.ling = {
    isNormalUser = true;
    description = "Hyperling";
    extraGroups = [ "networkmanager" "wheel" "sudo" "mlocate" ];
    packages = with pkgs; [
      #firefox
      #thunderbird
    ];
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  ##
  # TBD
  # Make each section is own $.nix file and include it based on Ansible checks?
  # Remove the GNOME default packages.
  #services.gnome.core-utilities.enable = false;
  # GSettings, DConf type stuff. #
  #   https://nixos.wiki/wiki/GNOME
  #   https://hoverbear.org/blog/declarative-gnome-configuration-in-nixos/
  services.xserver.desktopManager.gnome = {
    extraGSettingsOverrides = ''
      # Favorite apps in gnome-shell
      [org.gnome.shell]
      favorite-apps= \
        [ 'org.gnome.Terminal.desktop', 'gnome-system-monitor.desktop' \
        , 'org.gnome.Nautilus.desktop' \
        , 'librewolf.desktop', 'firefox.desktop' \
        , 'org.gnome.Evolution.desktop', 'deltachat.desktop' \
        , 'codium.desktop' \
        , 'org.shotcut.Shotcut.desktop', 'lbry.desktop' \
        , 'android-studio.desktop' \
        , 'signal-desktop.desktop' \
        ]

      # TBD Need to finish figuring out how to load these.
      [org.gnome.shell.extensions.dash-to-dock]
      dock-position='LEFT'
      dock-fixed=true
      dash-max-icon-size=28
    '';

    extraGSettingsOverridePackages = [
      pkgs.gnome.gnome-shell # for org.gnome.shell
      #pkgs.gnome.gnomeExtensions.dock-from-dash # Not sure what to do here yet.
    ];
  };
  ###

  ## List packages installed in system profile. ##
  # To search, run `nix search wget` or visit: https://search.nixos.org/packages
  environment.systemPackages = with pkgs; [
    # General
    ansible
    vim
    mlocate
    git
    curl
    sudo
    doas
    wget
    nmap
    lynis
    htop
    neofetch
    cowsay

    # Coding
    vscodium
    android-studio
    dbeaver
    bash
    kotlin
    nodejs
    ksh
    zsh
    zulu  # OpenJDK
    #zulu8 # OpenJDK 8
    #python2
    #python
    python3

    # Editing
    gimp
    shotcut
    openshot-qt
    obs-studio
    ffmpeg

    # Workstation
    gnomeExtensions.dock-from-dash
    gnome.nautilus
    gnome.gnome-tweaks
    gnome.dconf-editor
    gnome.gnome-terminal
    gnome.gnome-system-monitor
    gnome.gedit
    gnome.geary
    gnome.evince
    librewolf
    firefox
    evolution
    deltachat-desktop
    signal-desktop
    lbry
    libreoffice
    vlc
    remmina
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  ## List services that you want to enable ##

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Be able to use the locate command.
  services.locate.locate = pkgs.mlocate;
  services.locate.localuser = null;
  services.locate.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
