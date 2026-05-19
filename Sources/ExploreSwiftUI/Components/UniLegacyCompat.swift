import SwiftUI

/// A view modifier that applies a standardized card appearance to a view.
///
/// `UniLegacyCardModifier` encapsulates the recommended styling for container
/// elements, ensuring they look like modern cards across all supported OS versions.
/// It internally uses `uniGlass` to apply a subtle glass effect and rounded corners.
///
/// Example:
/// ```swift
/// Text("Card Content")
///     .modifier(UniLegacyCardModifier(cornerRadius: 12))
/// ```
public struct UniLegacyCardModifier: ViewModifier {
    private let cornerRadius: CGFloat

    /// Creates a card modifier with a specific corner radius.
    ///
    /// - Parameter cornerRadius: The radius of the card's corners. Defaults to 20.
    public init(cornerRadius: CGFloat = 20) {
        self.cornerRadius = cornerRadius
    }

    public func body(content: Content) -> some View {
        content
            .uniGlass(cornerRadius: cornerRadius)
    }
}

extension View {
    /// Wraps the view in a standardized uni card style.
    ///
    /// This is a convenience method for applying the `UniLegacyCardModifier`.
    ///
    /// Example:
    /// ```swift
    /// VStack {
    ///     Text("Hello World")
    /// }
    /// .uniLegacyCard(cornerRadius: 15)
    /// ```
    ///
    /// - Parameter cornerRadius: The radius of the card's corners.
    public func uniLegacyCard(cornerRadius: CGFloat = 20) -> some View {
        modifier(UniLegacyCardModifier(cornerRadius: cornerRadius))
    }
}
