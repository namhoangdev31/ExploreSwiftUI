import SwiftUI

// MARK: - Toolbar Item Placement Adaptability

extension ToolbarItemPlacement {
    private static var fallbackTitlePlacement: ToolbarItemPlacement {
        #if os(watchOS)
            return .automatic
        #else
            return .principal
        #endif
    }

    /// Returns a native `ToolbarItemPlacement` that adapts to the current OS version,
    /// leveraging iOS 26+ title area placements when available.
    public static func uni(_ placement: UniToolbarTitlePlacement) -> ToolbarItemPlacement
    {
        switch placement {
        case .automatic:
            return .automatic
        case .title:
            #if os(iOS)
                if #available(iOS 26.0, *) {
                    return .title
                }
            #endif
            return fallbackTitlePlacement
        case .subtitle:
            #if os(iOS)
                if #available(iOS 26.0, *) {
                    return .subtitle
                }
            #endif
            return fallbackTitlePlacement
        case .largeTitle:
            #if os(iOS)
                if #available(iOS 26.0, *) {
                    return .largeTitle
                }
            #endif
            return fallbackTitlePlacement
        case .largeSubtitle:
            #if os(iOS)
                if #available(iOS 26.0, *) {
                    return .largeSubtitle
                }
            #endif
            return fallbackTitlePlacement
        }
    }
}

// MARK: - Uni Toolbar Spacer

/// A standard space item in toolbars that adapts to iOS 26 `ToolbarSpacer` API.
///
/// Use this component directly inside `.toolbar { ... }`.
@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
public struct UniToolbarSpacer: ToolbarContent {
    private let sizing: UniToolbarSpacerSizing
    private let placement: ToolbarItemPlacement
    private let fallbackLength: CGFloat?

    public init(
        _ sizing: UniToolbarSpacerSizing = .fixed,
        placement: ToolbarItemPlacement = .automatic,
        fallbackLength: CGFloat? = 12
    ) {
        self.sizing = sizing
        self.placement = placement
        self.fallbackLength = fallbackLength
    }

    @ToolbarContentBuilder
    public var body: some ToolbarContent {
        #if os(iOS) || os(macOS)
            if #available(iOS 26.0, macOS 26.0, *) {
                ToolbarSpacer(sizing == .fixed ? .fixed : .flexible, placement: placement)
            } else {
                ToolbarItem(placement: placement) {
                    UniToolbarSpacerView(sizing, fallbackLength: fallbackLength)
                }
            }
        #else
            ToolbarItem(placement: placement) {
                UniToolbarSpacerView(sizing, fallbackLength: fallbackLength)
            }
        #endif
    }
}

public typealias UniToolbarItemSpacer = UniToolbarSpacer

/// A space view for toolbars when used inside a View hierarchy or ToolbarItemGroup.
@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
public struct UniToolbarSpacerView: View {
    private let sizing: UniToolbarSpacerSizing
    private let fallbackLength: CGFloat?

    public init(
        _ sizing: UniToolbarSpacerSizing = .fixed,
        fallbackLength: CGFloat? = 12
    ) {
        self.sizing = sizing
        self.fallbackLength = fallbackLength
    }

    public var body: some View {
        if sizing == .fixed {
            if let length = fallbackLength {
                Spacer()
                    .frame(width: length)
            } else {
                Spacer()
                    .frame(width: 8)
            }
        } else {
            Spacer()
        }
    }
}

// MARK: - Toolbar Content Modifiers

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
extension ToolbarContent {
    /// Controls the visibility of the glass background effect on items in the toolbar.
    /// On iOS 26+ and macOS 26+, this leverages `sharedBackgroundVisibility`.
    @ToolbarContentBuilder
    public func uniSharedBackgroundVisibility(_ visibility: Visibility) -> some ToolbarContent
    {
        #if os(iOS) || os(macOS)
            if #available(iOS 26.0, macOS 26.0, *) {
                self.sharedBackgroundVisibility(visibility)
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Identifies this toolbar content as the source of a navigation transition,
    /// such as a zoom transition. Supports iOS 26+ native API.
    @ToolbarContentBuilder
    public func uniMatchedTransitionSource(id: some Hashable, in namespace: Namespace.ID)
        -> some ToolbarContent
    {
        #if os(iOS)
            if #available(iOS 26.0, *) {
                self.matchedTransitionSource(id: id, in: namespace)
            } else {
                self
            }
        #else
            self
        #endif
    }
}

// MARK: - Navigation Subtitle Modifiers

