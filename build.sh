#!/usr/bin/env bash

# Copyright 2022 Michael F. Collins, III
#
# Permission is hereby granted, free of charge, to any person obtaining a
# copy of this software and associated documentation files (the "Software"),
# to deal in the Software without restrictions, including without limitation
# the rights to use, copy, modify, merge, publish, distribute, sublicense,
# and/or sell copies of the Software, and to permit persons to whom the
# Software is furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
# FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
# DEALINGS IN THE SOFTWARE.

# build.sh
#
# This program automated building OpenSSL to be linked into an iOS or macOS
# application, or to be used by other libraries that may be linked into
# applications.
#
# Usage: build.sh

set -e

ROOT_PATH=$PWD
TEMP_PATH=/tmp/openssl

CONFIGURATIONS="darwin64-x86_64 darwin64-arm64 openssl-ios64 openssl-iossimulator openssl-iossimulator-arm openssl-catalyst openssl-catalyst-arm"
for CONFIGURATION in $CONFIGURATIONS; do
    echo "Building OpenSSL for $CONFIGURATION"

    rm -rf $TEMP_PATH
    cp -r External/openssl /tmp/

    pushd $TEMP_PATH > /dev/null

    LOG="/tmp/openssl-$CONFIGURATION.log"
    rm -f $LOG

    OUTPUT_PATH=$ROOT_PATH/build/$CONFIGURATION
    rm -rf $OUTPUT_PATH
    mkdir -p $OUTPUT_PATH

    ./Configure "$CONFIGURATION" --config=$ROOT_PATH/ios-and-catalyst.conf --prefix=$OUTPUT_PATH no-shared >> $LOG 2>&1
    make >> $LOG 2>&1
    make install >> $LOG 2>&1

    popd > /dev/null
done

echo "Creating the universal libraries for macOS"

OUTPUT_PATH=$ROOT_PATH/build/macos
rm -rf $OUTPUT_PATH
mkdir -p $OUTPUT_PATH
lipo -create \
    $ROOT_PATH/build/darwin64-arm64/lib/libcrypto.a \
    $ROOT_PATH/build/darwin64-x86_64/lib/libcrypto.a \
    -output $OUTPUT_PATH/libcrypto.a
lipo -create \
    $ROOT_PATH/build/darwin64-arm64/lib/libssl.a \
    $ROOT_PATH/build/darwin64-x86_64/lib/libssl.a \
    -output $OUTPUT_PATH/libssl.a

echo "Creating the universal libraries for iOS Simulator"

OUTPUT_PATH=$ROOT_PATH/build/iossimulator
rm -rf $OUTPUT_PATH
mkdir -p $OUTPUT_PATH
lipo -create \
    $ROOT_PATH/build/openssl-iossimulator/lib/libcrypto.a \
    $ROOT_PATH/build/openssl-iossimulator-arm/lib/libcrypto.a \
    -output $OUTPUT_PATH/libcrypto.a
lipo -create \
    $ROOT_PATH/build/openssl-iossimulator/lib/libssl.a \
    $ROOT_PATH/build/openssl-iossimulator-arm/lib/libssl.a \
    -output $OUTPUT_PATH/libssl.a

echo "Creating the universal libraries for Catalyst"

OUTPUT_PATH=$ROOT_PATH/build/catalyst
rm -rf $OUTPUT_PATH
mkdir -p $OUTPUT_PATH
lipo -create \
    $ROOT_PATH/build/openssl-catalyst/lib/libcrypto.a \
    $ROOT_PATH/build/openssl-catalyst-arm/lib/libcrypto.a \
    -output $OUTPUT_PATH/libcrypto.a
lipo -create \
    $ROOT_PATH/build/openssl-catalyst/lib/libssl.a \
    $ROOT_PATH/build/openssl-catalyst-arm/lib/libssl.a \
    -output $OUTPUT_PATH/libssl.a

echo "Creating the OpenSSL XCFramework"

LIB_PATH=$ROOT_PATH/build
LIBCRYPTO_PATH=$LIB_PATH/libcrypto.xcframework
LIBSSL_PATH=$LIB_PATH/libssl.xcframework
rm -rf $LIBCRYPTO_PATH
rm -rf $LIBSSL_PATH
mkdir -p $LIB_PATH

xcodebuild -create-xcframework \
    -library $ROOT_PATH/build/macos/libcrypto.a \
    -library $ROOT_PATH/build/openssl-ios64/lib/libcrypto.a \
    -library $ROOT_PATH/build/iossimulator/libcrypto.a \
    -library $ROOT_PATH/build/catalyst/libcrypto.a \
    -output $LIBCRYPTO_PATH

xcodebuild -create-xcframework \
    -library $ROOT_PATH/build/macos/libssl.a \
    -headers $ROOT_PATH/build/darwin64-x86_64/include \
    -library $ROOT_PATH/build/openssl-ios64/lib/libssl.a \
    -headers $ROOT_PATH/build/openssl-ios64/include \
    -library $ROOT_PATH/build/iossimulator/libssl.a \
    -headers $ROOT_PATH/build/openssl-iossimulator/include \
    -library $ROOT_PATH/build/catalyst/libssl.a \
    -headers $ROOT_PATH/build/openssl-catalyst/include \
    -output $LIBSSL_PATH

pushd $LIB_PATH > /dev/null
zip -r libcrypto.zip libcrypto.xcframework
zip -r libssl.zip libssl.xcframework
popd > /dev/null

echo "Done; cleaning up"
rm -rf $TEMP_PATH
