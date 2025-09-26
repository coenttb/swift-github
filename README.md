# swift-github

[![Swift](https://img.shields.io/badge/Swift-6.0-orange.svg)](https://swift.org)
[![License](https://img.shields.io/badge/License-AGPL%203.0-blue.svg)](LICENSE.md)
[![Version](https://img.shields.io/badge/version-0.1.0-green.svg)](https://github.com/coenttb/swift-github/releases)

A [not yet] complete, production-ready GitHub API client for Swift server applications.

## Overview

`swift-github` provides a high-level, dependency-injected interface to GitHub's REST API with:

- 🎯 **[not yet] Complete API Coverage**: Traffic, repositories, stargazers, and more
- 🔌 **Dependency Injection**: First-class support via swift-dependencies
- 🧪 **Testable**: Mock implementations for testing
- 📊 **Analytics Ready**: Built-in traffic and engagement metrics
- 🚀 **Production Ready**: Used in production at coenttb.com
- ⚡ **High Performance**: Async/await with efficient connection pooling
- 🔐 **Secure**: Multiple authentication methods supported

## Installation

Add to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/coenttb/swift-github", from: "0.1.0")
]
```

## Quick Start

### Fetching Repository Data

```swift
import GitHub
import Dependencies

struct MyService {
    @Dependency(\.github.client) var github
    
    func fetchRepositoryStats() async throws {
        // Get traffic data
        let traffic = try await github.traffic.views(
            owner: "coenttb",
            repo: "swift-github"
        )
        
        // Get repository info
        let repo = try await github.repositories.get(
            owner: "coenttb",
            repo: "swift-github"
        )
        
        // Get stargazers
        let stars = try await github.stargazers.list(
            owner: "coenttb",
            repo: "swift-github"
        )
    }
}
```

### Testing

```swift
import Testing
import GitHub
import Dependencies

@Test
func testGitHubIntegration() async throws {
    await withDependencies {
        $0.github.client.traffic.views = { _, _ in
            // Return mock traffic data
            .init(count: 100, uniques: 50, views: [])
        }
    } operation: {
        let service = MyService()
        try await service.fetchRepositoryStats()
        // Assert expected behavior
    }
}
```

## Features

### Traffic Analytics

Monitor repository engagement:

```swift
// Daily views
let dailyViews = try await github.traffic.views(
    owner: owner,
    repo: repo,
    per: .day
)

// Clone statistics
let clones = try await github.traffic.clones(
    owner: owner,
    repo: repo
)

// Popular content
let paths = try await github.traffic.popularPaths(
    owner: owner,
    repo: repo
)
```

### Repository Management

Access repository metadata and operations:

```swift
// Repository details
let repo = try await github.repositories.get(
    owner: owner,
    repo: name
)

// List repositories
let repos = try await github.repositories.list(
    user: username,
    type: .owner,
    sort: .updated
)
```

### Stargazers

Track repository popularity:

```swift
// Get stargazers with timestamps
let stargazers = try await github.stargazers.list(
    owner: owner,
    repo: repo,
    page: 1,
    perPage: 100
)

// Total star count
let count = try await github.stargazers.count(
    owner: owner,
    repo: repo
)
```

## Architecture

The package provides a clean separation of concerns:

- **GitHub**: High-level client with dependency injection
- **GitHubTraffic**: Traffic analytics module
- **GitHubRepositories**: Repository operations module
- **GitHubShared**: Shared utilities and types

### Dependency Structure

```
swift-github
├── swift-github-live (implementations)
│   └── swift-github-types (type definitions)
└── swift-dependencies (dependency injection)
```

## Production Use

This package powers GitHub integrations at:

- [coenttb.com](https://coenttb.com) - Repository statistics dashboard
- Traffic analytics and monitoring
- Automated reporting systems

## Related Packages

- [swift-github-types](https://github.com/coenttb/swift-github-types): Core types (Apache 2.0)
- [swift-github-live](https://github.com/coenttb/swift-github-live): Live implementations
- [coenttb-com-server](https://github.com/coenttb/coenttb-com-server): Production example

## Requirements

- Swift 6.0+
- macOS 14+ / iOS 17+ / Linux

## License

This package is licensed under the AGPL 3.0 License. See [LICENSE.md](LICENSE.md) for details.

For commercial licensing options, please contact the maintainer.

## Support

For issues, questions, or contributions, please visit the [GitHub repository](https://github.com/coenttb/swift-github).
