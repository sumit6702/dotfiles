#!/bin/bash



RED="\e[31m"
GREEN="\e[32m"
ECOL="\e[0m"


hypr_session="$HOME/.config/hypr-session.txt"

if [ "$1" = "save" ]; then
    
    echo "Saving Session..."
    
    # Create the session file
    > "$hypr_session"

    hyprctl clients | awk '
    /^Window/ {
        if (class && workspace && x && y && width && height) {
            print class, workspace, x, y, width, height
        }
        class = ""
        workspace = ""
        x = ""
        y = ""
        width = ""
        height = ""
    }
    /class:/ { class=$2 }
    /at:/ { at=$2; split(at, pos, ","); x=pos[1]; y=pos[2] }
    /size:/ { size=$2; split(size, dim, ","); width=dim[1]; height=dim[2] }
    /workspace:/ {
        split($2, ws, " ")
        workspace=ws[1]
    }
    END {
        # Print the last window
        if (class && workspace && x && y && width && height) {
            print class, workspace, x, y, width, height
        }
    }
    ' > "$hypr_session"

    echo -e "${GREEN}Session saved...${ECOL}"
elif [ "$1" = "load" ]; then
    
    echo "Restoring Session..."
    
    # Check if the session file exists
    if [ ! -f "$hypr_session" ]; then
      echo -e "${RED}Error: no session found! run 'hypr-session.sh save' first! ${ECOL}"
      exit 1
    fi

    # Read the session file and restore the windows
    while read -r class workspace x y width height; do 
       class_lower=$(echo "$class" | tr '[:upper:]' '[:lower:]')

       echo -e "${GREEN}Executing: hyprctl dispatch exec \"[workspace $workspace] $class\"${ECOL}" 

       if [ "$class_lower" = "zen-alpha" ]; then 
          hyprctl dispatch exec "[workspace $workspace slient] zen-browser"
       elif [ "$class_lower" = "org.kde.dolphin" ]; then
          hyprctl dispatch exec "[workspace $workspace silent] dolphin"
       else       
          hyprctl dispatch exec "[workspace $workspace silent] $class_lower"      
       fi
       sleep 0.2   
    done < "$hypr_session"

    echo -e "${GREEN}Session restored...${ECOL}"

else
    echo "Usage: hypr-session.sh [save|restore]"
    exit 1
fi
