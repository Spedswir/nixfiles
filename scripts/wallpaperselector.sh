#!/usr/bin/env bash

# Export required environment variables
export DISPLAY=:0
export XAUTHORITY="$HOME/.Xauthority"
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/$(id -u)/bus"

# Get current hour and day (1=Mon, 7=Sun)
HOUR=$(date +%H)
WEEKDAY=$(date +%u)
echo "Selected Weekday is: $WEEKDAY"
echo "Selected hour is: $HOUR"

# Wallpaper Locations
ALL_DIR="$HOME/Documents/git-repos/wallpapers/"
SFW_DIR="$HOME/Documents/git-repos/wallpapers/SFW/"

# Choose folder based on time and day
if [[ 10#"$WEEKDAY" -le 5 ]]; then
    # Weekday during work hours
    if [[ 10#"$HOUR" -ge 8 && 10#"$HOUR" -lt 17 ]]; then
        echo "Weekday work hours background selected..."
        DIR="$SFW_DIR"
    else
        echo "Weekday after hours background selected..."
        DIR="$ALL_DIR"
    fi
else
    echo "Weekend background selected..."
    # Weekend
    DIR="$ALL_DIR"
fi

# Pick a random file from the folder and all its subfolders, skipping hidden
# files and folders such as .git
IMAGE=$(find "$DIR" -type f -not -path '*/.*' | shuf -n 1)

if [[ -z "$IMAGE" ]]; then
    echo "No wallpapers found in $DIR"
    exit 1
fi
echo "Selected wallpaper: $IMAGE"

# Apply wallpaper (Wayland-safe)
plasma-apply-wallpaperimage "$IMAGE"
