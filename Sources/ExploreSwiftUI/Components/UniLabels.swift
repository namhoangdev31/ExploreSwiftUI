import SwiftUI

/// An uni label component that provides platform-agnostic icon and title rendering.
///
/// `UniLabel` handles the transition between iOS 13 and modern OS versions:
/// - **Modern OS (iOS 14+)**: Leverages the native `Label` component.
/// - **Legacy Fallback (iOS 13)**: Polyfills using an `HStack` with standardized spacing
///   to ensure visual parity.
///
/// Example:
/// ```swift
/// UniLabel("Profile", systemImage: "person.circle")
///     .uniLabelStyle(.titleAndIcon)
/// ```
public struct UniLabel<Title: View, Icon: View>: View {
    let title: Title
    let icon: Icon

    @Environment(\.uniLabelStyle) private var style: UniLabelStyleType

    /// Creates an uni label with custom title and icon views.
    public init(@ViewBuilder title: () -> Title, @ViewBuilder icon: () -> Icon) {
        self.title = title()
        self.icon = icon()
    }

    public var body: some View {
        if #available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, visionOS 1.0, *) {
            Label(title: { title }, icon: { icon })
                .applyNativeLabelStyle(style)
        } else {
            fallback
        }
    }

    @ViewBuilder
    private var fallback: some View {
        switch style {
        case .iconOnly:
            icon
        case .titleOnly:
            title
        case .titleAndIcon, .automatic:
            HStack(spacing: 8) {
                icon
                title
            }
        }
    }
}

extension UniLabel where Title == Text, Icon == Image {
    /// Creates an uni label using a localized title key and a system image name.
    public init(_ titleKey: LocalizedStringKey, systemImage: String) {
        self.init(title: { Text(titleKey) }, icon: { Image(systemName: systemImage) })
    }

    /// Creates an uni label using a localized title key and a custom image name.
    public init(_ titleKey: LocalizedStringKey, image: String) {
        self.init(title: { Text(titleKey) }, icon: { Image(image) })
    }
}

extension UniLabel where Title == Text, Icon == Image {
    /// Creates an uni label using a title string and a system image name.
    public init<S: StringProtocol>(_ title: S, systemImage: String) {
        self.init(title: { Text(title) }, icon: { Image(systemName: systemImage) })
    }

    /// Creates an uni label using a title string and a custom image name.
    public init<S: StringProtocol>(_ title: S, image: String) {
        self.init(title: { Text(title) }, icon: { Image(image) })
    }
}

// MARK: - Environment & Modifier

private struct UniLabelStyleKey: EnvironmentKey {
    static let defaultValue: UniLabelStyleType = .automatic
}

extension EnvironmentValues {
    /// The current uni label style in the environment.
    public var uniLabelStyle: UniLabelStyleType {
        get { self[UniLabelStyleKey.self] }
        set { self[UniLabelStyleKey.self] = newValue }
    }
}

extension View {
    /// Sets the uni label style for this view and its subviews.
    ///
    /// This modifier works with both `UniLabel` and the native SwiftUI `Label`.
    ///
    /// Example:
    /// ```swift
    /// MyView()
    ///     .uniLabelStyle(.iconOnly)
    /// ```
    @ViewBuilder
    public func uniLabelStyle(_ style: UniLabelStyleType) -> some View {
        if #available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, visionOS 1.0, *) {
            self.environment(\.uniLabelStyle, style)
                .applyNativeLabelStyle(style)
        } else {
            self.environment(\.uniLabelStyle, style)
        }
    }
}

@available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, visionOS 1.0, *)
extension View {
    @ViewBuilder
    fileprivate func applyNativeLabelStyle(_ style: UniLabelStyleType) -> some View {
        switch style {
        case .iconOnly:
            self.labelStyle(.iconOnly)
        case .titleOnly:
            self.labelStyle(.titleOnly)
        case .titleAndIcon:
            self.labelStyle(.titleAndIcon)
        case .automatic:
            self.labelStyle(.automatic)
        }
    }
}
