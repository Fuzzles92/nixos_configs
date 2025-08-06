#!/usr/bin/env bash

# === Details ===
# Created by: Fuzzles92
# Created: Aug 08 2025
# Version: 0.3

# === To Do ===
# Add New Cinnamon script
# Add New Qtile script

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
#          Root Check                      #
#==========================================#
if [ "$EUID" -ne 0 ]; then
   echo -e "${red_start}Please run this script as root (e.g., sudo).${red_finish}"
   exit 1
fi

#==========================================#
#           Welcome Screen                 #
#==========================================#
clear
 echo -e $pink_start"=========================================="$pink_finish
 echo -e $pink_start"         🌹 Welcome to Fuzzles92's 🌹     "$pink_finish
 echo -e $pink_start"                NixOS Toolkit             "$pink_finish
 echo -e $pink_start"=========================================="$pink_finish
 echo

#==========================================#
#            GNOME Config                  #
#==========================================#
gnome_config() {
    echo -e $pink_start"==== GNOME Desktop Environment ===="$pink_finish
    read -p "Do you want to apply the GNOME Desktop Environment Config? (y/n): " confirm_update

    if [[ "$confirm_update" =~ ^[Yy]$ ]]; then
        echo ""
        echo "📦 Backing up original config file..."
        echo ""

        current_user="${SUDO_USER:-$USER}"
        timestamp="$(date +%Y%m%d-%H%M%S)"
        backup_path="/home/${current_user}/${timestamp}_configuration.nix"
        new_config="./nix_configurations/gnome_configuration.nix"

        if cp /etc/nixos/configuration.nix "$backup_path"; then
            echo -e "${green_start}✔ Backup Successful: $backup_path${green_finish}"
        else
            echo -e "${red_start}✖ Backup Failed. Check Permissions or Path.${red_finish}"
            return 1
        fi

        if cp "$new_config" /etc/nixos/configuration.nix; then
            echo ""
            echo -e "${green_start}✔ GNOME Configuration Applied!${green_finish}"
        else
            echo -e "${red_start}✖ Failed to apply GNOME Configuration.${red_finish}"
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
#          Cinnamon Config (Stub)          #
#==========================================#
cinnamon_config() {
    echo -e "${yellow_start}⛔ Cinnamon configuration not yet implemented.${yellow_finish}"
}

#==========================================#
#          Qtile Config (Stub)          #
#==========================================#
qtile_config() {
    echo -e "${yellow_start}⛔ Qtile configuration not yet implemented.${yellow_finish}"
}

#==========================================#
#           Rebuild NixOS                  #
#==========================================#
rebuild_nixos() {
    echo -e $pink_start"==== Rebuilding NixOS ===="$pink_finish
    echo "🛠 Rebuilding NixOS Configuration..."
    if nixos-rebuild switch; then
        echo""
        echo -e "${green_start}✔ Rebuild Successful.${green_finish}"
    else
        echo -e "${red_start}✖ Rebuild Failed. Check the Configuration.${red_finish}"
    fi
}

#==========================================#
#           Update NixOS                   #
#==========================================#
update_system() {
    echo -e $pink_start"==== Updating System ===="$pink_finish
    echo "📦 Updating system via nix-channel..."
    if nix-channel --update && nixos-rebuild switch; then
        echo ""
        echo -e "${green_start}✔ System Update Complete.${green_finish}"
    else
        echo -e "${red_start}✖ System Update Failed.${red_finish}"
    fi
}

#==========================================#
#     Desktop Environment Config Menu      #
#==========================================#
config_menu() {
    while true; do
        echo -e "${yellow_start}-- Configuration Selection Menu --${yellow_finish}"
        echo -e "1) GNOME Desktop Environment ${red_start}(Drax)${red_finish}"
        echo -e "2) Cinnamon Desktop Environment ${green_start}(Groot)${green_finish}"
        echo -e "3) Qtile Window Manager ${blue_start}(StarLord)${blue_finish}"
        echo "4) Back to Main Menu"
        echo
        read -p "Choose your desktop config [1-4]: " config_choice
        echo

        case $config_choice in
            1) gnome_config ;;
            2) cinnamon_config ;;
            3) qtile_config ;;
            4) break ;;
            *) echo -e "${red_start}Invalid choice. Try again.${red_finish}" ;;
        esac
        echo
    done
}

#==========================================#
#             Main Menu Loop               #
#==========================================#
while true; do
    echo -e "${pink_start}==== NixOS Toolkit Main Menu ====${pink_finish}"
    echo "1) Change Desktop Environment Configuration"
    echo -e "2) Rebuild NixOS ${pink_start}(nixos-rebuild switch)${pink_finish}"
    echo -e "3) Update System ${pink_start}(nix-channel --update)${pink_finish}"
    echo "4) Exit"
    echo
    read -p "Enter your choice [1-4]: " main_choice
    echo

    case $main_choice in
        1) config_menu ;;
        2) rebuild_nixos ;;
        3) update_system ;;
        4)
            echo -e "${pink_start}Ending Toolkit Goodbye!${pink_finish}"
            exit 0
            ;;
        *) echo -e "${red_start}Invalid choice. Try again.${red_finish}" ;;
    esac
    echo
done