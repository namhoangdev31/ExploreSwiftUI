import SwiftUI

extension View {

    /// Sets the color of an uni divider.
    ///
    /// This modifier uses an overlay to apply a custom color to the divider component.
    ///
    /// Example:
    /// ```swift
    /// UniDivider()
    ///     .uniDividerColor(.red)
    /// ```
    @ViewBuilder
    public func uniDividerColor(_ color: Color) -> some View {
        self.overlay(color)
    }

    /// Sets the thickness of an uni divider based on its orientation.
    ///
    /// Example:
    /// ```swift
    /// UniDivider()
    ///     .uniDividerThickness(2, axis: .horizontal)
    /// ```
    @ViewBuilder
    public func uniDividerThickness(_ thickness: CGFloat, axis: Axis = .horizontal)
        -> some View
    {
        if axis == .horizontal {
            self.frame(height: thickness)
        } else {
            self.frame(width: thickness)
        }
    }
}
