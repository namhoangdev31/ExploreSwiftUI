import SwiftUI

extension View {

    /// Configures the view's uni title and subtitle for navigation.
    ///
    /// This modifier handles cross-platform navigation headers:
    /// - **iOS 26+ / macOS 11+**: Uses native `.navigationTitle` and `.navigationSubtitle`.
    /// - **iOS 14-18**: Polyfills the subtitle by using a `ToolbarItem` with `.principal` placement,
    ///   stacking the title and subtitle vertically.
    /// - **iOS 13**: Falls back to showing only the main title.
    ///
    /// - Parameters:
    ///   - title: The primary title to display.
    ///   - subtitle: The secondary title/subtitle to display.
    ///
    /// Example:
    /// ```swift
    /// View()
    ///     .uniNavigationTitle("Settings", subtitle: "Profile and Security")
    /// ```
    @ViewBuilder
    public func uniNavigationTitle(_ title: LocalizedStringKey, subtitle: LocalizedStringKey? = nil)
        -> some View
    {
        if let subtitle = subtitle {
            #if os(iOS) || os(macOS)
            if #available(iOS 26.0, macOS 11.0, *) {
                self.navigationTitle(title).navigationSubtitle(subtitle)
            } else {
                fallbackTitle(titleKey: title, subtitleKey: subtitle)
            }
            #else
            fallbackTitle(titleKey: title, subtitleKey: subtitle)
            #endif
        } else {
            self.navigationTitle(title)
        }
    }

    /// Configures the view's uni title and subtitle using string protocols.
    @ViewBuilder
    public func uniNavigationTitle<S: StringProtocol>(_ title: S, subtitle: S? = nil) -> some View {
        if let subtitle = subtitle {
            #if os(iOS) || os(macOS)
            if #available(iOS 26.0, macOS 11.0, *) {
                self.navigationTitle(title).navigationSubtitle(subtitle)
            } else {
                fallbackTitle(title: title, subtitle: subtitle)
            }
            #else
            fallbackTitle(title: title, subtitle: subtitle)
            #endif
        } else {
            self.navigationTitle(title)
        }
    }

    @ViewBuilder
    private func fallbackTitle(titleKey: LocalizedStringKey, subtitleKey: LocalizedStringKey?)
        -> some View
    {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            self.navigationTitle(titleKey)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack(spacing: 0) {
                            Text(titleKey)
                                .font(.headline)
                            if let subtitleKey = subtitleKey {
                                Text(subtitleKey)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
        } else {
            #if os(iOS) || os(tvOS) || os(watchOS)
                self.navigationBarTitle(Text(titleKey))
            #else
                self
            #endif
        }
    }

    @ViewBuilder
    private func fallbackTitle<S: StringProtocol>(title: S, subtitle: S?) -> some View {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, *) {
            self.navigationTitle(title)
                .toolbar {
                    ToolbarItem(placement: .principal) {
                        VStack(spacing: 0) {
                            Text(title)
                                .font(.headline)
                            if let subtitle = subtitle {
                                Text(subtitle)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
        } else {
            #if os(iOS) || os(tvOS) || os(watchOS)
                self.navigationBarTitle(Text(title))
            #else
                self
            #endif
        }
    }

    // MARK: - Container Background

    /// Applies a background style to the navigation container on supported platforms.
    ///
    /// Supported on iOS 18+ and watchOS 11+.
    ///
    /// Example:
    /// ```swift
    /// NavigationStack { ... }
    ///     .uniContainerBackground(.ultraThinMaterial)
    /// ```
    @ViewBuilder
    public func uniContainerBackground<S: ShapeStyle>(
        _ style: S,
        for placement: UniContainerBackgroundPlacement = .navigation
    ) -> some View {
        switch placement {
        case .navigation:
            #if os(iOS) || os(watchOS)
                if #available(iOS 18.0, watchOS 11.0, *) {
                    self.containerBackground(style, for: .navigation)
                } else {
                    self
                }
            #else
                self
            #endif
        case .navigationSplitView:
            #if os(iOS) || os(watchOS)
                if #available(iOS 18.0, watchOS 11.0, *) {
                    self.containerBackground(style, for: .navigationSplitView)
                } else {
                    self
                }
            #else
                self
            #endif
        }
    }

    /// Applies a custom view as the background to the navigation container.
    @ViewBuilder
    public func uniContainerBackground<Background: View>(
        for placement: UniContainerBackgroundPlacement = .navigation,
        alignment: Alignment = .center,
        @ViewBuilder content: () -> Background
    ) -> some View {
        switch placement {
        case .navigation:
            #if os(iOS) || os(watchOS)
                if #available(iOS 18.0, watchOS 11.0, *) {
                    self.containerBackground(
                        for: .navigation, alignment: alignment, content: content)
                } else {
                    self
                }
            #else
                self
            #endif
        case .navigationSplitView:
            #if os(iOS) || os(watchOS)
                if #available(iOS 18.0, watchOS 11.0, *) {
                    self.containerBackground(
                        for: .navigationSplitView, alignment: alignment, content: content)
                } else {
                    self
                }
            #else
                self
            #endif
        }
    }

    // MARK: - Scroll Edge Effect

    /// Enables a hard edge effect when scrolling to the edge of the navigation container.
    ///
    /// Supported on iOS 26+, macOS 26+, etc.
    @ViewBuilder
    public func uniScrollEdgeHardEffect(isEnabled: Bool = true) -> some View {
        if isEnabled {
            if #available(iOS 26.0, macOS 26.0, tvOS 26.0, watchOS 26.0, *) {
                self.scrollEdgeEffectStyle(.hard, for: .all)
            } else {
                self
            }
        } else {
            self
        }
    }
    
    // MARK: - Toolbar Background (iOS 16+)
    
    /// Specifies the background style for the navigation toolbar.
    ///
    /// - **iOS 16+**: Uses the native `.toolbarBackground(_:for:)` modifier.
    /// - **iOS 15**: Gracefully ignores the modifier to maintain stability and avoid global `UINavigationBar.appearance()` side-effects.
    @ViewBuilder
    public func uniToolbarBackground<S: ShapeStyle>(_ style: S, visibility: Visibility = .visible) -> some View {
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            self.toolbarBackground(style, for: .navigationBar)
                .toolbarBackground(visibility, for: .navigationBar)
        } else {
            self
        }
        #else
        self
        #endif
    }
    
    /// Specifies the background visibility for the navigation toolbar.
    @ViewBuilder
    public func uniToolbarBackground(_ visibility: Visibility, for placement: UniToolbarPlacement = .navigationBar) -> some View {
        #if os(iOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, tvOS 16.0, watchOS 9.0, *) {
            // Note: Currently maps directly to navigationBar for simplicity.
            self.toolbarBackground(visibility, for: .navigationBar)
        } else {
            self
        }
        #else
        self
        #endif
    }

    // MARK: - Navigation Bar Back Button Hidden
    
    /// Hides the navigation bar back button, with safe fallbacks across platforms.
    ///
    /// Example:
    /// ```swift
    /// View()
    ///     .uniNavigationBarBackButtonHidden(true)
    /// ```
    @ViewBuilder
    public func uniNavigationBarBackButtonHidden(_ hidden: Bool = true) -> some View {
        // Native modifier is available since iOS 13, but wrapping it allows us 
        // to attach future swipe-to-back polyfills seamlessly.
        self.navigationBarBackButtonHidden(hidden)
    }

    /// Controls the visibility of system toolbars with iOS 16+ support and iOS 15 fallback.
    ///
    /// - **iOS 16+**: Uses the native `.toolbar(_:for:)` modifier.
    /// - **iOS 15**: 
    ///   - For `.navigationBar`, falls back to `.navigationBarHidden(visibility == .hidden)`.
    ///   - For `.tabBar`, degrades to a no-op fallback.
    @ViewBuilder
    public func uniToolbarVisibility(
        _ visibility: UniToolbarVisibility,
        for placement: UniToolbarPlacement
    ) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            self.toolbar(visibility.native, for: placement.native)
        } else {
            switch placement {
            case .navigationBar:
                self.navigationBarHidden(visibility == .hidden)
            case .tabBar:
                self
            }
        }
        #else
        self
        #endif
    }
}

/// Helper enum to map Toolbar Placement securely.
public enum UniToolbarPlacement: Sendable {
    case navigationBar
    case tabBar

    @available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
    var native: ToolbarPlacement {
        switch self {
        case .navigationBar:
            return .navigationBar
        case .tabBar:
            #if os(iOS) || os(tvOS)
            return .tabBar
            #else
            return .automatic
            #endif
        }
    }
}

