#!/bin/bash

WORKSPACE_NAME="gemini"
PID_FILE="/tmp/gemini_firefox.pid"

launch_gemini() {
    firefox -P "gemini-app" --class gemini-firefox --new-window "https://gemini.google.com" &
    echo $! > "$PID_FILE"
    
    sleep 0.8
    hyprctl dispatch togglespecialworkspace $WORKSPACE_NAME
}

if [ -f "$PID_FILE" ]; then
    PID=$(cat "$PID_FILE")
    
    if kill -0 "$PID" 2>/dev/null; then
        hyprctl dispatch togglespecialworkspace $WORKSPACE_NAME
    else
        launch_gemini
    fi
else
    launch_gemini
fi