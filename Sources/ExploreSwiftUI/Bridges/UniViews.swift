import SwiftUI

/// An uni representation of `ControlSize` that falls back safely on older OS versions.

/// An uni representation of `ContainerBackgroundPlacement` that falls back safely.

extension View {

    // MARK: - ControlSize

    /// Applies a control size to the view with cross-platform support.
    ///
    /// - Parameters:
    ///   - size: The uni control size (e.g., `.small`, `.large`).
    ///
    /// - Platforms Supported: iOS 15.0+, macOS 10.15+, watchOS 9.0+, tvOS 15.0+, visionOS 1.0+.
    /// - Fallback Behavior: Gracefully does nothing on older versions.
    ///
    /// Example:
    /// ```swift
    /// Button("Action") { }
    ///     .uniControlSize(.small)
    /// ```
    @ViewBuilder
    public func uniControlSize(_ size: UniControlSize) -> some View {
        if #available(iOS 15.0, macOS 10.15, tvOS 15.0, watchOS 9.0, visionOS 1.0, *) {
            self.controlSize(size.native)
        } else {
            self
        }
    }

    // MARK: - Background Extension Effect

    /// Adds the background extension effect to the view (Future Support).
    ///
    /// Mirrored copies will be placed around the view on any edge with available safe area.
    /// - Platforms Supported: iOS 26.0+ and other OS version 26+ platforms.
    @ViewBuilder
    public func uniBackgroundExtensionEffect() -> some View {
        if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, visionOS 26.0, *) {
            self.backgroundExtensionEffect()
        } else {
            self
        }
    }

    // MARK: - Glass Effect

    /// Applies the Liquid Glass effect to a view (Future Support).
    ///
    /// Available on iOS 26+, macOS 26+, etc. Gracefully ignored on earlier versions and visionOS.
    ///
    /// Example:
    /// ```swift
    /// MyCard()
    ///     .uniGlassEffect()
    /// ```
    @ViewBuilder
    public func uniGlassEffect() -> some View {
        #if !os(visionOS)
            if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, *) {
                self.glassEffect()
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Applies the Liquid Glass effect to a view within a specific shape (Future Support).
    @ViewBuilder
    public func uniGlassEffect<S: Shape>(in shape: S) -> some View {
        #if !os(visionOS)
            if #available(iOS 26.0, macOS 26.0, watchOS 26.0, tvOS 26.0, *) {
                self.glassEffect(in: shape)
            } else {
                self
            }
        #else
            self
        #endif
    }

    // MARK: - Material Background

    /// Applies an uni material background with continuous rounded corners.
    ///
    /// Example:
    /// ```swift
    /// Text("Floating Panel")
    ///     .uniMaterialBackground(.regular, cornerRadius: 16)
    /// ```
    @ViewBuilder
    public func uniMaterialBackground(
        _ material: UniMaterialStyle,
        cornerRadius: CGFloat = 12
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, visionOS 1.0, *) {
            self.background(
                material.shapeStyle,
                in: RoundedRectangle(cornerRadius: cornerRadius, style: .continuous)
            )
        } else {
            self
        }
    }

    // MARK: - Hierarchical Foreground

    /// Applies a hierarchical foreground style to the view.
    ///
    /// This modifier handles hierarchical styles across OS versions:
    /// - **iOS 17+**: Uses native `.foregroundStyle` with hierarchical variants (`.secondary`, `.tertiary`, etc.).
    /// - **iOS 15-16**: Uses native `.foregroundStyle` with simulated opacity.
    /// - **Legacy**: Falls back to `.foregroundColor` with simulated opacity to maintain visual hierarchy.
    ///
    /// Example:
    /// ```swift
    /// Text("Subtitle")
    ///     .uniForegroundStyle(.blue, variant: .secondary)
    /// ```
    @ViewBuilder
    public func uniForegroundStyle(
        _ color: Color,
        variant: UniHierarchicalVariant = .primary
    ) -> some View {
        switch variant {
        case .primary:
            if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
                self.foregroundStyle(color)
            } else {
                self.foregroundColor(color)
            }
        case .secondary:
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                self.foregroundStyle(color.secondary)
            } else if #available(iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                self.foregroundStyle(color.opacity(0.6))
            } else {
                self.foregroundColor(color.opacity(0.6))
            }
        case .tertiary:
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                self.foregroundStyle(color.tertiary)
            } else if #available(iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                self.foregroundStyle(color.opacity(0.4))
            } else {
                self.foregroundColor(color.opacity(0.4))
            }
        case .quaternary:
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                self.foregroundStyle(color.quaternary)
            } else if #available(iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                self.foregroundStyle(color.opacity(0.25))
            } else {
                self.foregroundColor(color.opacity(0.25))
            }
        case .quinary:
            if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                self.foregroundStyle(color.quinary)
            } else if #available(iOS 15.0, tvOS 15.0, watchOS 8.0, *) {
                self.foregroundStyle(color.opacity(0.15))
            } else {
                self.foregroundColor(color.opacity(0.15))
            }
        }
    }

    // MARK: - Toolbar Vertical Behavior (iOS 27.1+)

    /// Sets the vertical behavior of toolbars on adaptable layouts (iOS 27.1+).
    @ViewBuilder
    public func uniToolbarVerticalBehavior(_ behavior: UniToolbarVerticalBehavior) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 27.1, macOS 27.1, tvOS 27.1, watchOS 27.1, visionOS 27.1, *) {
                let native: ToolbarVerticalBehavior = {
                    switch behavior {
                    case .automatic: return .automatic
                    case .disabled: return .disabled
                    }
                }()
                self.toolbarVerticalBehavior(native)
            } else {
                self
            }
        #else
            self
        #endif
    }

    // MARK: - Container Content Margins (iOS 27.1+)

    /// Adds container content margins to the view (iOS 27.1+).
    @ViewBuilder
    public func uniContentMargins(
        for guide: UniContentMarginGuide = .container,
        edges: Edge.Set = .all,
        length: CGFloat? = nil
    ) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 27.1, macOS 27.1, tvOS 27.1, watchOS 27.1, visionOS 27.1, *) {
                switch guide {
                case .container:
                    self.contentMargins(for: .container, edges: edges)
                case .scrollContent:
                    if let length = length {
                        self.contentMargins(edges, length, for: .scrollContent)
                    } else {
                        self
                    }
                case .scrollIndicators:
                    if let length = length {
                        self.contentMargins(edges, length, for: .scrollIndicators)
                    } else {
                        self
                    }
                case .automatic:
                    if let length = length {
                        self.contentMargins(edges, length, for: .automatic)
                    } else {
                        self
                    }
                }
            } else if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                if let length = length {
                    self.contentMargins(edges, length, for: .automatic)
                } else {
                    self
                }
            } else {
                self
            }
        #else
            self
        #endif
    }

    // MARK: - Music Picker Bridge

    /// Fallback music picker presentation for systems without MusicKit or older versions.
    public func uniMusicPicker(
        isPresented: Binding<Bool>,
        title: Text? = nil
    ) -> some View {
        self
    }
}

