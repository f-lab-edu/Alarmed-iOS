// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "Features",
  platforms: [.iOS(.v17), .macOS(.v14), .visionOS(.v2)],
  products: products,
  dependencies: externalDependencies,
  targets: targets,
  swiftLanguageModes: [.v6])

// MARK: - Module

enum Module: String, CaseIterable {
  case AlarmFeature
  case AppFeature
}

// MARK: - ExternalDependency

enum ExternalDependency: String {
  case ComposableArchitecture

  private var packageName: String {
    switch self {
    case .ComposableArchitecture:
      "swift-composable-architecture"
    }
  }
}

// MARK: - Plugin

enum Plugin: String {
  case AirbnbSwiftFormat
  case SwiftGenPlugin

  private var packageName: String {
    switch self {
    case .AirbnbSwiftFormat:
      "AirbnbSwift"
    case .SwiftGenPlugin:
      rawValue
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
      ]),
    Target.module(
      module: .AppFeature,
      dependencies: [
        .module(.AlarmFeature),
      ]),
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
    .package(url: "https://github.com/airbnb/swift", from: "1.0.0"),
  ]
}

// MARK: - TargetDependencyProvider

protocol TargetDependencyProvider {
  var targetDependency: Target.Dependency { get }
}

// MARK: - Module + TargetDependencyProvider

extension Module: TargetDependencyProvider {
  var name: String { rawValue }
  var targetDependency: Target.Dependency { .byName(name: rawValue) }
}

// MARK: - ExternalDependency + TargetDependencyProvider

extension ExternalDependency: TargetDependencyProvider {
  var targetDependency: Target.Dependency {
    .product(name: rawValue, package: packageName)
  }
}

// MARK: - DependencyPackage

enum DependencyPackage {
  case module(Module)
  case external(ExternalDependency)
}

// MARK: TargetDependencyProvider

extension DependencyPackage: TargetDependencyProvider {
  var targetDependency: Target.Dependency {
    switch self {
    case .module(let module): module.targetDependency
    case .external(let external): external.targetDependency
    }
  }
}

// MARK: - PluginUsageProvider

protocol PluginUsageProvider {
  var pluginUsage: Target.PluginUsage { get }
}

// MARK: - Plugin + PluginUsageProvider

extension Plugin: PluginUsageProvider {
  var pluginUsage: Target.PluginUsage { .plugin(name: rawValue, package: packageName) }
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
    packageAccess _: Bool = true,
    cSettings: [CSetting]? = nil,
    cxxSettings: [CXXSetting]? = nil,
    swiftSettings: [SwiftSetting]? = nil,
    linkerSettings: [LinkerSetting]? = nil,
    plugins: [Plugin]? = nil,
    addTestTarget: Bool = false)
    -> [Target]
  {
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
        plugins: plugins?.map(\.pluginUsage)),
    ]

    if addTestTarget {
      targets.append(
        .testTarget(
          name: "\(module.name)Tests",
          dependencies: [.byName(name: module.name)]))
    }

    return targets
  }
}
