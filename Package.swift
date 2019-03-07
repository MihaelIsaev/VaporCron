// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "VaporCron",
    products: [
        .library(name: "VaporCron", targets: ["VaporCron"]),
    ],
    dependencies: [
        // 💧 A server-side Swift web framework.
        .package(url: "https://github.com/vapor/vapor.git", from: "3.0.0"),
        // ⌚️Swift cron scheduler based on NIO
        .package(url: "https://github.com/MihaelIsaev/NIOCronScheduler.git", from:"1.1.0"),
    ],
    targets: [
        .target(name: "VaporCron", dependencies: ["Vapor", "NIOCronScheduler"]),
        .testTarget(name: "VaporCronTests", dependencies: ["VaporCron"]),
    ]
)
