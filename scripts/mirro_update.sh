#!/bin/bash

# Default values
COUNTRY=""
NUM=10
AGE=12
MIRRORLIST="/etc/pacman.d/mirrorlist"

# Help message
usage() {
  echo "Usage: $0 [global|india] [number_of_mirrors]"
  echo
  echo "Examples:"
  echo "  $0 global 20      # Top 20 fastest mirrors worldwide"
  echo "  $0 india 5        # Top 5 fastest mirrors in India"
  exit 1
}

# Parse arguments
if [[ $# -lt 1 ]]; then
  usage
fi

if [[ "$1" == "global" ]]; then
  COUNTRY=""
elif [[ "$1" == "india" ]]; then
  COUNTRY="India"
else
  echo "❌ Unknown region: $1"
  usage
fi

if [[ -n "$2" ]]; then
  NUM="$2"
fi

# Run Reflector
echo "🌐 Updating mirrorlist..."
echo "Region   : ${COUNTRY:-Global}"
echo "Mirrors  : $NUM"
echo "Updating /etc/pacman.d/mirrorlist..."

sudo reflector \
  ${COUNTRY:+--country "$COUNTRY"} \
  --age "$AGE" \
  --protocol https \
  --sort rate \
  --latest "$NUM" \
  --save "$MIRRORLIST"

if [ $? -eq 0 ]; then
  echo "✅ Mirrorlist updated successfully!"
else
  echo "❌ Failed to update mirrorlist."
fi
