#==========================================#
#           My Nix Configuation            #
#==========================================#

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

#==========================================#
#           GNOME gSettings                #
#==========================================#

#gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
#gsettings set org.gnome.desktop.interface cursor-size 24
#gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
#gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
#gsettings set org.gnome.shell.extensions.user-theme name 'Adwaita'

#==========================================#
#           Nix Useful Commands            #
#==========================================#
#nixos-help
#sudo nixos-rebuild switch # Rebuild and Switch
#sudo nixos-rebuild boot # Rebuild and wait till reboot
#sudo nixos-rebuild switch --upgrade # Upgrade and Switch
#sudo nix-collect-garbage --delete-old # Delete All But Current Image

{ config, pkgs, ... }:

#==========================================#
#                Imports                   #
#==========================================#
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./lanzaboote.nix
    ];

#==========================================#
#              Bootloader                  #
#==========================================#
boot.loader.systemd-boot.enable = true;
boot.loader.efi.canTouchEfiVariables = true;

#==========================================#
#      Automatic Updates & Rebuild         #
#==========================================#
system.autoUpgrade = {
	enable = true;
	dates = "weekly";
	operation = "boot";
	};

#==========================================#
#               Systemd                    #
#==========================================#
systemd.user.services.podman.enable = true;

#==========================================#
#           System Information             #
#==========================================#
networking.hostName = "Thor"; # Define your hostname.
networking.networkmanager.enable = true;
time.timeZone = "Europe/London";

# Select internationalisation properties.
i18n.defaultLocale = "en_GB.UTF-8";

i18n.extraLocaleSettings = {
  LC_ADDRESS = "en_GB.UTF-8";
  LC_IDENTIFICATION = "en_GB.UTF-8";
  LC_MEASUREMENT = "en_GB.UTF-8";
  LC_MONETARY = "en_GB.UTF-8";
  LC_NAME = "en_GB.UTF-8";
  LC_NUMERIC = "en_GB.UTF-8";
  LC_PAPER = "en_GB.UTF-8";
  LC_TELEPHONE = "en_GB.UTF-8";
  LC_TIME = "en_GB.UTF-8";
};

  # Enable the X11 windowing system.
  # You can disable this if you're only using the Wayland session.
  services.xserver.enable = true;

#==========================================#
#               GNOME DE                   #
#==========================================#
services.xserver.displayManager.gdm = {
		enable = true;
		};
services.xserver.desktopManager.gnome.enable = true;
services.xserver.excludePackages = with pkgs; [
  	pkgs.xterm		# xTerm
  ];
  
#==========================================#
#             GNOME Excludes               #
#==========================================#
environment.gnome.excludePackages = with pkgs.gnome; [
	pkgs.gnome-calendar		# Gnome Calendar
	pkgs.gnome-characters		# Gnome Characters
	pkgs.gnome-clocks		# Gnome Clocks
	pkgs.gnome-contacts		# Gnome Contacts
	pkgs.gnome-font-viewer		# Gnome Font Viewer
	pkgs.gnome-logs			# Gnome Logs
	pkgs.gnome-maps			# Gnome Maps
	pkgs.gnome-music		# Gnome Music
	pkgs.gnome-photos		# Gnome Photos
	pkgs.gnome-weather		# Gnome Weather
	pkgs.gnome-connections		# Gnome Connections
	pkgs.gnome-tour			# Gnome Tour
	pkgs.snapshot			# Gnome Camera
	pkgs.decibels			# Gnome Music Player
	pkgs.totem			# Gnome Video Player
	pkgs.geary			# Gnome Email Client
	pkgs.baobab			# Gnome Disk Usage Analyzer
	pkgs.seahorse			# Gnome Password Manager
	pkgs.epiphany			# Gnome Web Browser
	pkgs.yelp			# Gnome Help Viewer
	#pkgs.gnome-system-monitor	# Gnome System Monitor
	#pkgs.gnome-disk-utility	# Gnome Disk Utility
	#pkgs.gnome-text-editor		# Gnome Text Editor
	#pkgs.simple-scan		# Gnome Document Scanner
	#pkgs.evince			# Gnome Docment Viewer
	#pkgs.loupe			# Gnome Image Viewer
	#pkgs.file-roller		# Gnome Archive Manager
	#pkgs.gnome-calculator		# Gnome Calculator
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "gb";
    variant = "";
  };

  # Configure console keymap
  console.keyMap = "uk";

