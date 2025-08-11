#==========================================#
#          Cinnamon Nix Configuation         #
#==========================================#

# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];
    
#==========================================#
#              Bootloader                  #
#==========================================#
boot.loader.grub.enable = true;
boot.loader.grub.device = "/dev/sda";
  
#==========================================#
#      Automatic Updates & Rebuild         #
#==========================================#
system.autoUpgrade = {
	enable = true;
	dates = "weekly";
	operation = "boot";
	};

#==========================================#
#           System Information             #
#==========================================#
  networking.hostName = "groot"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
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

  # Enable the X11 windowing 
  services.xserver.enable = true;
  
#==========================================#
#               Cinnamon DE                   #
#==========================================#
services.xserver.displayManager.lightdm = {
		enable = true;
		};
services.xserver.desktopManager.cinnamon.enable = true;
services.xserver.excludePackages = with pkgs; [
  	pkgs.xterm		# xTerm
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
	#vim
    ];
};

#==========================================#
#           Enable Applications            #
#==========================================#
programs.firefox = {
	enable = true;
	};
 
#==========================================#
#           Enable Unfree Packages         #
#==========================================#
nixpkgs.config.allowUnfree = true;

#==========================================#
#           Sysem Packages                 #
#==========================================#
environment.systemPackages = with pkgs; [
	# Other Applications
	wget			# World Wide Web Get
	git			# Git
	libreoffice		# Office Suite
	teamviewer		# Remote Client
	vlc			# Media & Video Player
	pika-backup		# Backup Software
  ];
  
#==========================================#
#           Enable Services                #
#==========================================#
services.teamviewer.enable = true;     # Teamviewer
services.flatpak.enable = true;        # Flatpak

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "25.05"; # Did you read the comment?

}
