import SwiftUI

#if canImport(StoreKit)
import StoreKit
#endif

/// Defines the unified styles for product views.
public enum UniProductViewStyle: Sendable {
    case automatic
    case compact
    case regular
    case large
}

struct UniProductViewStyleKey: EnvironmentKey {
    static let defaultValue: UniProductViewStyle = .automatic
}

extension EnvironmentValues {
    /// The current style for uni product views.
    public var uniProductViewStyle: UniProductViewStyle {
        get { self[UniProductViewStyleKey.self] }
        set { self[UniProductViewStyleKey.self] = newValue }
    }
}

extension View {
    /// Sets the style for uni product views in this view's environment.
    ///
    /// Example:
    /// ```swift
    /// ContentView()
    ///     .uniProductViewStyle(.compact)
    /// ```
    public func uniProductViewStyle(_ style: UniProductViewStyle) -> some View {
        self.environment(\.uniProductViewStyle, style)
    }
}
