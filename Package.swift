// swift-tools-version:5.1

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
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-beta.3.1"),
        // ⌚️Swift cron scheduler based on NIO
        .package(url: "https://github.com/MihaelIsaev/NIOCronScheduler.git", from:"2.0.0"),
    ],
    targets: [
        .target(name: "VaporCron", dependencies: ["Vapor", "NIOCronScheduler"]),
        .testTarget(name: "VaporCronTests", dependencies: ["VaporCron"]),
    ]
)
