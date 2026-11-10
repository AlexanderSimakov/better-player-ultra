// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "better_player",
    platforms: [
        // GCDWebServer and HLSCachingReverseProxyServer need iOS 13.
        .iOS("13.0")
    ],
    products: [
        // If the plugin name contains "_", the library name must use "-".
        .library(name: "better-player", targets: ["better_player"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        // The same libraries as the podspec, which pins only Cache. The other
        // lower bounds are the versions CocoaPods resolves (PINCache 3.0.4,
        // GCDWebServer 3.5.4). GCDWebServer comes from yene's repository,
        // which keeps the 3.5.x code and adds a Swift package. The HLS proxy's
        // own Package.swift only declares these dependencies in the
        // AlexanderSimakov fork.
        .package(url: "https://github.com/hyperoslo/Cache.git", .upToNextMinor(from: "6.0.0")),
        .package(url: "https://github.com/yene/GCDWebServer.git", .upToNextMajor(from: "3.5.7")),
        .package(url: "https://github.com/pinterest/PINCache.git", .upToNextMajor(from: "3.0.4")),
        .package(
            url: "https://github.com/AlexanderSimakov/HLSCachingReverseProxyServer.git",
            revision: "f871b1a7b28be9e20ad53726955aff2b741b1abf"
        )
    ],
    targets: [
        // SPM can't mix Objective-C and Swift in one target, so the Swift
        // caching code is its own module, which the Objective-C player imports.
        .target(
            name: "better_player",
            dependencies: [
                "better_player_cache",
                .product(name: "FlutterFramework", package: "FlutterFramework")
            ],
            cSettings: [
                .headerSearchPath("include/better_player")
            ]
        ),
        .target(
            name: "better_player_cache",
            dependencies: [
                .product(name: "Cache", package: "Cache"),
                .product(name: "GCDWebServer", package: "GCDWebServer"),
                .product(name: "PINCache", package: "PINCache"),
                .product(name: "HLSCachingReverseProxyServer", package: "HLSCachingReverseProxyServer")
            ]
        )
    ]
)
