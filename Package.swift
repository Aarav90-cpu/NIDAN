// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "NIDAN",
    platforms: [
        .macOS(.v13)
    ],
    products: [
        .library(name: "NidanModels", targets: ["NidanModels"]),
        .library(name: "NidanCore", targets: ["NidanCore"]),
        .library(name: "NidanLearning", targets: ["NidanLearning"]),
        .library(name: "NidanAssessment", targets: ["NidanAssessment"]),
        .library(name: "NidanAssignments", targets: ["NidanAssignments"]),
        .library(name: "NidanStorage", targets: ["NidanStorage"]),
        .library(name: "NidanSync", targets: ["NidanSync"]),
        .library(name: "NidanNetworking", targets: ["NidanNetworking"]),
        .executable(name: "NidanApp", targets: ["NidanApp"]),
        .executable(name: "NidanContentServer", targets: ["NidanContentServer"])
    ],
    dependencies: [
        // Robust SQLite wrapper
        .package(url: "https://github.com/groue/GRDB.swift.git", "7.0.0" ..< "7.11.0"),
        // Vapor for local web server backend
        .package(url: "https://github.com/vapor/vapor.git", from: "4.89.0")
    ],
    targets: [
        // Domain Models
        .target(name: "NidanModels", path: "Packages/NidanModels/Sources"),
        
        // Core Business Logic
        .target(name: "NidanCore", dependencies: ["NidanModels"], path: "Packages/NidanCore/Sources"),
        
        // Feature Modules
        .target(name: "NidanLearning", dependencies: ["NidanModels", "NidanCore"], path: "Packages/NidanLearning/Sources"),
        .target(name: "NidanAssessment", dependencies: ["NidanModels", "NidanCore"], path: "Packages/NidanAssessment/Sources"),
        .target(name: "NidanAssignments", dependencies: ["NidanModels", "NidanCore"], path: "Packages/NidanAssignments/Sources"),
        
        // Infrastructure
        .target(name: "NidanStorage", dependencies: [
            "NidanModels", 
            "NidanCore",
            .product(name: "GRDB", package: "GRDB.swift")
        ], path: "Packages/NidanStorage/Sources"),
        .target(name: "NidanNetworking", dependencies: ["NidanModels", "NidanCore"], path: "Packages/NidanNetworking/Sources"),
        .target(name: "NidanSync", dependencies: ["NidanModels", "NidanCore", "NidanNetworking", "NidanStorage"], path: "Packages/NidanSync/Sources"),
        
        // App Executable (Integration / Entry Point)
        .executableTarget(name: "NidanApp", dependencies: [
            "NidanCore", 
            "NidanModels", 
            "NidanStorage",
            .product(name: "Vapor", package: "vapor")
        ], path: "Packages/NidanApp/Sources"),
        .executableTarget(name: "NidanContentServer", dependencies: [
            .product(name: "Vapor", package: "vapor")
        ], path: "Packages/NidanContentServer/Sources"),
        .testTarget(name: "NidanStorageTests", dependencies: ["NidanStorage", "NidanModels"], path: "Packages/NidanStorage/Tests")
    ]
)
