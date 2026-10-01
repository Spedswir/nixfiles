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

# Ask Plasma how many desktops (one per screen) there are
QDBUS_ARGS=(org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript)
SCREENS=$(qdbus "${QDBUS_ARGS[@]}" 'print(desktops().length)')
if [[ ! "$SCREENS" =~ ^[0-9]+$ || "$SCREENS" -lt 1 ]]; then
    SCREENS=1
fi
echo "Detected screens: $SCREENS"

# Pick a random file per screen from the folder and all its subfolders,
# skipping hidden files and folders such as .git
mapfile -t IMAGES < <(find "$DIR" -type f -not -path '*/.*' | shuf -n "$SCREENS")

if [[ ${#IMAGES[@]} -eq 0 ]]; then
    echo "No wallpapers found in $DIR"
    exit 1
fi

# Build a JavaScript array of the images, escaping backslashes and quotes
JS_IMAGES=""
for IMAGE in "${IMAGES[@]}"; do
    echo "Selected wallpaper: $IMAGE"
    ESCAPED=${IMAGE//\\/\\\\}
    ESCAPED=${ESCAPED//\'/\\\'}
    JS_IMAGES+="'file://$ESCAPED',"
done

# Apply a different wallpaper to each screen (Wayland-safe). If there are
# fewer images than screens, images are reused.
qdbus "${QDBUS_ARGS[@]}" "
var images = [$JS_IMAGES];
var allDesktops = desktops();
for (var i = 0; i < allDesktops.length; i++) {
    var d = allDesktops[i];
    d.wallpaperPlugin = 'org.kde.image';
    d.currentConfigGroup = ['Wallpaper', 'org.kde.image', 'General'];
    d.writeConfig('Image', images[i % images.length]);
}
"
