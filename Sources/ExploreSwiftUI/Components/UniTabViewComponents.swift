import SwiftUI

// ╔══════════════════════════════════════════════════════════════════╗
// ║  UniTabViewComponents — Components Layer                   ║
// ║  Concrete types for Tab Views group                             ║
// ║  File: Components/UniTabViewComponents.swift               ║
// ╚══════════════════════════════════════════════════════════════════╝

// MARK: - Uni Tab DSL

/// A component that represents a single tab item within an uni tab view.
///
/// `UniTab` is a polymorphic DSL element. It returns a descriptor that `UniTabView`
/// uses to automatically render either a modern `Tab` (iOS 18+) or a legacy `.tabItem` (iOS 15-17).
///
/// Example:
/// ```swift
/// UniTab("Home", systemImage: "house", value: "home") {
///     HomeView()
/// }
///
/// UniTab("Search", systemImage: "magnifyingglass", value: "search", role: .search) {
///     SearchView()
/// }
/// ```
public func UniTab<Value: Hashable, Content: View>(
    _ titleKey: LocalizedStringKey,
    systemImage: String? = nil,
    image: String? = nil,
    value: Value,
    role: UniTabRole = .automatic,
    @ViewBuilder content: @escaping () -> Content
) -> _UniTabDescriptor<Value> {
    _UniTabDescriptor(
        titleKey: titleKey,
        systemImage: systemImage,
        image: image,
        value: value,
        role: role,
        content: AnyView(content())
    )
}

/// A component that groups related tabs into a section.
///
/// `UniTabSection` leverages `TabSection` on iOS 18+ for sidebar and expanded layouts,
/// and falls back to standard `Section` groupings on older platforms.
///
/// Example:
/// ```swift
/// UniTabSection("Personal") {
///     UniTab("Search", systemImage: "magnifyingglass", value: "search") {
///         SearchView()
///     }
///     UniTab("Profile", systemImage: "person", value: "profile") {
///         ProfileView()
///     }
/// }
/// ```
public func UniTabSection<Value: Hashable>(
    _ titleKey: LocalizedStringKey? = nil,
    @UniTabBuilder<Value> content: @escaping () -> [_UniTabDescriptor<Value>]
) -> _UniTabSectionDescriptor<Value> {
    _UniTabSectionDescriptor(
        titleKey: titleKey,
        children: content()
    )
}

// MARK: - UniTabView

/// A container view that displays multiple tabs, adapting to platform standards.
///
/// `UniTabView` provides a unified tab interface. On iOS 18+ / macOS 15+, it renders using the modern native `TabView` structure.
/// On older systems (iOS 15-17), it falls back to the legacy tab structure with `.tabItem` and `.tag`.
///
/// Example:
/// ```swift
/// UniTabView(selection: $selection) {
///     UniTab("Home", systemImage: "house", value: Tab.home) {
///         HomeView()
///     }
///     UniTab("Settings", systemImage: "gear", value: Tab.settings) {
///         SettingsView()
///     }
/// }
/// ```
public struct UniTabView<Selection: Hashable>: View {
    @Binding private var selection: Selection
    private let tabs: () -> [_UniTabDescriptor<Selection>]

    /// Creates an uni tab view with a selection binding.
    ///
    /// Example:
    /// ```swift
    /// UniTabView(selection: $selection) {
    ///     UniTab("Home", systemImage: "house", value: Tab.home) {
    ///         HomeView()
    ///     }
    /// }
    /// ```
    public init(
        selection: Binding<Selection>,
        @UniTabBuilder<Selection> content: @escaping () -> [_UniTabDescriptor<Selection>]
    ) {
        self._selection = selection
        self.tabs = content
    }

    public var body: some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            if #available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *) {
                modernTabView
            } else {
                legacyTabView
            }
        #else
            legacyTabView
        #endif
    }

    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    private var modernTabView: some View {
        TabView(selection: $selection) {
            ForEach(tabs(), id: \.value) { descriptor in
                descriptor
            }
        }
    }

    private var legacyTabView: some View {
        TabView(selection: $selection) {
            ForEach(tabs(), id: \.value) { descriptor in
                descriptor.legacyTab
            }
        }
    }
}

// MARK: - Internal Descriptors

/// Internal descriptor used to bridge between different TabView implementations.
public struct _UniTabDescriptor<Value: Hashable>: Identifiable, Hashable {
    public var id: Value { value }

