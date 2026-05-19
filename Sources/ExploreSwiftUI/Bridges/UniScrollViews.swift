import SwiftUI

extension View {

    /// Applies an uni scroll edge effect style to a scrollable view.
    ///
    /// This modifier allows you to customize the visual feedback when scrolling reaches the
    /// boundary of the content.
    ///
    /// - Parameters:
    ///   - style: The uni style to apply (currently supporting `.hard` for future iOS 26+).
    ///   - edges: The set of edges to apply the effect to. Default is `.all`.
    ///
    /// - Platforms Supported: iOS 26.0+, macOS 26.0+, watchOS 26.0+, tvOS 26.0+, visionOS 26.0+.
    /// - Fallback Behavior: On older OS versions, it gracefully preserves the default system
    ///   scroll edge effect (typically rubber-banding/bouncing) to maintain platform-specific UX.
    ///
    /// Example:
    /// ```swift
    /// ScrollView(.horizontal) {
    ///     HStack { ... }
    /// }
    /// .uniScrollEdgeEffectStyle(.hard, for: .horizontal)
    /// ```
    @ViewBuilder
    public func uniScrollEdgeEffectStyle(
        _ style: UniScrollEdgeEffectStyle, for edges: Edge.Set = .all
    ) -> some View {
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
            if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *) {
                switch style {
                case .hard:
                    self.scrollEdgeEffectStyle(.hard, for: edges)
                }
            } else {
                self
            }
        #else
            self
        #endif
    }
    // MARK: - Scroll Target Behavior
    
    /// Configures the scroll target behavior for a scrollable view.
    ///
    /// - **iOS 17+**: Native implementation using `.scrollTargetBehavior`.
    /// - **iOS 15-16**: Gracefully ignores the modifier.
    ///
    /// Example:
    /// ```swift
    /// ScrollView {
    ///     LazyVStack { ... }
    /// }
    /// .uniScrollTargetBehavior(.paging)
    /// ```
    @ViewBuilder
    public func uniScrollTargetBehavior(_ behavior: UniScrollTargetBehavior) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            switch behavior {
            case .paging:
                self.scrollTargetBehavior(.paging)
            case .viewAligned:
                self.scrollTargetBehavior(.viewAligned)
            }
        } else {
            self
        }
    }

    // MARK: - Scroll Position
    
    /// Binds the scroll position of a scrollable view to a specific ID.
    ///
    /// - **iOS 17+**: Native `.scrollPosition(id:anchor:)` for optimal performance and two-way binding.
    /// - **iOS 15-16**: Fallback using `ScrollViewReader` and `proxy.scrollTo(id)`. This provides programmatic scrolling *to* an ID, though it may not update the binding when manually scrolling.
    ///
    /// Example:
    /// ```swift
    /// @State private var scrollPosition: Int?
    ///
    /// ScrollView {
    ///     LazyVStack {
    ///         ForEach(0..<100, id: \.self) { i in
    ///             Text("Item \(i)").id(i)
    ///         }
    ///     }
    /// }
    /// .uniScrollPosition(id: $scrollPosition)
    ///
    /// Button("Go to 50") { scrollPosition = 50 }
    /// ```
    @ViewBuilder
    public func uniScrollPosition<ID: Hashable>(id: Binding<ID?>, anchor: UnitPoint? = nil) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            self.scrollPosition(id: id, anchor: anchor)
        } else {
            ScrollViewReader { proxy in
                self
                    .onChange(of: id.wrappedValue) { newValue in
                        if let newValue = newValue {
                            withAnimation {
                                proxy.scrollTo(newValue, anchor: anchor)
                            }
                        }
                    }
            }
        }
    }
}

/// A uni representation of SwiftUI's `ScrollTargetBehavior`.
public enum UniScrollTargetBehavior {
    /// A scroll behavior that aligns scrollable content to the bounds of the scroll view.
    case paging
    /// A scroll behavior that aligns scrollable content to view-based geometry.
    case viewAligned
}
