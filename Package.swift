// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "be-utils-swift",
  platforms: [
    .macOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "VaporUtils",
      targets: ["VaporUtils"]
    ),
    .library(
      name: "Utils",
      targets: ["Utils"]
    ),
    .library(
      name: "DynamoUtils",
      targets: ["DynamoUtils"]
    )
  ],
  dependencies: [
    .package(url: "https://github.com/vapor/vapor.git", .upToNextMajor(from: "4.0.0")),
    .package(url: "https://github.com/vapor/jwt.git", .upToNextMajor(from: "5.0.0")),
    .package(url: "https://github.com/awslabs/aws-sdk-swift", .upToNextMajor(from: "1.0.0")),
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    .target(
      name: "VaporUtils",
      dependencies: [
        .product(name: "Vapor", package: "vapor"),
        .product(name: "JWT", package: "jwt"),
        "Utils",
      ]
    ),
    .testTarget(
      name: "SharedBackendTests",
      dependencies: ["VaporUtils"]
    ),
    .target(
      name: "Utils"
    ),
    .target(
      name: "DynamoUtils",
      dependencies: [
        .product(name: "AWSDynamoDB", package: "aws-sdk-swift")
      ]
    ),
  ]
)
