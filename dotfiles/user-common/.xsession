#!/bin/sh
# This is an example config that one can use as a base for their configuration of X11.

# Setting up monitors.
# xrandr --output DP-2 --mode 3840x2160 --rate 60 --primary
# xrandr --output DP-4 --right-of DP-2 --mode 1920x1080 --rate 144 --scale-from 3840x2160

# Setting up a compose key that is bound to scroll lock.
setxkbmap -option compose:sclk

# Setting environment variables relevant for a GUI session, like app scaling modifiers.
# export GDK_SCALE=2
# export GDK_DPI_SCALE=0.8
# export QT_FONT_DPI=192
export GTK_THEME=Colloid-Pink-Dark-Catppuccin # TODO: Remove this, and set this theme correctly!

# Function for starting up my apps automatically. This is a little hacky, but it's what I prefer
# over adding a patch into dwm.
app_autostart() {
    sleep 0.2

    flatpak run app.zen_browser.zen &
    flatpak run dev.vencord.Vesktop &

    xdotool key Super_L+period
    st &
}

# Using i3status as the status line. stdout from i3status is forwarded to the X11 root window's
# title.
i3status | while read -r line; do
    xsetroot -name "$line"
done &

# Starting up programs that should be omnipresent in the X session.
redshift &
flameshot &
xscreensaver --no-splash &
unclutter -idle 20 &

# This is a custom script that switches the wallpaper once every hour, and uses different
# wallpapers depending on if it's daytime or nighttime.
# cycle_backgrounds ~/Pictures/Wallpaper\ Poop/Used\ Walls/ 00:00-23:59 &
xsetroot -solid '#181825'

# Playing an awesome startup sound, because those are fun! :3
aplay ~/Sounds/Startup/PlayStation\ 1\ Startup.wav &
app_autostart &

# Starting up dwm, with the ability to immediately restart it in-place if it gives back an exit
# code of 2.
while true; do
    dwm 2> /tmp/dwm.log
    case $? in
        2) continue;;
        *) exit;;
    esac
done

