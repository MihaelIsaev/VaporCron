// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "VaporCron",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "VaporCron", targets: ["VaporCron"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
        // ⌚️Swift cron scheduler based on NIO
        .package(url: "https://github.com/MihaelIsaev/NIOCronScheduler.git", from:"2.0.0"),
    ],
    targets: [
        .target(name: "VaporCron", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "NIOCronScheduler", package: "NIOCronScheduler"),
        ]),
        .testTarget(name: "VaporCronTests", dependencies: [
            .target(name: "VaporCron")
        ]),
    ]
)
