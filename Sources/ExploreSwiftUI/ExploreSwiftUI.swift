// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import SwiftUI

// MARK: - OS Generation

/// Represents major iOS versions as an enum for clean conditional checks.
/// Use with `UniPlatformVersion.isAvailable` or `UniPlatformVersion.isAtLeast`.
///
/// Example:
/// ```swift
/// if UniPlatformVersion.isAtLeast(.v18) {
///     // Use iOS 18 APIs
/// }
/// ```
public enum UniOSGeneration: Int, CaseIterable, Sendable {
    case v15 = 15
    case v16 = 16
    case v17 = 17
    case v18 = 18
    case v26 = 26
    case v27 = 27
}

public enum UniPlatformVersion {
    public static var currentMajor: Int {
        ProcessInfo.processInfo.operatingSystemVersion.majorVersion
    }

    public static func isAtLeast(_ version: UniOSGeneration) -> Bool {
        currentMajor >= version.rawValue
    }

    /// Checks if the current operating system is at least the specified major version.
    ///
    /// Example:
    /// ```swift
    /// if UniPlatformVersion.isAvailable(iOS: 18, macOS: 15) {
    ///     // Modern layout logic
    /// }
    /// ```
    public static func isAvailable(
        iOS: Int? = nil,
        macOS: Int? = nil,
        tvOS: Int? = nil,
        watchOS: Int? = nil,
        visionOS: Int? = nil
    ) -> Bool {
        isAvailable(
            iOS: iOS.map { ($0, 0) },
            macOS: macOS.map { ($0, 0) },
            tvOS: tvOS.map { ($0, 0) },
            watchOS: watchOS.map { ($0, 0) },
            visionOS: visionOS.map { ($0, 0) }
        )
    }

    /// Checks if the current operating system is at least the specified major and minor version.
    ///
    /// Example:
    /// ```swift
    /// if UniPlatformVersion.isAvailable(iOS: (16, 4), macOS: (13, 3)) {
    ///     // Advanced sheet presentation
    /// }
    /// ```
    public static func isAvailable(
        iOS: (major: Int, minor: Int)? = nil,
        macOS: (major: Int, minor: Int)? = nil,
        tvOS: (major: Int, minor: Int)? = nil,
        watchOS: (major: Int, minor: Int)? = nil,
        visionOS: (major: Int, minor: Int)? = nil
    ) -> Bool {
        let systemVersion = ProcessInfo.processInfo.operatingSystemVersion
        let required: (major: Int, minor: Int)

        #if os(iOS)
            guard let val = iOS else { return false }
            required = val
        #elseif os(macOS)
            guard let val = macOS else { return false }
            required = val
        #elseif os(tvOS)
            guard let val = tvOS else { return false }
            required = val
        #elseif os(watchOS)
            guard let val = watchOS else { return false }
            required = val
        #elseif os(visionOS)
            guard let val = visionOS else { return false }
            required = val
        #else
            return false
        #endif

        if systemVersion.majorVersion > required.major { return true }
        if systemVersion.majorVersion == required.major {
            return systemVersion.minorVersion >= required.minor
        }
        return false
    }

    /// Runs a block of code only if the specified availability condition is true.
    public static func runIf(_ condition: Bool, action: () -> Void) {
        if condition {
            action()
        }
    }

    /// Runs a block of code conditionally, providing an optional fallback.
    @discardableResult
    public static func runIf<T>(
        _ condition: Bool,
        then action: () -> T,
        `else` fallback: () -> T
    ) -> T {
        if condition {
            return action()
        } else {
            return fallback()
        }
    }

    public static var supportsWWDC25Design: Bool {
        isAvailable(iOS: 26, macOS: 26, tvOS: 26, watchOS: 26, visionOS: 26)
    }

    public static var supportsWWDC26Design: Bool {
        isAvailable(iOS: 27, macOS: 27, tvOS: 27, watchOS: 27, visionOS: 27)
    }

    public static var supportsTabContentAPI: Bool {
        isAvailable(iOS: 18, macOS: 15, tvOS: 18, watchOS: 11, visionOS: 2)
    }

    public static var supportsAdaptableTabCustomization: Bool {
        isAvailable(iOS: 18, macOS: 15, tvOS: 18, watchOS: 11, visionOS: 2)
    }

    public static var supportsAdvancedSheetPresentation: Bool {
        isAvailable(iOS: (16, 4), macOS: (13, 3), tvOS: (16, 4), watchOS: (9, 4), visionOS: (1, 0))
    }

    public static var supportsAdvancedListAPI: Bool {
        isAvailable(iOS: 17, macOS: 14, tvOS: 17, watchOS: 10, visionOS: 1)
    }

    public static var supportsAdvancedPickerAPI: Bool {
        isAvailable(iOS: 17, macOS: 14, tvOS: 17, watchOS: 7, visionOS: 1)
    }
}

// MARK: - SwiftUI Conditional Extensions

@available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
extension View {
    /// Conditionally applies a modifier to a view.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .if(UniPlatformVersion.supportsAdvancedSheetPresentation) { view in
    ///         view.presentationDetents([.medium, .large])
    ///     }
    /// ```
    @ViewBuilder
    public func `if`<Content: View>(
        _ condition: Bool,
        @ViewBuilder transform: (Self) -> Content
    ) -> some View {
        if condition {
            transform(self)
        } else {
            self
        }
    }

    /// Conditionally applies one of two modifiers to a view based on a condition.
    ///
    /// Example:
    /// ```swift
    /// Text("Status")
    ///     .if(
    ///         UniPlatformVersion.supportsTabContentAPI,
    ///         then: { $0.foregroundStyle(.blue) },
    ///         else: { $0.foregroundColor(.blue) }
    ///     )
    /// ```
    @ViewBuilder
    public func `if`<TrueContent: View, FalseContent: View>(
        _ condition: Bool,
        @ViewBuilder then trueTransform: (Self) -> TrueContent,
        @ViewBuilder `else` falseTransform: (Self) -> FalseContent
    ) -> some View {
        if condition {
            trueTransform(self)
        } else {
            falseTransform(self)
        }
    }
}
