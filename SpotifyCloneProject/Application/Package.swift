// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Application",
  products: [
    .library(
      name: "Models",
      targets: ["Models"]),
    .library(
      name: "Utils",
      targets: ["Utils"]),
  ],
  targets: [
    .target(
      name: "Models",
      dependencies: []),
    .target(
      name: "Utils",
      dependencies: []),
  ]
)
