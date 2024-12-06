#!/bin/bash

if [ "$(id -u)" -ne 0 ]; then
    echo "This script must be run as root. Use 'sudo'."
    exit 1
fi

echo "Minimizing GNOME to gnome-core setup while removing LibreOffice, Transmission, and keeping extensions and icons..."

PACKAGES_TO_REMOVE=(
    gnome-games
    gnome-weather
    gnome-calendar
    gnome-contacts
    gnome-maps
    gnome-photos
    gnome-music
    rhythmbox
    totem
    shotwell
    cheese
    evolution
    brasero
    bijiben
    libreoffice*
    transmission*
)

# Remove packages
for pkg in "${PACKAGES_TO_REMOVE[@]}"; do
    if dpkg -l | grep -q "^ii\s*${pkg}"; then
        echo "Removing: $pkg"
        apt purge -y "$pkg"
    else
        echo "$pkg is not installed, skipping..."
    fi
done

# Clean up unused packages
echo "Cleaning up unused packages..."
apt autoremove -y --purge

# Reinstall minimal GNOME (gnome-core) without additional recommendations
echo "Reinstalling minimal GNOME (gnome-core)..."
apt install -y --no-install-recommends gnome-core gdm3

# Preserve GNOME Shell extensions
echo "Preserving GNOME Shell extensions..."
if dpkg -l | grep -q gnome-shell-extensions; then
    echo "GNOME Shell extensions are already installed."
else
    echo "Installing GNOME Shell extensions..."
    apt install -y gnome-shell-extensions
fi

# Clean the cache
apt clean
rm -rf /var/cache/apt/archives/*
rm -rf /tmp/*

echo "GNOME is now minimized to a gnome-core setup with LibreOffice, Transmission removed, extensions and icons preserved!"
echo "Consider restarting your system with: sudo reboot"