#==========================================#
#         Printing (CUPS & Drivers)        #
#==========================================#
services.printing.enable = true;
services.printing.drivers = [ 
	#pkgs.gutenprint # — Drivers for many different printers from many different vendors.
	#pkgs.gutenprintBin # — Additional, binary-only drivers for some printers.
	pkgs.hplip # — Drivers for HP printers.
	#pkgs.hplipWithPlugin # — Drivers for HP printers, with the proprietary plugin.
	#pkgs.postscript-lexmark # — Postscript drivers for Lexmark
	#pkgs.samsung-unified-linux-driver # — Proprietary Samsung Drivers
	#pkgs.splix # — Drivers for printers supporting SPL (Samsung Printer Language).
	#pkgs.brlaser # — Drivers for some Brother printers
	#pkgs.brgenml1lpr #  — Generic drivers for more Brother printers [1]
	#pkgs.brgenml1cupswrapper  # — Generic drivers for more Brother printers [1]
	#pkgs.cnijfilter2 # — Drivers for some Canon Pixma devices (Proprietary driver)
	]; 
	
#==========================================#
#           Sound (Pipewire)               #
#==========================================#
  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
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

#==========================================#
#               User Information           #
#==========================================#
# Define a user account. Don't forget to set a password with ‘passwd’.
users.users.fuzzles = {
    isNormalUser = true;
    description = "Fuzzles";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
	gnome-tweaks		# Additional Gnome Changes
	wget			# World Wide Web Get
	git			# Git
	thunderbird		# Email Client
	libreoffice		# Office Suite
	discord			# Discord Client
	spotify			# Spotify Client
	vscode			# Code Editor
	podman			# Container Engine
	distrobox		# Containers
	boxbuddy		# GUI For Distrobox
	ignition		# Start up Applications
	vlc			# Media & Video Player
	pika-backup		# Backup Application
    ];
  };

#==========================================#
#           Enable Applications            #
#==========================================#
programs.firefox = {
	enable = true;
	};
programs.steam = {
	enable = true;
	remotePlay.openFirewall = true;
	dedicatedServer.openFirewall = true;
	localNetworkGameTransfers.openFirewall = true;
	};
programs.virt-manager.enable = true;
	virtualisation.libvirtd.enable = true;
	virtualisation.spiceUSBRedirection.enable = true;
	users.groups.libvirtd.members = ["fuzzles"];

#==========================================#
#           Enable Unfree Packages         #
#==========================================#
  nixpkgs.config.allowUnfree = true;

#==========================================#
#           Sysem Packages                 #
#==========================================#
environment.systemPackages = with pkgs; [
	# Gnome Extensions
	gnomeExtensions.appindicator
	gnomeExtensions.blur-my-shell
	gnomeExtensions.dash-to-dock
	gnomeExtensions.caffeine
	gnomeExtensions.gsconnect
	gnomeExtensions.logo-menu
	gnomeExtensions.search-light
	# Other Packages
	sbctl			# Secure Boot Key Manager
	niv			# Easy Dependency Management for Nix Projects
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

#==========================================#
#           Enable Services                #
#==========================================#
services.teamviewer.enable = true;     # Teamviewer
services.flatpak.enable = true;        # Flatpak

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;
  
#==========================================#
#           State Version                  #
#==========================================#
# This value determines the NixOS release from which the default
# settings for stateful data, like file locations and database versions
# on your system were taken. It‘s perfectly fine and recommended to leave
# this value at the release version of the first install of this system.
# Before changing this value read the documentation for this option
# (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
system.stateVersion = "25.05"; # Did you read the comment?

}
