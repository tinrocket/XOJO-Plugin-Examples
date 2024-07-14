#!/bin/bash

# Define variables
SCRIPTS_DIR="${SRCROOT}/Plugin/"
BUILD_DIR="${CONFIGURATION_BUILD_DIR}/.."
PRODUCT_NAME="${PRODUCT_NAME}"
DEST_DIR="${SCRIPTS_DIR}/${PRODUCT_NAME}_Package/Build Resources/"
ZIP_FILE="${SCRIPTS_DIR}/${PRODUCT_NAME}.zip"
FINAL_ZIP_FILE="${SCRIPTS_DIR}/${PRODUCT_NAME}"

# Create necessary directories
mkdir -p "${DEST_DIR}/Mac arm64"
mkdir -p "${DEST_DIR}/Mac x86-64"
mkdir -p "${DEST_DIR}/iOS Device"
mkdir -p "${DEST_DIR}/iOS Simulator"

# Copy the build files to the destination directory
# Were building universal
cp -R "${BUILD_DIR}/Debug"/* "${DEST_DIR}/Mac arm64/"
cp -R "${BUILD_DIR}/Debug"/* "${DEST_DIR}/Mac x86-64/"
cp -R "${BUILD_DIR}/Debug-iphoneos"/* "${DEST_DIR}/iOS Device/"
cp -R "${BUILD_DIR}/Debug-iphoneos"/* "${DEST_DIR}/iOS Simulator/"

# Zip the destination directory
cd "${SCRIPTS_DIR}"
zip -r "${ZIP_FILE}" "${PRODUCT_NAME}_Package"

# Rename the zip file
mv "${ZIP_FILE}" "${FINAL_ZIP_FILE}"

# Open the scripts directory in Finder
open "${SCRIPTS_DIR}"

echo "Script executed successfully."