extension View {
    /// Configures the view’s subtitle for purposes of navigation.
    /// Supports iOS 26+ `navigationSubtitle` and macOS 11+ native API.
    @ViewBuilder
    public func uniNavigationSubtitle(_ subtitle: Text) -> some View {
        #if os(iOS) || os(macOS)
            if #available(iOS 26.0, macOS 11.0, *) {
                self.navigationSubtitle(subtitle)
            } else {
                self
            }
        #else
            self
        #endif
    }

    @ViewBuilder
    public func uniNavigationSubtitle(_ subtitle: LocalizedStringKey) -> some View {
        #if os(iOS) || os(macOS)
            if #available(iOS 26.0, macOS 11.0, *) {
                self.navigationSubtitle(subtitle)
            } else {
                self
            }
        #else
            self
        #endif
    }

    @ViewBuilder
    public func uniNavigationSubtitle<S: StringProtocol>(_ subtitle: S) -> some View {
        #if os(iOS) || os(macOS)
            if #available(iOS 26.0, macOS 11.0, *) {
                self.navigationSubtitle(subtitle)
            } else {
                self
            }
        #else
            self
        #endif
    }

    @ViewBuilder
    public func uniToolbar(removing kind: UniToolbarDefaultItemKind) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            switch kind {
            case .sidebarToggle:
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    self.toolbar(removing: .sidebarToggle)
                } else {
                    self
                }
            case .title:
                #if !os(tvOS) && !os(watchOS)
                    if #available(iOS 18.0, macOS 15.0, visionOS 2.0, *) {
                        self.toolbar(removing: .title)
                    } else {
                        self
                    }
                #else
                    self
                #endif
            case .search:
                #if !os(tvOS) && !os(watchOS)
                    if #available(iOS 26.0, macOS 26.0, *) {
                        self.toolbar(removing: .search)
                    } else {
                        self
                    }
                #else
                    self
                #endif
            }
        #else
            self
        #endif
    }

    // MARK: - Advanced Toolbar Modifiers (iOS 27+)

    /// Sets the preferred alignment of the navigation bar's title.
    @ViewBuilder
    public func uniToolbarTitleAlignment(_ alignment: UniToolbarTitleAlignment) -> some View {
        #if os(iOS)
            if #available(iOS 27.2, *) {
                let nativeAlignment: ToolbarTitleAlignment = {
                    switch alignment {
                    case .automatic: return .automatic
                    case .leading: return .leading
                    case .center: return .center
                    case .trailing: return .center
                    }
                }()
                self.toolbarTitleAlignment(nativeAlignment)
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Sets the visibility priority for a toolbar item when called on a view.
    public func uniVisibilityPriority(_ priority: UniToolbarItemVisibilityPriority) -> some View {
        self
    }

    /// Sets the bar axis behavior of a toolbar item when called on a view.
    public func uniAxisBehavior(_ behavior: UniToolbarAxisBehavior) -> some View {
        self
    }

    /// Controls toolbar compression behavior prioritising toolbar items over tabs.
    @ViewBuilder
    public func uniToolbarVerticalCompressionBehavior(
        _ behavior: UniToolbarVerticalCompressionBehavior
    ) -> some View {
        #if os(iOS)
            if #available(iOS 27.1, *) {
                switch behavior {
                case .automatic: self.toolbarVerticalCompressionBehavior(.automatic)
                case .prefersToolbarItems: self.toolbarVerticalCompressionBehavior(.prefersToolbarItems)
                case .prefersTabs: self.toolbarVerticalCompressionBehavior(.prefersTabBar)
                }
            } else {
                self
            }
        #elseif os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(macOS 27.1, tvOS 27.1, watchOS 27.1, visionOS 27.1, *) {
                self.toolbarVerticalCompressionBehavior(.automatic)
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Configures whether content margins are removed from a toolbar item when called on a view.
    public func uniContentMarginsRemoved(_ removed: Bool = true) -> some View {
        self
    }
}

// MARK: - ToolbarContent Extensions

