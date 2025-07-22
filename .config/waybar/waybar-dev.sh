#!/usr/bin/env nix-shell
#! nix-shell -i bash
#! nix-shell -p inotify-tools

CONFIG_DIR="$HOME/dotfiles/.config/waybar"
WAYBAR_PID=""

start_waybar() {
    env GTK_DEBUG=interactive waybar -c "$CONFIG_DIR/config.jsonc" -s "$CONFIG_DIR/style.css" &
    WAYBAR_PID=$!
    echo "Started waybar (PID: $WAYBAR_PID)"
}

reload_waybar () {
    [[ -n "$WAYBAR_PID" ]] && kill -SIGUSR2 "$WAYBAR_PID" 2>/dev/null
}

stop_waybar() {
    [[ -n "$WAYBAR_PID" ]] && kill "$WAYBAR_PID" 2>/dev/null
    WAYBAR_PID=""
}

cleanup() {
    stop_waybar
    exit 0
}

trap cleanup SIGINT SIGTERM

echo "Watching $CONFIG_DIR for changes..."
start_waybar

while inotifywait -q -e modify,create,delete "$CONFIG_DIR"; do
    echo "Config changed, restarting waybar..."
    reload_waybar
    sleep 0.1
done
