import SwiftUI

/// A custom environment key to propagate `UniControlGroupStyle` through the view hierarchy.
struct UniControlGroupStyleKey: EnvironmentKey {
    static let defaultValue: UniControlGroupStyle = .automatic
}

extension EnvironmentValues {
    /// Accessor for the uni control group style in the environment.
    public var uniControlGroupStyle: UniControlGroupStyle {
        get { self[UniControlGroupStyleKey.self] }
        set { self[UniControlGroupStyleKey.self] = newValue }
    }
}

extension View {
    /// Applies a style to all `ControlGroup` and `UniControlGroup` components within this view.
    ///
    /// This modifier handles cross-platform styling for control groups:
    /// - **iOS 15+ / macOS 12+**: Maps to native `.controlGroupStyle()` for standard components.
    /// - **Legacy/Fallback**: Saves the style to the environment, allowing `UniControlGroup`
    ///   to replicate the visual style using alternative layouts (like `HStack` or `Menu`) on older OS versions.
    ///
    /// - Parameter style: The uni style to apply (e.g., `.navigation`, `.menu`, `.palette`).
    ///
    /// Example:
    /// ```swift
    /// UniControlGroup {
    ///     Button("Edit") { }
    ///     Button("Delete") { }
    /// }
    /// .uniControlGroupStyle(.menu)
    /// ```
    @ViewBuilder
    public func uniControlGroupStyle(_ style: UniControlGroupStyle) -> some View {
        let styled = self.environment(\.uniControlGroupStyle, style)

        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
            if #available(iOS 15.0, macOS 12.0, tvOS 17.0, visionOS 1.0, *) {
                #if !os(watchOS)
                    switch style {
                    case .automatic:
                        styled.controlGroupStyle(.automatic)
                    case .palette:
                        if #available(iOS 17.0, macOS 14.0, *) {
                            styled.controlGroupStyle(.palette)
                        } else {
                            styled
                        }
                    case .navigation:
                        styled.controlGroupStyle(.navigation)
                    case .menu:
                        if #available(iOS 16.4, macOS 13.3, tvOS 17.0, *) {
                            styled.controlGroupStyle(.menu)
                        } else {
                            styled
                        }
                    case .compactMenu:
                        if #available(iOS 16.4, macOS 13.3, *) {
                            styled.controlGroupStyle(.compactMenu)
                        } else {
                            styled
                        }
                    }
                #else
                    styled
                #endif
            } else {
                styled
            }
        #else
            styled
        #endif
    }
}
