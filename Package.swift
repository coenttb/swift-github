// swift-tools-version:6.0

import Foundation
import PackageDescription

extension String {
    static let github: Self = "GitHub"
    static let githubTraffic: Self = "GitHub Traffic"
    static let githubRepositories: Self = "GitHub Repositories"
    static let githubShared: Self = "GitHub Shared"
}

extension Target.Dependency {
    static var github: Self { .target(name: .github) }
    static var githubTraffic: Self { .target(name: .githubTraffic) }
    static var githubRepositories: Self { .target(name: .githubRepositories) }
    static var githubShared: Self { .target(name: .githubShared) }
}

extension Target.Dependency {
    static var githubLive: Self { .product(name: "GitHub Live", package: "swift-github-live") }
    static var githubTrafficLive: Self { .product(name: "GitHub Traffic Live", package: "swift-github-live") }
    static var githubRepositoriesLive: Self { .product(name: "GitHub Repositories Live", package: "swift-github-live") }
    static var githubLiveShared: Self { .product(name: "GitHub Live Shared", package: "swift-github-live") }
    
    static var dependenciesMacros: Self { .product(name: "DependenciesMacros", package: "swift-dependencies") }
}

let package = Package(
    name: "swift-github",
    platforms: [
        .macOS(.v14),
        .iOS(.v17)
    ],
    products: [
        .library(name: .github, targets: [.github]),
        .library(name: .githubTraffic, targets: [.githubTraffic]),
        .library(name: .githubRepositories, targets: [.githubRepositories]),
        .library(name: .githubShared, targets: [.githubShared])
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-github-live", from: "0.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.6.0"),
    ],
    targets: [
        .target(
            name: .githubShared,
            dependencies: [
                .githubLiveShared,
                .dependenciesMacros
            ]
        ),
        .target(
            name: .github,
            dependencies: [
                .githubShared,
                .githubLive,
                .githubTraffic,
                .githubRepositories,
                .dependenciesMacros,
            ]
        ),
        .target(
            name: .githubTraffic,
            dependencies: [
                .githubShared,
                .githubTrafficLive,
                .dependenciesMacros
            ]
        ),
        .target(
            name: .githubRepositories,
            dependencies: [
                .githubShared,
                .githubRepositoriesLive,
                .dependenciesMacros
            ]
        ),
        .testTarget(
            name: .github + " Tests",
            dependencies: [
                .github
            ]
        ),
        .testTarget(
            name: "GitHub Traffic Tests",
            dependencies: [.githubTraffic]
        ),
        .testTarget(
            name: "GitHub Repositories Tests",
            dependencies: [.githubRepositories]
        )
    ],
    swiftLanguageModes: [.v6]
)