extension ToolbarContent {
    /// Sets the visibility priority for a toolbar item.
    @ToolbarContentBuilder
    public func uniVisibilityPriority(_ priority: UniToolbarItemVisibilityPriority) -> some ToolbarContent {
        #if os(iOS) || os(macOS)
            if #available(iOS 27.0, macOS 26.1, *) {
                self.visibilityPriority(nativePriority(for: priority))
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Sets the bar axis behavior of a toolbar item.
    @ToolbarContentBuilder
    public func uniAxisBehavior(_ behavior: UniToolbarAxisBehavior) -> some ToolbarContent {
        #if os(iOS)
            if #available(iOS 27.1, *) {
                switch behavior {
                case .automatic: self.axisBehavior(.automatic)
                case .horizontalOnly: self.axisBehavior(.horizontalOnly)
                case .verticalPreferred: self.axisBehavior(.verticalPreferred)
                }
            } else {
                self
            }
        #elseif os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(macOS 27.1, tvOS 27.1, watchOS 27.1, visionOS 27.1, *) {
                self.axisBehavior(.automatic)
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Configures whether content margins are removed from a toolbar item.
    @ToolbarContentBuilder
    public func uniContentMarginsRemoved(_ removed: Bool = true) -> some ToolbarContent {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 27.0, macOS 27.0, watchOS 27.0, tvOS 27.0, visionOS 27.0, *) {
                self.contentMarginsRemoved(removed)
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Configures whether this toolbar content item is hidden.
    @ToolbarContentBuilder
    public func uniHidden(_ hidden: Bool = true) -> some ToolbarContent {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 26.4, macOS 15.0, tvOS 27.2, watchOS 27.2, visionOS 26.4, *) {
                self.hidden(hidden)
            } else {
                self
            }
        #else
            self
        #endif
    }
}

// MARK: - Toolbar Minimization Modifiers (iOS 27+)

extension View {
    /// Sets the toolbar minimization behavior for specified bars during scroll.
    @ViewBuilder
    public func uniToolbarMinimizationBehavior(
        _ behavior: UniToolbarMinimizationBehavior,
        for bars: ToolbarPlacement...
    ) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 27.0, macOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *) {
                self.toolbarMinimizationBehavior(.automatic)
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Controls whether safe area adjusts interactively during toolbar minimization.
    @ViewBuilder
    public func uniToolbarMinimizationSafeAreaAdjustment(
        _ adjustment: UniToolbarMinimizationSafeAreaAdjustment,
        for bars: ToolbarPlacement...
    ) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 27.0, macOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *) {
                self.toolbarMinimizationSafeAreaAdjustment(.automatic)
            } else {
                self
            }
        #else
            self
        #endif
    }

    /// Sets the restoration behavior for the specified bars during minimization.
    @ViewBuilder
    public func uniToolbarMinimizationRestoration(
        _ restoration: UniToolbarMinimizationRestoration,
        for bars: ToolbarPlacement...
    ) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 27.0, macOS 27.0, tvOS 27.0, watchOS 27.0, visionOS 27.0, *) {
                self.toolbarMinimizationRestoration(.automatic)
            } else {
                self
            }
        #else
            self
        #endif
    }
}

// MARK: - Native Priority Mapper Helper

#if os(iOS) || os(macOS)
@available(iOS 27.0, macOS 26.1, *)
private func nativePriority(for priority: UniToolbarItemVisibilityPriority) -> ToolbarItemVisibilityPriority {
    switch priority {
    case .lowest:
        if #available(iOS 27.0, macOS 27.0, *) {
            return .init(lowerThan: .low)
        } else {
            return .low
        }
    case .low:
        return .low
    case .automatic:
        return .automatic
    case .high:
        return .high
    case .highest:
        if #available(iOS 27.0, macOS 27.0, *) {
            return .init(higherThan: .high)
        } else {
            return .high
        }
    }
}
#endif

// MARK: - UniToolbarOverflowMenu

/// An overflow menu container for toolbars that groups auxiliary actions.
///
/// On iOS 27+ and visionOS 27+, uses native `ToolbarOverflowMenu`.
/// On older versions, gracefully degrades to a standard `ToolbarItem(placement: .secondaryAction)`.
public struct UniToolbarOverflowMenu<Content: View>: ToolbarContent {
    private let content: () -> Content

    public init(@ViewBuilder content: @escaping () -> Content) {
        self.content = content
    }

    @ToolbarContentBuilder
    public var body: some ToolbarContent {
        #if os(iOS) || os(visionOS)
            if #available(iOS 27.0, visionOS 27.0, *) {
                ToolbarOverflowMenu {
                    content()
                }
            } else {
                ToolbarItem(placement: .secondaryAction) {
                    Menu {
                        content()
                    } label: {
                        Image(systemName: "ellipsis.circle")
                    }
                }
            }
        #else
            ToolbarItem(placement: .secondaryAction) {
                Menu {
                    content()
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        #endif
    }
}

// MARK: - Placement Extensions

extension ToolbarItemPlacement {
    /// A placement that pins an item to the trailing edge of a toolbar (iOS 27+).
    public static var uniTopBarPinnedTrailing: ToolbarItemPlacement {
        #if os(iOS) || os(visionOS)
            if #available(iOS 27.0, visionOS 27.0, *) {
                return .topBarPinnedTrailing
            } else {
                return .primaryAction
            }
        #else
            return .primaryAction
        #endif
    }
}
