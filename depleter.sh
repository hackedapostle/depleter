#!/bin/bash

# Function to run high CPU usag
efunction high_cpu_usage {
    echo "Starting high CPU usage..."
    # Create multiple CPU-intensive processes
    for i in {1..8}; do  # Adjust the number of processes based on your CPU cores
        (while true; do :; done) &
    done
    CPU_PID=$!
}

# Function to run high memory usage
function high_memory_usage {
    echo "Starting high memory usage..."
    # Allocate a large amount of memory (e.g., 4 GB)
    malloc_size=$((4 * 1024 * 1024 * 1024)) # 4 GB
    dd if=/dev/zero of=/dev/shm/memory_hog bs=1 count=0 seek=$malloc_size &
    MEM_PID=$!
}

# Function to simulate slow typing in terminal
function slow_typing_terminal {
    echo "Opening terminal and typing slowly..."
    sleep 5
    xfce4-terminal &
    sleep 2
    # Simulate slow typing
    for char in "echo 'Hello, this is a slow typing simulation!';"; do
        xdotool type --delay 200 "$char"  # Adjust delay as needed
    done
    xdotool key Return  # Press Enter
}

# Function to open applications slowly
function slow_app_opening {
    echo "Opening applications slowly..."
    slow_typing_terminal  # Open terminal with slow typing
    sleep 5 && firefox &
    sleep 5 && libreoffice &
    sleep 5 && mousepad &        # Text editor for XFCE
    sleep 5 && thunar &          # File manager
    sleep 5 && xfce4-taskmanager & # Task manager
    sleep 5 && vlc &             # Media player
    sleep 5 && galculator &       # Calculator
    sleep 5 && evince &          # Document viewer
}

# Function to move mouse around
function mouse_movement {
    echo "Moving mouse around..."
    while true; do
        xdotool mousemove_relative -- 100 0
        xdotool mousemove_relative -- 0 100
        xdotool mousemove_relative -- -100 0
        xdotool mousemove_relative -- 0 -100
    done &
    MOUSE_PID=$!
}

# Execute functions
high_cpu_usage
high_memory_usage
slow_app_opening
mouse_movement

# Wait for user to terminate the script
echo "Press [Enter] to stop all tasks..."
read

# Kill background processes
kill $CPU_PID
kill $MEM_PID
kill $MOUSE_PID

echo "All tasks stopped."
