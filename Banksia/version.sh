#!/bin/sh

#  version.sh
#  Banksia
#
#  Created by Dave Coleman on 28/5/2024.
#  

# This script is designed to increment the build number consistently across all
# targets.
# From: https://medium.com/@mateuszsiatrak/automating-build-number-increments-in-xcode-with-custom-format-a-practical-guide-bcc90a19f716

# Navigate to the directory inside the source root.
cd "$SRCROOT/$PRODUCT_NAME"

# Parse the 'Config.xcconfig' file to retrieve the previous build number.
# The 'awk' command is used to find the line containing "BUILD_NUMBER"
# and the 'tr' command is used to remove any spaces.
previous_build_number=$(awk -F "=" '/BUILD_NUMBER/ {print $2}' Config.xcconfig | tr -d ' ')

# Increment the build number.
new_build_number=$((previous_build_number + 1))

# Use 'sed' command to replace the previous build number with the new build
# number in the 'Config.xcconfig' file.
sed -i -e "/BUILD_NUMBER =/ s/= .*/= $new_build_number/" Config.xcconfig

# Remove the backup file created by 'sed' command.
rm -f Config.xcconfig-e
