# swift-github

[![CI](https://github.com/coenttb/swift-github/workflows/CI/badge.svg)](https://github.com/coenttb/swift-github/actions/workflows/ci.yml)
![Development Status](https://img.shields.io/badge/status-active--development-blue.svg)

Type-safe GitHub API client for Swift with dependency injection and modular architecture.

## Overview

`swift-github` provides a high-level interface to GitHub's REST API built on swift-dependencies for testability and maintainability.

## Features

- Type-safe API clients for traffic analytics, repositories, and stargazers
- Dependency injection via swift-dependencies for testable code
- Modular design with separate packages for different API domains
- Async/await support for modern Swift concurrency
- OAuth authentication support

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-github", from: "0.1.0")
]
```

## Quick Start

### Traffic Analytics

```swift
import GitHub
import Dependencies

@Dependency(\.github) var github

let views = try await github.client.traffic.views(
    owner: "coenttb",
    repo: "swift-github",
    per: .day
)

let clones = try await github.client.traffic.clones(
    owner: "coenttb",
    repo: "swift-github",
    per: nil
)

let paths = try await github.client.traffic.paths(
    owner: "coenttb",
    repo: "swift-github"
)

let referrers = try await github.client.traffic.referrers(
    owner: "coenttb",
    repo: "swift-github"
)
```

### Testing with Mocks

```swift
import Testing
import GitHub
import Dependencies

@Test
func testTrafficAnalytics() async throws {
    await withDependencies {
        $0.github.client.traffic.views = { _, _, _ in
            .init(count: 100, uniques: 50, views: [])
        }
    } operation: {
        @Dependency(\.github) var github
        let result = try await github.client.traffic.views("owner", "repo", .day)
        #expect(result.count == 100)
        #expect(result.uniques == 50)
    }
}
```

## Architecture

The package is organized into focused modules:

- **GitHub**: Main module combining all GitHub API functionality
- **GitHub Traffic**: Traffic analytics and metrics
- **GitHub Repositories**: Repository operations and metadata
- **GitHub Shared**: Common types and utilities shared across modules

Each module provides a dependency-injectable client for testability.

## Related Packages

- [swift-github-live](https://github.com/coenttb/swift-github-live): A Swift package with live implementations for the GitHub API.
- [swift-github-types](https://github.com/coenttb/swift-github-types): Type definitions for GitHub API responses and requests.
- [pointfreeco/swift-dependencies](https://github.com/pointfreeco/swift-dependencies): A dependency management library for controlling dependencies in Swift.

## Requirements

- Swift 6.0+
- macOS 14+ / iOS 17+

## License

This package is licensed under the AGPL 3.0 License. See [LICENSE.md](LICENSE.md) for details.

For commercial licensing options, please contact the maintainer.
