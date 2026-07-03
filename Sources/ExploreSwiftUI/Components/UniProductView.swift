import SwiftUI

#if canImport(StoreKit)
import StoreKit
#endif

/// A unified view for product merchandising, supporting StoreKit's `ProductView` where available.
///
/// `UniProductView` handles product loading and checkout, mapping to the native `ProductView`
/// on iOS 17.0+ / macOS 14.0+ and falling back to a clean mock interface on older systems.
///
/// Example:
/// ```swift
/// UniProductView(id: "auto_renewable_subscription_1")
///     .uniProductViewStyle(.compact)
///
/// UniProductView(id: "auto_renewable_subscription_1") {
///     Image(systemName: "star")
/// } placeholderIcon: {
///     ProgressView()
/// }
/// ```
public struct UniProductView<Icon: View, PlaceholderIcon: View>: View {
    private let id: String
    private let prefersPromotionalIcon: Bool
    private let icon: () -> Icon
    private let placeholderIcon: () -> PlaceholderIcon
    private let hasCustomIcon: Bool
    private let hasCustomPlaceholder: Bool

    @Environment(\.uniProductViewStyle) private var style

    /// Creates an instance that loads and merchandises a product.
    public init(
        id: String,
        prefersPromotionalIcon: Bool = false
    ) where Icon == EmptyView, PlaceholderIcon == EmptyView {
        self.id = id
        self.prefersPromotionalIcon = prefersPromotionalIcon
        self.icon = { EmptyView() }
        self.placeholderIcon = { EmptyView() }
        self.hasCustomIcon = false
        self.hasCustomPlaceholder = false
    }

    /// Creates an instance that loads and merchandises a product with a custom icon.
    public init(
        id: String,
        prefersPromotionalIcon: Bool = false,
        @ViewBuilder icon: @escaping () -> Icon
    ) where PlaceholderIcon == EmptyView {
        self.id = id
        self.prefersPromotionalIcon = prefersPromotionalIcon
        self.icon = icon
        self.placeholderIcon = { EmptyView() }
        self.hasCustomIcon = true
        self.hasCustomPlaceholder = false
    }

    /// Creates an instance that loads and merchandises a product with a custom icon and placeholder icon.
    public init(
        id: String,
        prefersPromotionalIcon: Bool = false,
        @ViewBuilder icon: @escaping () -> Icon,
        @ViewBuilder placeholderIcon: @escaping () -> PlaceholderIcon
    ) {
        self.id = id
        self.prefersPromotionalIcon = prefersPromotionalIcon
        self.icon = icon
        self.placeholderIcon = placeholderIcon
        self.hasCustomIcon = true
        self.hasCustomPlaceholder = true
    }

    public var body: some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
            #if canImport(StoreKit)
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                    Group {
                        if hasCustomIcon {
                            if hasCustomPlaceholder {
                                ProductView(id: id, prefersPromotionalIcon: prefersPromotionalIcon) {
                                    icon()
                                } placeholderIcon: {
                                    placeholderIcon()
                                }
                            } else {
                                ProductView(id: id, prefersPromotionalIcon: prefersPromotionalIcon) {
                                    icon()
                                }
                            }
                        } else {
                            ProductView(id: id, prefersPromotionalIcon: prefersPromotionalIcon)
                        }
                    }
                    .if(style == .compact) {
                        $0.productViewStyle(.compact)
                    }
                    .if(style == .regular) {
                        $0.productViewStyle(.regular)
                    }
                    .if(style == .large) {
                        $0.productViewStyle(.large)
                    }
                    .if(style == .automatic) {
                        $0.productViewStyle(.automatic)
                    }
                } else {
                    fallbackView
                }
            #else
                fallbackView
            #endif
        #else
            fallbackView
        #endif
    }

    private var fallbackView: some View {
        HStack(spacing: 12) {
            if hasCustomIcon {
                icon()
            } else {
                Image(systemName: "tag.fill")
                    .foregroundColor(.blue)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text("Product Info")
                    .font(.headline)
                Text(id)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Button("Buy") {
                // Fallback purchase handler
            }
            .buttonStyle(.bordered)
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
        .cornerRadius(8)
    }
}
