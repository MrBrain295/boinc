#!/bin/sh
set -e

#
# See: https://boinc.berkeley.edu/trac/wiki/AndroidBuildClient
#

# Script to compile everything BOINC needs for Android

./buildAndroidBOINC-CI.sh --cache_dir "$ANDROID_TC" --build_dir "$BUILD_DIR" --silent --ci --arch arm
./buildAndroidBOINC-CI.sh --cache_dir "$ANDROID_TC" --build_dir "$BUILD_DIR" --silent --ci --arch arm64
./buildAndroidBOINC-CI.sh --cache_dir "$ANDROID_TC" --build_dir "$BUILD_DIR" --silent --ci --arch x86
./buildAndroidBOINC-CI.sh --cache_dir "$ANDROID_TC" --build_dir "$BUILD_DIR" --silent --ci --arch x86_64

if [ ! -d ../3rdParty/buildCache/android-tc/arm ]; then
    echo You run this script from diffrent folder: $PWD
    echo Please run it from boinc/android
    exit 1
fi

for i in "libcrypto.a" "libssl.a" "libcurl.a"; do
    if [ $(readelf -A $(find ../3rdParty/buildCache/android-tc/arm  -name "$i") | grep -i neon | head -c1 | wc -c) -ne 0 ]; then
        echo "$i" is with neon optimization
        exit 1
    fi
done

echo '===== BOINC for all platforms build done ====='
