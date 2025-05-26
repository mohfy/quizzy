// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Quizzy",
    platforms: [
        .macOS(.v13)
    ],
    dependencies: [
        .package(url: "https://git.aparoksha.dev/aparoksha/adwaita-swift", branch: "main")
    ],
    targets: [
        .executableTarget(
            name: "Quizzy",
            dependencies: [
                .product(name: "Adwaita", package: "adwaita-swift")
            ]
        )
    ],
    swiftLanguageModes: [.v5]
)
