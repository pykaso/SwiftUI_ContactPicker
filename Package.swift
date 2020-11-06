// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftUIContactPicker",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(
            name: "SwiftUIContactPicker",
            targets: ["SwiftUIContactPicker"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "SwiftUIContactPicker",
            dependencies: [],
            path: "SwiftUIContactPicker",
            exclude: ["Tests", "SwiftUIContactPickerExample"],
            resources: [.process("Resources")]
        ),
        // .testTarget(
        //     name: "SwiftUIContactPickerTests",
        //     dependencies: ["SwiftUIContactPicker"],
        //     path: "SwiftUIContactPicker"
        //     ),
    ]
)
