// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Judo-Braze",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "Judo-Braze",
            targets: ["Judo-Braze"]),
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
        .package(name: "JudoSDK", url: "https://github.com/judoapp/judo-ios", from: "1.3.0"),
        .package(name: "Appboy_iOS_SDK", url: "https://github.com/braze-inc/braze-ios-sdk", from: "4.3.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "Judo-Braze",
            dependencies: [
                .product(name: "AppboyUI", package: "Appboy_iOS_SDK"),
                .product(name: "JudoSDK", package: "JudoSDK"),
            ]),
        .testTarget(
            name: "Judo-BrazeTests",
            dependencies: ["Judo-Braze"]),
    ]
)
