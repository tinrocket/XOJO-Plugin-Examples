#!/bin/bash

# Define the directory to clean
DIRECTORY="${BUILD_DIR}/Debug"

# Check if the directory exists
if [ -d "$DIRECTORY" ]; then
  echo "Cleaning directory: $DIRECTORY"
  # Remove all files and directories inside the specified directory
  rm -rf "$DIRECTORY"/*
else
  echo "Directory does not exist: $DIRECTORY"
fi
