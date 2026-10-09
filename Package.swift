// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "NIDAN",
    platforms: [
        .macOS(.v13) // Allowing macOS for local development/testing flexibility
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
        .library(name: "NidanUI", targets: ["NidanUI"]),
    ],
    dependencies: [
        // SwiftCrossUI and Vapor will be added in subsequent phases.
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
        .target(name: "NidanStorage", dependencies: ["NidanModels", "NidanCore"], path: "Packages/NidanStorage/Sources"),
        .target(name: "NidanNetworking", dependencies: ["NidanModels", "NidanCore"], path: "Packages/NidanNetworking/Sources"),
        .target(name: "NidanSync", dependencies: ["NidanModels", "NidanCore", "NidanNetworking", "NidanStorage"], path: "Packages/NidanSync/Sources"),
        
        // UI Layer (Strict separation from Core)
        .target(name: "NidanUI", dependencies: ["NidanCore", "NidanLearning", "NidanAssessment", "NidanAssignments"], path: "Packages/NidanUI/Sources"),
    ]
)