    let titleKey: LocalizedStringKey
    let systemImage: String?
    let image: String?
    let value: Value
    let role: UniTabRole
    let content: AnyView
    var customizationID: String? = nil
    var badgeInt: Int? = nil
    var badgeString: String? = nil
    var customizationBehavior: UniTabCustomizationBehavior? = nil
    var customizationPlacements: Set<UniTabCustomizationPlacement>? = nil

    public static func == (lhs: _UniTabDescriptor<Value>, rhs: _UniTabDescriptor<Value>) -> Bool {
        lhs.value == rhs.value
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(value)
    }

    /// Creates a tab descriptor.
    ///
    /// Example:
    /// ```swift
    /// _UniTabDescriptor("Search", systemImage: "magnifyingglass", value: "search", role: .search) {
    ///     SearchView()
    /// }
    /// ```
    public init(
        _ titleKey: LocalizedStringKey,
        systemImage: String? = nil,
        image: String? = nil,
        value: Value,
        role: UniTabRole = .automatic,
        @ViewBuilder content: @escaping () -> some View
    ) {
        self.titleKey = titleKey
        self.systemImage = systemImage
        self.image = image
        self.value = value
        self.role = role
        self.content = AnyView(content())
    }

    init(
        titleKey: LocalizedStringKey,
        systemImage: String?,
        image: String?,
        value: Value,
        role: UniTabRole,
        content: AnyView,
        customizationID: String? = nil,
        badgeInt: Int? = nil,
        badgeString: String? = nil,
        customizationBehavior: UniTabCustomizationBehavior? = nil,
        customizationPlacements: Set<UniTabCustomizationPlacement>? = nil
    ) {
        self.titleKey = titleKey
        self.systemImage = systemImage
        self.image = image
        self.value = value
        self.role = role
        self.content = content
        self.customizationID = customizationID
        self.badgeInt = badgeInt
        self.badgeString = badgeString
        self.customizationBehavior = customizationBehavior
        self.customizationPlacements = customizationPlacements
    }

    // Modifiers returning modified copies

    /// Sets a customization identifier for the tab.
    ///
    /// Example:
    /// ```swift
    /// UniTab("Home", systemImage: "house", value: "home") {
    ///     HomeView()
    /// }
    /// .uniCustomizationID("tab.home")
    /// ```
    public func uniCustomizationID(_ id: String) -> Self {
        var copy = self
        copy.customizationID = id
        return copy
    }

    /// Sets an integer badge value for the tab.
    ///
    /// Example:
    /// ```swift
    /// UniTab("Inbox", systemImage: "tray", value: "inbox") {
    ///     InboxView()
    /// }
    /// .uniTabBadge(5)
    /// ```
    public func uniTabBadge(_ value: Int) -> Self {
        var copy = self
        copy.badgeInt = value
        return copy
    }

    /// Sets a string badge value for the tab.
    ///
    /// Example:
    /// ```swift
    /// UniTab("Inbox", systemImage: "tray", value: "inbox") {
    ///     InboxView()
    /// }
    /// .uniTabBadge("New")
    /// ```
    public func uniTabBadge(_ value: String) -> Self {
        var copy = self
        copy.badgeString = value
        return copy
    }