// MARK: - Environment Keys

private struct UniToolbarVerticalEdgeKey: EnvironmentKey {
    static let defaultValue: UniToolbarVerticalEdge? = nil
}

private struct UniSystemPrefersReducedResourceUsageKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct UniIsTabViewSidebarAvailableKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct UniAccessibilityPrefersCrossFadeTransitionsKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

private struct UniAccessibilityReduceHighlightingEffectsKey: EnvironmentKey {
    static let defaultValue: Bool = false
}

extension EnvironmentValues {
    /// Reflects the system's preferred edge for the vertical bar in the current context.
    public var uniToolbarVerticalEdge: UniToolbarVerticalEdge? {
        get {
            #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
                if #available(iOS 27.1, macOS 27.1, tvOS 27.1, watchOS 27.1, visionOS 27.1, *) {
                    if let edge = self.toolbarVerticalEdge {
                        switch edge {
                        case .leading: return .leading
                        case .trailing: return .trailing
                        @unknown default: return nil
                        }
                    }
                }
            #endif
            return self[UniToolbarVerticalEdgeKey.self]
        }
        set {
            self[UniToolbarVerticalEdgeKey.self] = newValue
        }
    }

    /// Indicates whether the system prefers reduced resource usage (e.g. low memory/battery).
    public var uniSystemPrefersReducedResourceUsage: Bool {
        get {
            #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
                if #available(iOS 27.0, macOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *) {
                    return self.systemPrefersReducedResourceUsage
                }
            #endif
            return self[UniSystemPrefersReducedResourceUsageKey.self]
        }
        set {
            self[UniSystemPrefersReducedResourceUsageKey.self] = newValue
        }
    }

    /// Indicates whether the tab view sidebar is currently available in the environment.
    public var uniIsTabViewSidebarAvailable: Bool {
        get {
            #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
                if #available(iOS 27.0, macOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *) {
                    return self.isTabViewSidebarAvailable
                }
            #endif
            return self[UniIsTabViewSidebarAvailableKey.self]
        }
        set {
            self[UniIsTabViewSidebarAvailableKey.self] = newValue
        }
    }

    /// Indicates whether user preferences favor cross-fade transitions over spatial motion.
    public var uniAccessibilityPrefersCrossFadeTransitions: Bool {
        get {
            #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
                if #available(iOS 26.4, macOS 26.4, tvOS 26.4, watchOS 26.4, visionOS 26.4, *) {
                    return self.accessibilityPrefersCrossFadeTransitions
                }
            #endif
            return self[UniAccessibilityPrefersCrossFadeTransitionsKey.self]
        }
        set {
            self[UniAccessibilityPrefersCrossFadeTransitionsKey.self] = newValue
        }
    }

    /// Indicates whether the user prefers reduced highlighting effects.
    public var uniAccessibilityReduceHighlightingEffects: Bool {
        get {
            #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
                if #available(iOS 26.4, macOS 26.4, tvOS 26.4, watchOS 26.4, visionOS 26.4, *) {
                    return self.accessibilityReduceHighlightingEffects
                }
            #endif
            return self[UniAccessibilityReduceHighlightingEffectsKey.self]
        }
        set {
            self[UniAccessibilityReduceHighlightingEffectsKey.self] = newValue
        }
    }
}

// MARK: - GeometryProxy Content Margins (iOS 27.1+)

extension GeometryProxy {
    /// Returns the content margins for the specified guide and edges within this geometry proxy space.
    public func uniContentMargins(for guide: UniContentMarginGuide, edges: Edge.Set = .all) -> EdgeInsets {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 27.1, macOS 27.1, tvOS 27.1, watchOS 27.1, visionOS 27.1, *) {
                return self.contentMargins(for: .container, edges: edges)
            }
        #endif
        return EdgeInsets()
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 10.0, visionOS 1.0, *)
extension UniMaterialStyle {
    var shapeStyle: Material {
        switch self {
        case .ultraThin:
            return .ultraThinMaterial
        case .thin:
            return .thinMaterial
        case .regular:
            return .regularMaterial
        case .thick:
            return .thickMaterial
        case .ultraThick:
            return .ultraThickMaterial
        }
    }
}
