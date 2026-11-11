import SwiftUI

// MARK: - Environment Key for UniToggleStyle

private struct UniToggleStyleKey: EnvironmentKey {
    static let defaultValue: UniToggleStyle = .automatic
}

extension EnvironmentValues {
    public var uniToggleStyle: UniToggleStyle {
        get { self[UniToggleStyleKey.self] }
        set { self[UniToggleStyleKey.self] = newValue }
    }
}

// MARK: - View Extension

extension View {

    /// Sets the style for `UniToggle` instances or native `Toggle` views within this view hierarchy.
    ///
    /// - Parameter style: The target toggle style (`.automatic`, `.switch`, `.button`, `.checkbox`).
    ///
    /// Example:
    /// ```swift
    /// UniToggle("Mute Audio", isOn: $isMuted)
    ///     .uniToggleStyle(.button)
    /// ```
    @ViewBuilder
    public func uniToggleStyle(_ style: UniToggleStyle) -> some View {
        self
            .environment(\.uniToggleStyle, style)
            .modifier(UniNativeToggleStyleModifier(style: style))
    }
}

private struct UniNativeToggleStyleModifier: ViewModifier {
    let style: UniToggleStyle

    @ViewBuilder
    func body(content: Content) -> some View {
        switch style {
        case .automatic:
            content.toggleStyle(.automatic)
        case .switch:
            #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
                content.toggleStyle(.switch)
            #elseif os(tvOS)
                if #available(tvOS 18.0, *) {
                    content.toggleStyle(.switch)
                } else {
                    content
                }
            #else
                content
            #endif
        case .button:
            #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
                if #available(iOS 15.0, macOS 12.0, watchOS 9.0, visionOS 1.0, *) {
                    content.toggleStyle(.button)
                } else {
                    content
                }
            #else
                content
            #endif
        case .checkbox:
            #if os(macOS)
                content.toggleStyle(.checkbox)
            #else
                content
            #endif
        }
    }
}