    /// Configures the customization behavior for the tab in specific placements.
    ///
    /// Example:
    /// ```swift
    /// UniTab("Home", systemImage: "house", value: "home") {
    ///     HomeView()
    /// }
    /// .uniCustomizationBehavior(.disabled, for: [.sidebar])
    /// ```
    public func uniCustomizationBehavior(
        _ behavior: UniTabCustomizationBehavior = .automatic,
        for placements: Set<UniTabCustomizationPlacement> = [.sidebar, .tabBar]
    ) -> Self {
        var copy = self
        copy.customizationBehavior = behavior
        copy.customizationPlacements = placements
        return copy
    }

    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    var modernTab: some TabContent<Value> {
        let baseTab: AnyTabContent<Value>
        if let systemImage = systemImage {
            if role == .search {
                baseTab = AnyTabContent(Tab(titleKey, systemImage: systemImage, value: value, role: .search) {
                    content
                })
            } else {
                baseTab = AnyTabContent(Tab(titleKey, systemImage: systemImage, value: value) {
                    content
                })
            }
        } else if let image = image {
            baseTab = AnyTabContent(Tab(titleKey, image: image, value: value) {
                content
            })
        } else {
            baseTab = AnyTabContent(Tab(value: value) {
                content
            } label: {
                Label(titleKey, systemImage: "photo")
            })
        }

        var resolvedTab = baseTab
        if let customizationID = customizationID {
            resolvedTab = AnyTabContent(resolvedTab.customizationID(customizationID))
        }

        if let badgeInt = badgeInt {
            resolvedTab = AnyTabContent(resolvedTab.badge(badgeInt))
        } else if let badgeString = badgeString {
            resolvedTab = AnyTabContent(resolvedTab.badge(badgeString))
        }

        if let customizationBehavior = customizationBehavior {
            let placements = customizationPlacements ?? [.sidebar, .tabBar]
            let mappedBehavior: TabCustomizationBehavior = {
                switch customizationBehavior {
                case .automatic: return .automatic
                case .reorderable:
                    #if os(iOS) || os(visionOS)
                    return .reorderable
                    #else
                    return .automatic
                    #endif
                case .disabled:
                    #if os(iOS) || os(visionOS)
                    return .disabled
                    #else
                    return .automatic
                    #endif
                }
            }()

            #if os(iOS) || os(visionOS)
                if placements.contains(.sidebar) && placements.contains(.tabBar) {
                    resolvedTab = AnyTabContent(resolvedTab.customizationBehavior(mappedBehavior, for: AdaptableTabBarPlacement.sidebar, AdaptableTabBarPlacement.tabBar))
                } else if placements.contains(.sidebar) {
                    resolvedTab = AnyTabContent(resolvedTab.customizationBehavior(mappedBehavior, for: AdaptableTabBarPlacement.sidebar))
                } else if placements.contains(.tabBar) {
                    resolvedTab = AnyTabContent(resolvedTab.customizationBehavior(mappedBehavior, for: AdaptableTabBarPlacement.tabBar))
                }
            #elseif os(macOS)
                if placements.contains(.tabBar) {
                    resolvedTab = AnyTabContent(resolvedTab.customizationBehavior(mappedBehavior, for: AdaptableTabBarPlacement.tabBar))
                }
            #endif
        }

        return resolvedTab
    }

    var legacyTab: some View {
        content
            .tabItem {
                if let systemImage = systemImage {
                    Label(titleKey, systemImage: systemImage)
                } else if let image = image {
                    Label(titleKey, image: image)
                } else {
                    Text(titleKey)
                }
            }
            .tag(value)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension _UniTabDescriptor: TabContent {
    public typealias TabValue = Value

    @MainActor
    @preconcurrency
    public var body: some TabContent<Value> {
        modernTab
    }
}

/// Internal descriptor for tab grouping.
public struct _UniTabSectionDescriptor<Value: Hashable>: Hashable {
    let titleKey: LocalizedStringKey?
    let children: [_UniTabDescriptor<Value>]

    public static func == (lhs: _UniTabSectionDescriptor<Value>, rhs: _UniTabSectionDescriptor<Value>) -> Bool {
        lhs.children == rhs.children
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(children)
    }
}

@available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
extension _UniTabSectionDescriptor: TabContent {
    public typealias TabValue = Value

    @TabContentBuilder<Value>
    @MainActor
    @preconcurrency
    public var body: some TabContent<Value> {
        if let titleKey = titleKey {
            TabSection(titleKey) {
                ForEach(children, id: \.value) { child in
                    child
                }
            }
        } else {
            TabSection {
                ForEach(children, id: \.value) { child in
                    child
                }
            }
        }
    }
}

// MARK: - Result Builder

/// A result builder that collects `UniTab` descriptors for rendering.
@resultBuilder
public struct UniTabBuilder<Value: Hashable> {
    public static func buildBlock(_ components: _UniTabDescriptor<Value>...)
        -> [_UniTabDescriptor<Value>]
    {
        Array(components)
    }

    public static func buildBlock(_ components: [_UniTabDescriptor<Value>]...)
        -> [_UniTabDescriptor<Value>]
    {
        components.flatMap { $0 }
    }

    public static func buildOptional(_ component: [_UniTabDescriptor<Value>]?)
        -> [_UniTabDescriptor<Value>]
    {
        component ?? []
    }

    public static func buildEither(first component: [_UniTabDescriptor<Value>])
        -> [_UniTabDescriptor<Value>]
    {
        component
    }

    public static func buildEither(second component: [_UniTabDescriptor<Value>])
        -> [_UniTabDescriptor<Value>]
    {
        component
    }
}

// MARK: - Compatibility Aliases

/// Provided for backward compatibility with previous library versions.
public typealias UniValueTab = _UniTabDescriptor
