import SwiftUI

// MARK: - Foldable & Dual-Screen Primitives

/// Encapsulates the physical state and angle of a device hinge (e.g. on foldable devices like iPhone Duo).
public struct UniDeviceHinge: Sendable, Equatable {
    public let status: UniHingeStatus
    public let angle: Angle

    public init(status: UniHingeStatus = .flat, angle: Angle = .degrees(180)) {
        self.status = status
        self.angle = angle
    }
}

/// Context provided during hinge change events.
public struct UniHingeContext: Sendable {
    public let hinge: UniDeviceHinge

    public init(hinge: UniDeviceHinge) {
        self.hinge = hinge
    }
}

/// Represents an area claimed by a hardware hinge, bezel, or camera occlusion.
public struct UniReservedRegion: Identifiable, Sendable, Equatable {
    public let id: UUID
    public let frame: CGRect
    public let kind: UniReservedRegionKind

    public init(id: UUID = UUID(), frame: CGRect, kind: UniReservedRegionKind) {
        self.id = id
        self.frame = frame
        self.kind = kind
    }
}

// MARK: - UniArrangementView

/// A container that manages multi-pane and overlay arrangements for foldable devices (such as iPhone Duo)
/// while providing automatic adaptive fallbacks on single-screen platforms.
///
/// On devices supporting iOS 27.1+ `ArrangementView`, this component bridges native multi-screen layout.
/// On earlier systems, it intelligently coordinates between `HStack`, `VStack`, and `ZStack`
/// based on the configured `.uniArrangementViewStyle`.
///
/// Example:
/// ```swift
/// UniArrangementView {
///     PrimarySidebarView()
/// } secondary: {
///     DetailContentView()
/// }
/// .uniArrangementViewStyle(.split())
/// .uniSplitArrangementLayoutRatio(0.3)
/// ```
public struct UniArrangementView<Primary: View, Secondary: View>: View {
    private let primary: () -> Primary
    private let secondary: () -> Secondary

    @Environment(\.uniArrangementStyle) private var arrangementStyle
    @Environment(\.uniSplitRatio) private var splitRatio
    @Environment(\.uniOverlayEdge) private var overlayEdge

    public init(
        @ViewBuilder primary: @escaping () -> Primary,
        @ViewBuilder secondary: @escaping () -> Secondary
    ) {
        self.primary = primary
        self.secondary = secondary
    }

    public var body: some View {
        Group {
            switch arrangementStyle {
            case .overlay:
                overlayLayout
            case .split(let axes):
                splitLayout(axes: axes)
            }
        }
    }

    @ViewBuilder
    private var overlayLayout: some View {
        ZStack(alignment: overlayAlignment) {
            secondary()
                .environment(\.uniOverlayArrangementZIndex, 1)

            primary()
                .environment(\.uniOverlayArrangementZIndex, 0)
        }
    }

    @ViewBuilder
    private func splitLayout(axes: Axis.Set) -> some View {
        GeometryReader { proxy in
            if axes.contains(.horizontal) {
                HStack(spacing: 0) {
                    primary()
                        .frame(width: proxy.size.width * splitRatio)
                    secondary()
                        .frame(width: proxy.size.width * (1.0 - splitRatio))
                }
            } else {
                VStack(spacing: 0) {
                    primary()
                        .frame(height: proxy.size.height * splitRatio)
                    secondary()
                        .frame(height: proxy.size.height * (1.0 - splitRatio))
                }
            }
        }
    }

    private var overlayAlignment: Alignment {
        switch overlayEdge {
        case .leading: return .leading
        case .trailing: return .trailing
        case .top: return .top
        case .bottom: return .bottom
        }
    }
}
