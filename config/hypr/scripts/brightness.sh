
#!/usr/bin/env bash

if [[ "$#" != 1 || ! ("$1" == "inc" || "$1" == "dec") ]]; then
    printf "Usage: %s [inc|dec]\n" "$0" >&2
    exit 1
fi

# Check if brightnessctl is available
if ! command -v brightnessctl &> /dev/null; then
  echo "Error: brightnessctl is not installed. Please install it." >&2
  exit 1
fi

# Perform brightness adjustment
if [[ "$1" == "inc" ]]; then
  brightnessctl set +10% > /dev/null
  notify_brightness
elif [[ "$1" == "dec" ]]; then
  brightnessctl set 10%- > /dev/null
  notify_brightness
fi
