import SwiftUI

/// A highly uni button component that works across all Apple platforms and OS versions.
///
/// `UniButton` abstracts away the complexities of different `Button` APIs, automatically
/// handling button roles, styles, and sizing. It supports modern iOS 26+ roles while providing
/// intelligent fallbacks for older systems.
///
/// Example:
/// ```swift
/// UniButton("Delete Item", role: .destructive) {
///     deleteData()
/// }
/// .uniButtonStyle(.borderedProminent)
/// ```
public struct UniButton<Label: View>: View {
    private let role: UniButtonRole?
    private let style: UniButtonStyle
    private let sizing: UniButtonSizing
    private let tint: Color?
    private let borderShape: UniButtonBorderShape
    private let action: () -> Void
    private let label: () -> Label

    /// Creates an uni button with a custom label.
    ///
    /// - Parameters:
    ///   - role: The button's role (e.g., `.cancel`, `.destructive`).
    ///   - style: The visual style (e.g., `.bordered`, `.plain`).
    ///   - sizing: The button's sizing behavior.
    ///   - tint: An optional tint color.
    ///   - borderShape: The shape of the button's border.
    ///   - action: The action to perform when the button is tapped.
    ///   - label: A view builder that describes the button's content.
    public init(
        role: UniButtonRole? = nil,
        style: UniButtonStyle = .automatic,
        sizing: UniButtonSizing = .automatic,
        tint: Color? = nil,
        borderShape: UniButtonBorderShape = .automatic,
        action: @escaping () -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.role = role
        self.style = style
        self.sizing = sizing
        self.tint = tint
        self.borderShape = borderShape
        self.action = action
        self.label = label
    }

    /// Creates an uni button with a title key.
    ///
    /// Example:
    /// ```swift
    /// UniButton("Submit", action: submitForm)
    /// ```
    public init(
        _ titleKey: LocalizedStringKey,
        role: UniButtonRole? = nil,
        style: UniButtonStyle = .automatic,
        sizing: UniButtonSizing = .automatic,
        tint: Color? = nil,
        borderShape: UniButtonBorderShape = .automatic,
        action: @escaping () -> Void
    ) where Label == Text {
        self.init(
            role: role,
            style: style,
            sizing: sizing,
            tint: tint,
            borderShape: borderShape,
            action: action
        ) {
            Text(titleKey)
        }
    }

    /// Creates an uni button with a title and a system image.
    ///
    /// Example:
    /// ```swift
    /// UniButton("Settings", systemImage: "gear", action: showSettings)
    /// ```
    public init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        role: UniButtonRole? = nil,
        style: UniButtonStyle = .automatic,
        sizing: UniButtonSizing = .automatic,
        tint: Color? = nil,
        borderShape: UniButtonBorderShape = .automatic,
        action: @escaping () -> Void
    ) where Label == SwiftUI.Label<Text, Image> {
        self.init(
            role: role,
            style: style,
            sizing: sizing,
            tint: tint,
            borderShape: borderShape,
            action: action
        ) {
            SwiftUI.Label(titleKey, systemImage: systemImage)
        }
    }

    public var body: some View {
        Group {
            if let role {
                if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *) {
                    Button(role: modernRole(role), action: action) {
                        label()
                    }
                } else {
                    Button(role: role.fallbackButtonRole, action: action) {
                        label()
                    }
                }
            } else {
                Button(action: action) {
                    label()
                }
            }
        }
        .uniButtonStyle(style)
        .uniButtonSizing(sizing)
        .uniButtonTint(tint)
        .uniButtonBorderShape(borderShape)
    }

    @available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, visionOS 26.0, *)
    private func modernRole(_ role: UniButtonRole) -> ButtonRole {
        switch role {
        case .cancel:
            return .cancel
        case .close:
            return .close
        case .confirm:
            return .confirm
        case .destructive:
            return .destructive
        }
    }
}

// Extension to bridge UniButtonRole to native roles
extension UniButtonRole {
    fileprivate var fallbackButtonRole: ButtonRole? {
        switch self {
        case .cancel:
            return .cancel
        case .destructive:
            return .destructive
        case .close, .confirm:
            return nil
        }
    }
}
