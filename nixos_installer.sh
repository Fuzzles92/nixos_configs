#!/usr/bin/env bash

# === Details ===
# Created by: Fuzzles92
# Created: Aug 08 2025
# Version: 0.2


#gsettings set org.gnome.desktop.interface cursor-theme 'Adwaita'
#gsettings set org.gnome.desktop.interface cursor-size 24
#gsettings set org.gnome.desktop.interface icon-theme 'Adwaita'
#gsettings set org.gnome.desktop.interface gtk-theme 'Adwaita'
#gsettings set org.gnome.shell.extensions.user-theme name 'Adwaita'


# === To Do ===
# rename file to nixos_toolkit
# Add New Cinnamon script
# Add gsettings set to Gnome
# rebuild on boot
# after rebuild do you want to restart?
#
# new menu to support Config update
# new menu to update/build of nixos

#==========================================#
#              Colours                     #
#==========================================#
pink_start="\e[38;5;212m"
pink_finish="\e[0m"
blue_start="\e[1;34m"
blue_finish="\e[0m"
green_start="\033[1;32m"
green_finish="\033[0m"
yellow_start="\033[1;33m"
yellow_finish="\033[0m"
red_start="\033[1;31m"
red_finish="\033[0m"

#==========================================#
#           Welcome Screen                 #
#==========================================#
clear
echo -e $pink_start"=========================================="$pink_finish
echo -e $pink_start"         🌹 Welcome to Fuzzles92 🌹       "$pink_finish
echo -e $pink_start"          NixOS Installer Toolkit         "$pink_finish
echo -e $pink_start"=========================================="$pink_finish
echo

#==========================================#
#            Gnome Config                  #
#==========================================#
gnome_config() {
    read -p "Do you want to use the GNOME Desktop Environment Config? (y/n): " confirm_update

    if [[ "$confirm_update" =~ ^[Yy]$ ]]; then
        echo ""
        echo "📦 Backing up original config file..."
        echo ""

        # Get current user and timestamp
        current_user="${SUDO_USER:-$USER}"
        timestamp="$(date +%Y%m%d-%H%M%S)"
        backup_path="/home/${current_user}/${timestamp}_configurations.nix"
        new_config="./configurations/gnome_configuration.nix"

        # Ensure the Backup Directory Exists
        if cp /etc/nixos/configuration.nix "$backup_path"; then
            echo -e "${green_start}✔ Backup Successful: $backup_path${green_finish}"
            echo ""
        else
            echo -e "${red_start}✖ Backup Failed. Check Permissions or Path.${red_finish}"
            return 1
        fi

        # Copies Over New Config File
        if sudo cp "$new_config" /etc/nixos/configuration.nix; then
             echo ""
             echo -e "${green_start}✔ GNOME configuration applied.: $backup_path${green_finish}"
        else
             echo -e "${red_start}✖ Failed to apply GNOME config.${red_finish}"
             return 1
        fi

        echo ""
        echo -e "${green_start}✔ GNOME Desktop Environment Setup Complete.${green_finish}"

    else
        echo ""
        echo -e "${yellow_start}⏭ Skipping GNOME Desktop Environment install...${yellow_finish}"
    fi
}

#==========================================#
#             Menu Loop                    #
#==========================================#
while true; do
    echo -e "${blue_start}Please Pick an Configuation Option:${blue_finish}"
    echo ""
    echo -e "1) Gnome Desktop Environment ${red_start}(Drax)${red_finish}"
    echo -e "2) Cinnamon Desktop Environment ${green_start}(Groot)${green_finish}"
    echo "3) Exit"
    echo
    read -p "Enter choice [1-3]: " choice
    echo

    case $choice in
        1) gnome_config ;;
        2) enable_multilib ;;
        3)
            echo -e "${green_start}Exiting NixOS Installer. Goodbye!${green_finish}"
            echo
            break
            ;;
        *) echo -e "${red_start}Invalid Choice. Try again.${red_finish}" ;;
    esac
    echo
done