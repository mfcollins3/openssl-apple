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
			url: "https://github.com/mfcollins3/openssl-apple/releases/download/0.2.0/libcrypto.zip",
			checksum: "ca7b824a98f7ec36653452dff53e1ee967cae8e8e821147fff38968fd3cc67ff"
        ),
        .binaryTarget(
            name: "libssl",
			url: "https://github.com/mfcollins3/openssl-apple/releases/download/0.2.0/libssl.zip",
			checksum: "d8bfad9f31906b79485920d99ed035b53fe139c931b8945df9b890807a4e200e"
        )
    ]
)
