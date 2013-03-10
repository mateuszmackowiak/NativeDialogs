#!/bin/sh

#  aneBuildBefore.sh
#  Maps
#
#  Created by Mateusz Mackowiak on 08.08.2012.
#

set -e

if [ "$CALLED_FROM_MASTER" ]
then
# This is the other build, called from the original instance
exit 0
fi

# Clean up prior to build

CURRENTCONFIG_DEVICE_DIR="${SYMROOT}/${CONFIGURATION}-iphoneos"
CURRENTCONFIG_SIMULATOR_DIR="${SYMROOT}/${CONFIGURATION}-iphonesimulator"
CURRENTCONFIG_UNIVERSAL_DIR="${SYMROOT}/${CONFIGURATION}-universal"

if [ ! -f "${CURRENTCONFIG_DEVICE_DIR}/${EXECUTABLE_NAME}" ]; then
echo "Device build cleaned; cleaning other builds too"
rm -f "${CURRENTCONFIG_SIMULATOR_DIR}/${EXECUTABLE_NAME}"
rm -f "${CURRENTCONFIG_UNIVERSAL_DIR}/${EXECUTABLE_NAME}"
elif [ ! -f "${CURRENTCONFIG_SIMULATOR_DIR}/${EXECUTABLE_NAME}" ]; then
echo "Simulator build cleaned; cleaning other builds too"
rm -f "${CURRENTCONFIG_DEVICE_DIR}/${EXECUTABLE_NAME}"
rm -f "${CURRENTCONFIG_UNIVERSAL_DIR}/${EXECUTABLE_NAME}"
fi