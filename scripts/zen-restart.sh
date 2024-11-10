#!/bin/bash

# Check if zen-browser is running by using its class "zen-alpha"
if pgrep -x "zen-alpha" > /dev/null || pgrep -f "zen-browser" > /dev/null
then
    pkill -f "zen-browser"
    #sleep 1
    zen-browser &
fi

