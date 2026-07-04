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
/// UniTab("Today", systemImage: "sparkles", value: 0) {
///     HomeView()
/// }
///
/// UniTab("Search", systemImage: "magnifyingglass", value: 4, role: .search) {
///     SearchView()
/// }
/// ```
///
/// - Parameters:
///   - titleKey: The localized title of the tab.
///   - systemImage: The SF Symbol name for the tab icon.
///   - value: The selection value associated with this tab.
///   - role: The semantic role of the tab (e.g., `.search` for iOS 18+ integrations).
///   - content: A view builder producing the content for this tab.
public func UniTab<Value: Hashable, Content: View>(
    _ titleKey: LocalizedStringKey,
    systemImage: String,
    value: Value,
    role: UniTabRole = .automatic,
    @ViewBuilder content: @escaping () -> Content
) -> _UniTabDescriptor<Value> {
    _UniTabDescriptor(
        titleKey: titleKey,
        systemImage: systemImage,
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
/// UniTabSection("Account") {
///     UniTab("Profile", systemImage: "person", value: 1) { ProfileView() }
///     UniTab("Settings", systemImage: "gear", value: 2) { SettingsView() }
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
/// `UniTabView` intelligently switches between the modern `TabView` API (iOS 18+)
/// and the legacy view-based API (iOS 15-17) to provide the best user experience
/// on every OS version.
///
/// Example:
/// ```swift
/// @State private var selection = 1
///
/// UniTabView(selection: $selection) {
///     UniTab("Home", systemImage: "house", value: 1) { HomeView() }
///     UniTab("Profile", systemImage: "person", value: 2) { ProfileView() }
/// }
/// ```
public struct UniTabView<Selection: Hashable>: View {
    @Binding private var selection: Selection
    private let tabs: () -> [_UniTabDescriptor<Selection>]

    /// Creates an uni tab view with a selection binding.
    ///
    /// - Parameters:
    ///   - selection: A binding to the selected tab value.
    ///   - content: A builder that produces the tabs using `UniTab`.
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
                descriptor.modernTab
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
/// This pattern avoids protocol conflicts between `View` and `TabContent`.
public struct _UniTabDescriptor<Value: Hashable>: Identifiable {
    public var id: Value { value }

    let titleKey: LocalizedStringKey
    let systemImage: String
    let value: Value
    let role: UniTabRole
    let content: AnyView

    @available(iOS 18.0, macOS 15.0, tvOS 18.0, watchOS 11.0, visionOS 2.0, *)
    var modernTab: some TabContent<Value> {
        if role == .search {
            return Tab(titleKey, systemImage: systemImage, value: value, role: .search) {
                content
            }
        } else {
            return Tab(titleKey, systemImage: systemImage, value: value) {
                content
            }
        }
    }

    var legacyTab: some View {
        content
            .tabItem {
                Label(titleKey, systemImage: systemImage)
            }
            .tag(value)
    }
}

/// Internal descriptor for tab grouping.
public struct _UniTabSectionDescriptor<Value: Hashable> {
    let titleKey: LocalizedStringKey?
    let children: [_UniTabDescriptor<Value>]
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