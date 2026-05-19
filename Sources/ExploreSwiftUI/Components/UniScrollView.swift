import SwiftUI

/// An uni scroll view component that wraps the native SwiftUI ScrollView.
///
/// `UniScrollView` provides a consistent scrollable container across all platforms.
/// It is designed to be used with uni scroll modifiers, such as `uniScrollEdgeEffect`,
/// to provide advanced visual feedback at the boundaries of the scrollable content.
///
/// Example:
/// ```swift
/// UniScrollView(.vertical, showsIndicators: false) {
///     VStack {
///         ForEach(0..<50) { i in
///             Text("Item \(i)")
///         }
///     }
/// }
/// ```
public struct UniScrollView<Content: View> {
    private let axes: Axis.Set
    private let showsIndicators: Bool
    private let content: () -> Content

    /// Creates an uni scroll view.
    ///
    /// - Parameters:
    ///   - axes: The scrollable axes. Defaults to `.vertical`.
    ///   - showsIndicators: A Boolean value that indicates whether the scroll view
    ///     displays the scrollable component's margin indicators. Defaults to `true`.
    ///   - content: A view builder describing the scrollable content.
    public init(
        _ axes: Axis.Set = .vertical,
        showsIndicators: Bool = true,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.axes = axes
        self.showsIndicators = showsIndicators
        self.content = content
    }
}

extension UniScrollView: View {
    public var body: some View {
        ScrollView(axes, showsIndicators: showsIndicators) {
            content()
        }
    }
}
