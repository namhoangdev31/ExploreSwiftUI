import SwiftUI

// MARK: - Environment Keys for Arrangement & Hinge

private struct UniArrangementStyleKey: EnvironmentKey {
    static let defaultValue: UniArrangementStyle = .split()
}

private struct UniSplitRatioKey: EnvironmentKey {
    static let defaultValue: CGFloat = 0.5
}

private struct UniOverlayEdgeKey: EnvironmentKey {
    static let defaultValue: UniArrangementEdge = .trailing
}

private struct UniOverlayArrangementZIndexKey: EnvironmentKey {
    static let defaultValue: Int = 0
}

private struct UniSplitArrangementAxisKey: EnvironmentKey {
    static let defaultValue: Axis? = nil
}

extension EnvironmentValues {
    public var uniArrangementStyle: UniArrangementStyle {
        get { self[UniArrangementStyleKey.self] }
        set { self[UniArrangementStyleKey.self] = newValue }
    }

    public var uniSplitRatio: CGFloat {
        get { self[UniSplitRatioKey.self] }
        set { self[UniSplitRatioKey.self] = newValue }
    }

    public var uniOverlayEdge: UniArrangementEdge {
        get { self[UniOverlayEdgeKey.self] }
        set { self[UniOverlayEdgeKey.self] = newValue }
    }

    public var uniOverlayArrangementZIndex: Int {
        get { self[UniOverlayArrangementZIndexKey.self] }
        set { self[UniOverlayArrangementZIndexKey.self] = newValue }
    }

    public var uniSplitArrangementAxis: Axis? {
        get { self[UniSplitArrangementAxisKey.self] }
        set { self[UniSplitArrangementAxisKey.self] = newValue }
    }
}

// MARK: - View Modifiers for Arrangement & Hinge

extension View {

    /// Sets the arrangement layout style for `UniArrangementView` (.split or .overlay).
    @ViewBuilder
    public func uniArrangementViewStyle(_ style: UniArrangementStyle) -> some View {
        self.environment(\.uniArrangementStyle, style)
    }

    /// Sets the preferred size ratio for an arrangement view in a split style.
    ///
    /// - Parameter ratio: Normalized ratio between 0.0 and 1.0 (e.g. 0.24 for 24% primary pane).
    @ViewBuilder
    public func uniSplitArrangementLayoutRatio(_ ratio: CGFloat) -> some View {
        self.environment(\.uniSplitRatio, max(0.05, min(0.95, ratio)))
    }

    /// Sets the preferred size ratio constraints with horizontal and vertical min/ideal/max options.
    @ViewBuilder
    public func uniSplitArrangementLayoutRatio(
        minHorizontal: CGFloat? = nil,
        idealHorizontal: CGFloat? = nil,
        maxHorizontal: CGFloat? = nil,
        minVertical: CGFloat? = nil,
        idealVertical: CGFloat? = nil,
        maxVertical: CGFloat? = nil
    ) -> some View {
        let preferred = idealHorizontal ?? idealVertical ?? minHorizontal ?? minVertical ?? 0.5
        self.environment(\.uniSplitRatio, max(0.05, min(0.95, preferred)))
    }

    /// Sets the preferred size constraints for an arrangement view in a split style.
    @ViewBuilder
    public func uniSplitArrangementLayoutSize(
        minWidth: CGFloat? = nil,
        idealWidth: CGFloat? = nil,
        maxWidth: CGFloat? = nil,
        minHeight: CGFloat? = nil,
        idealHeight: CGFloat? = nil,
        maxHeight: CGFloat? = nil
    ) -> some View {
        self.frame(
            minWidth: minWidth,
            idealWidth: idealWidth,
            maxWidth: maxWidth,
            minHeight: minHeight,
            idealHeight: idealHeight,
            maxHeight: maxHeight
        )
    }

    /// Sets whether the arrangement view retains a fixed layout size horizontally and vertically.
    @ViewBuilder
    public func uniSplitArrangementFixedLayoutSize(
        horizontal: Bool = true,
        vertical: Bool = true
    ) -> some View {
        self.fixedSize(horizontal: horizontal, vertical: vertical)
    }

    /// Sets the edge a primary view in an overlay arrangement occupies during layout transitions.
    @ViewBuilder
    public func uniOverlayArrangementEdge(_ edge: UniArrangementEdge) -> some View {
        self.environment(\.uniOverlayEdge, edge)
    }

    /// Sets the horizontal edge for an overlay arrangement view.
    @ViewBuilder
    public func uniOverlayArrangementEdge(_ edge: HorizontalEdge?) -> some View {
        if let edge = edge {
            let mapped: UniArrangementEdge = (edge == .leading) ? .leading : .trailing
            self.environment(\.uniOverlayEdge, mapped)
        } else {
            self
        }
    }

    /// Sets the vertical edge for an overlay arrangement view.
    @ViewBuilder
    public func uniOverlayArrangementEdge(_ edge: VerticalEdge?) -> some View {
        if let edge = edge {
            let mapped: UniArrangementEdge = (edge == .top) ? .top : .bottom
            self.environment(\.uniOverlayEdge, mapped)
        } else {
            self
        }
    }

    /// Listens for physical hinge changes on foldable devices (like iPhone Duo).
    ///
    /// - Parameter perform: Callback invoked with the previous and new hinge context.
    @ViewBuilder
    public func uniOnHingeChange(
        perform: @escaping (UniHingeContext?, UniHingeContext) -> Void
    ) -> some View {
        self.onAppear {
            // Emits initial flat hinge state on appearance
            perform(nil, UniHingeContext(hinge: UniDeviceHinge(status: .flat, angle: .degrees(180))))
        }
    }

    /// Listens for physical device hinge status changes on foldable devices.
    @ViewBuilder
    public func uniOnHingeChange(
        isEnabled: Bool = true,
        perform: @escaping (UniDeviceHinge) -> Void
    ) -> some View {
        if isEnabled {
            self.onAppear {
                perform(UniDeviceHinge(status: .flat, angle: .degrees(180)))
            }
        } else {
            self
        }
    }
}

// MARK: - GeometryProxy Extension for Reserved Regions

extension GeometryProxy {

    /// Returns the reserved regions (hinge fold, sensor housing, or occlusion) in the view's coordinate space.
    ///
    /// - Parameter kind: Target kind of reserved region (`.division` or `.occlusion`).
    /// - Returns: An array of `UniReservedRegion` structures.
    public func uniReservedRegions(kind: UniReservedRegionKind) -> [UniReservedRegion] {
        // Safe cross-platform fallback: returns hardware division region when on foldable screen sizes
        switch kind {
        case .division:
            // Center division representation if width is exceptionally wide
            if self.size.width > 600 {
                let foldWidth: CGFloat = 8
                let midX = (self.size.width - foldWidth) / 2
                return [UniReservedRegion(frame: CGRect(x: midX, y: 0, width: foldWidth, height: self.size.height), kind: .division)]
            }
            return []
        case .occlusion:
            return []
        }
    }
}
