// swift-tools-version: 5.7

// Copyright 2022 Michael F. Collins, III
//
// Permission is hereby granted, free of charge, to any person obtaining a
// copy of this software and associated documentation files (the "Software"),
// to deal in the Software without restrictions, including without limitation
// the rights to use, copy, modify, merge, publish, distribute, sublicense,
// and/or sell copies of the Software, and to permit persons to whom the
// Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING
// FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER
// DEALINGS IN THE SOFTWARE.

import PackageDescription

let package = Package(
    name: "OpenSSL",
	platforms: [
		.iOS(.v11),
		.macOS(.v10_13)
	],
    products: [
        .library(
            name: "OpenSSL",
            targets: ["OpenSSL"]
        ),
    ],
    targets: [
        .target(
            name: "OpenSSL",
            dependencies: [
                "COpenSSL",
                "libcrypto",
                "libssl"
            ]
        ),
        .target(
            name: "COpenSSL",
            publicHeadersPath: "./"
        ),
        .binaryTarget(
            name: "libcrypto",
			url: "https://github.com/mfcollins3/openssl-apple/releases/download/0.1.0/libcrypto.zip",
			checksum: "29d19c355954188dcbf762423996ac9b35da857e5a9d5ba190ef6179fc78971d"
        ),
        .binaryTarget(
            name: "libssl",
			url: "https://github.com/mfcollins3/openssl-apple/releases/download/0.1.0/libssl.zip",
			checksum: "f545d1fc66aa4400c7ae22ef394ef81ad46ded0ec017d56b0a0b4e4ab3d135d1"
        )
    ]
)
