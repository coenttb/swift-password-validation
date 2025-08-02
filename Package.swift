// swift-tools-version:5.10

import PackageDescription

extension String {
    static let passwordValidation: Self = "PasswordValidation"
}

extension Target.Dependency {
    static var passwordValidation: Self { .target(name: .passwordValidation) }
}

extension Target.Dependency {
    static var translating: Self { .product(name: "Translating", package: "swift-translating") }
}

let package = Package(
    name: "swift-password-validation",
    platforms: [
        .iOS(.v16),
        .macOS(.v13),
        .macCatalyst(.v16),
        .tvOS(.v16),
        .watchOS(.v9)
    ],
    products: [
        .library(name: .passwordValidation, targets: [.passwordValidation]),
    ],
    dependencies: [
        .package(url: "https://github.com/coenttb/swift-translating", from: "0.0.1"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.9.2"),
    ],
    targets: [
        .target(
            name: .passwordValidation,
            dependencies: [
                .translating
            ]
        ),
        .testTarget(
            name: .passwordValidation.tests,
            dependencies: [
                .passwordValidation,
            ]
        ),
    ]
)

extension String { var tests: Self { self + " Tests" } }
