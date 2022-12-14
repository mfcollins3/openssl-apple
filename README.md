# OpenSSL Swift Package

## Overview

This repository implements a Swift Package that builds, includes, and wraps the [OpenSSL](https://www.openssl.org) libraries (`libcrypto` and `libssl`). I created this package because I have other frameworks that depend on OpenSSL and I wanted to break out the OpenSSL implementation in case anyone else had a need for using just OpenSSL. Over time, I plan to build a Swift API for some of the OpenSSL features to use them in my applications.

This Swift package supports the following platforms:

* macOS (Apple Silicone and Intel)
* iOS (64-bit only)
* iOS Simulator (Apple Silicone and Intel)
* macOS Catalyst (Apple Silicone and Intel)

:warning: Please note that in order to use this Swift package, you must also agree to the license terms for OpenSSL. OpenSSL is licensed under the Apache 2.0 license. Please see the license in the [OpenSSL GitHub repository](https://github.com/openssl/openssl/blob/openssl-3.0.7/LICENSE.txt).

## Building OpenSSL

If you need to build the OpenSSL libraries for use with other libraries that might depend on OpenSSL, I have provided the [build.sh](build.sh) script to automate the process. The source code for the supported version of OpenSSL is linked as a Git submodule. First, clone the repository in a terminal:

```sh
git clone https://github.com/mfcollins3/openssl-apple.git
cd openssl-apple.git
git submodule init
git submodule update
```

After cloning the repository and loading the OpenSSL source code, you can run the `build.sh` program without any arguments to build the OpenSSL library and to produce the XCFrameworks. The XCFrameworks are output to the `build` subdirectory that is generated by the `build.sh` program.
