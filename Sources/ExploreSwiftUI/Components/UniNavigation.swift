import SwiftUI

/// A uni layout component that dynamically bridges `NavigationStack` (iOS 16+) 
/// and `NavigationView` (iOS 15).
public struct UniNavigationStack<Root: View>: View {
    @ViewBuilder public var root: () -> Root
    
    public init(@ViewBuilder root: @escaping () -> Root) {
        self.root = root
    }
    
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationStack {
                root()
            }
        } else {
            #if os(macOS) || os(watchOS)
            NavigationView {
                root()
            }
            #else
            NavigationView {
                root()
            }
            .navigationViewStyle(.stack)
            #endif
        }
    }
}

/// A uni layout component that dynamically bridges `NavigationSplitView` (iOS 16+)
/// and `NavigationView` (iOS 15).
public struct UniNavigationSplitView<Sidebar: View, Detail: View>: View {
    @ViewBuilder public var sidebar: () -> Sidebar
    @ViewBuilder public var detail: () -> Detail
    
    public init(
        @ViewBuilder sidebar: @escaping () -> Sidebar,
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.sidebar = sidebar
        self.detail = detail
    }
    
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationSplitView {
                sidebar()
            } detail: {
                detail()
            }
        } else {
            NavigationView {
                sidebar()
                detail()
            }
        }
    }
}

/// A three-column uni layout component that dynamically bridges `NavigationSplitView` (iOS 16+)
/// and `NavigationView` (iOS 15).
public struct UniNavigationSplitView3<Sidebar: View, Content: View, Detail: View>: View {
    @ViewBuilder public var sidebar: () -> Sidebar
    @ViewBuilder public var content: () -> Content
    @ViewBuilder public var detail: () -> Detail
    
    public init(
        @ViewBuilder sidebar: @escaping () -> Sidebar,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder detail: @escaping () -> Detail
    ) {
        self.sidebar = sidebar
        self.content = content
        self.detail = detail
    }
    
    public var body: some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            NavigationSplitView {
                sidebar()
            } content: {
                content()
            } detail: {
                detail()
            }
        } else {
            NavigationView {
                sidebar()
                content()
                detail()
            }
        }
    }
}

extension View {
    
    /// Bridges `navigationDestination(isPresented:destination:)` on modern systems
    /// and falls back to a background `NavigationLink` on older systems.
    @ViewBuilder
    public func uniNavigationDestination<V: View>(
        isPresented: Binding<Bool>,
        @ViewBuilder destination: @escaping () -> V
    ) -> some View {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *) {
            self.navigationDestination(isPresented: isPresented, destination: destination)
        } else {
            self.background(
                NavigationLink(
                    destination: destination(),
                    isActive: isPresented,
                    label: { EmptyView() }
                )
                .hidden()
            )
        }
    }
    
    /// Bridges `navigationDestination(item:destination:)` on modern systems
    /// and falls back to a background `NavigationLink` on older systems.
    @ViewBuilder
    public func uniNavigationDestination<Item: Identifiable & Hashable, V: View>(
        item: Binding<Item?>,
        @ViewBuilder destination: @escaping (Item) -> V
    ) -> some View {
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
            self.navigationDestination(item: item, destination: destination)
        } else {
            let isActive = Binding<Bool>(
                get: { item.wrappedValue != nil },
                set: { if !$0 { item.wrappedValue = nil } }
            )
            self.background(
                Group {
                    if let unwrappedItem = item.wrappedValue {
                        NavigationLink(
                            destination: destination(unwrappedItem),
                            isActive: isActive,
                            label: { EmptyView() }
                        )
                        .hidden()
                    } else {
                        EmptyView()
                    }
                }
            )
        }
    }
}
