// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Features",
  platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v2)],
  products: products,
  dependencies: externalDependencies,
  targets: targets,
  swiftLanguageModes: [.v6]
)

// MARK: - Modules

enum Module: String, CaseIterable {
  case AlarmFeature
  case AppFeature
}

// MARK: - External Dependencies

enum ExternalDependency: String {
  case ComposableArchitecture

  private var packageName: String {
    switch self {
    case .ComposableArchitecture:
      return "swift-composable-architecture"
    }
  }
}

// MARK: - Plugins

enum Plugin: String {
  case SwiftGenPlugin

  private var packageName: String {
    switch self {
    case .SwiftGenPlugin:
      return self.rawValue
    }
  }
}

// MARK: - Targets

private var targets: [Target] {
  [
    Target.module(
      module: .AlarmFeature,
      dependencies: [
        .external(.ComposableArchitecture),
      ]
    ),
    Target.module(
      module: .AppFeature,
      dependencies: [
        .module(.AlarmFeature),
      ]
    ),
  ].flatMap { $0 }
}


// MARK: - Helpers

private var products: [Product] {
  Module.allCases
    .map { .library(name: "\($0)", targets: ["\($0)"]) }
}

private var externalDependencies: [Package.Dependency] {
  [
    .package(url: "https://github.com/pointfreeco/swift-composable-architecture.git", from: "1.17.1"),
    .package(url: "https://github.com/SwiftGen/SwiftGenPlugin", from: "6.6.0"),
  ]
}

protocol TargetDependencyProvider {
  var targetDependency: Target.Dependency { get }
}

extension Module: TargetDependencyProvider {
  var name: String { self.rawValue }
  var targetDependency: Target.Dependency { .byName(name: self.rawValue) }
}

extension ExternalDependency: TargetDependencyProvider {
  var targetDependency: Target.Dependency {
    .product(name: self.rawValue, package: packageName)
  }
}

enum DependencyPackage {
  case module(Module)
  case external(ExternalDependency)
}

extension DependencyPackage: TargetDependencyProvider {
  var targetDependency: Target.Dependency {
    switch self {
    case let .module(module):     return module.targetDependency
    case let .external(external): return external.targetDependency
    }
  }
}

protocol PluginUsageProvider {
  var pluginUsage: Target.PluginUsage { get }
}

extension Plugin: PluginUsageProvider {
  var pluginUsage: Target.PluginUsage { .plugin(name: self.rawValue, package: self.packageName) }
}

extension Target {
  static func module(
    module: Module,
    dependencies: [DependencyPackage] = [],
    path: String? = nil,
    exclude: [String] = [],
    sources: [String]? = nil,
    resources: [Resource]? = nil,
    publicHeadersPath: String? = nil,
    packageAccess: Bool = true,
    cSettings: [CSetting]? = nil,
    cxxSettings: [CXXSetting]? = nil,
    swiftSettings: [SwiftSetting]? = nil,
    linkerSettings: [LinkerSetting]? = nil,
    plugins: [Plugin]? = nil,
    addTestTarget: Bool = false
  ) -> [Target] {
    var targets: [Target] = [
      .target(
        name: module.name,
        dependencies: dependencies.map(\.targetDependency),
        path: path,
        exclude: exclude,
        sources: sources,
        resources: resources,
        publicHeadersPath: publicHeadersPath,
        cSettings: cSettings,
        cxxSettings: cxxSettings,
        swiftSettings: swiftSettings,
        linkerSettings: linkerSettings,
        plugins: plugins?.map(\.pluginUsage)
      )
    ]

    if addTestTarget {
      targets.append(
        .testTarget(
          name: "\(module.name)Tests",
          dependencies: [.byName(name: module.name)]
        )
      )
    }

    return targets
  }
}
