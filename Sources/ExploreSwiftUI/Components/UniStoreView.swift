import SwiftUI
#if canImport(StoreKit)
import StoreKit
#endif

// MARK: - UniStoreProduct (Abstraction for Store Products)

/// A cross-platform abstraction representing an in-app product or subscription.
public struct UniStoreProduct: Identifiable, Sendable {
    public let id: String
    public let displayName: String
    public let displayPrice: String

    public init(id: String, displayName: String = "", displayPrice: String = "") {
        self.id = id
        self.displayName = displayName.isEmpty ? id : displayName
        self.displayPrice = displayPrice
    }
}

// MARK: - UniStoreView

/// A cross-platform view that displays and merchandises App Store products and in-app purchases.
///
/// On iOS 17+, macOS 14+, tvOS 17+, and visionOS 1+, `UniStoreView` wraps native StoreKit `StoreView`.
/// On older systems, it provides a high-fidelity fallback presentation.
///
/// Example:
/// ```swift
/// UniStoreView(ids: ["pro_yearly", "pro_lifetime"])
///     .uniStoreButton(.visible, for: .restorePurchases)
/// ```
public struct UniStoreView<CustomIcon: View, PlaceholderIcon: View>: View {
    private let ids: [String]
    private let prefersPromotionalIcon: Bool
    private let customIcon: ((UniStoreProduct) -> CustomIcon)?
    private let placeholderIcon: (() -> PlaceholderIcon)?

    public init(
        ids: [String],
        prefersPromotionalIcon: Bool = false
    ) where CustomIcon == EmptyView, PlaceholderIcon == EmptyView {
        self.ids = ids
        self.prefersPromotionalIcon = prefersPromotionalIcon
        self.customIcon = nil
        self.placeholderIcon = nil
    }

    public init(
        ids: [String],
        @ViewBuilder icon: @escaping (UniStoreProduct) -> CustomIcon
    ) where PlaceholderIcon == EmptyView {
        self.ids = ids
        self.prefersPromotionalIcon = false
        self.customIcon = icon
        self.placeholderIcon = nil
    }

    public init(
        ids: [String],
        @ViewBuilder icon: @escaping (UniStoreProduct) -> CustomIcon,
        @ViewBuilder placeholderIcon: @escaping () -> PlaceholderIcon
    ) {
        self.ids = ids
        self.prefersPromotionalIcon = false
        self.customIcon = icon
        self.placeholderIcon = placeholderIcon
    }

    public var body: some View {
        Group {
            #if canImport(StoreKit)
                #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
                    if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                        #if !os(watchOS)
                            nativeStoreView
                        #else
                            fallbackStoreView
                        #endif
                    } else {
                        fallbackStoreView
                    }
                #else
                    fallbackStoreView
                #endif
            #else
                fallbackStoreView
            #endif
        }
    }

    #if canImport(StoreKit)
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
    @ViewBuilder
    private var nativeStoreView: some View {
        if let customIcon = customIcon {
            if let placeholder = placeholderIcon {
                StoreView(ids: ids) { product in
                    customIcon(UniStoreProduct(id: product.id, displayName: product.displayName, displayPrice: product.displayPrice))
                } placeholderIcon: {
                    placeholder()
                }
            } else {
                StoreView(ids: ids) { product in
                    customIcon(UniStoreProduct(id: product.id, displayName: product.displayName, displayPrice: product.displayPrice))
                }
            }
        } else {
            StoreView(ids: ids, prefersPromotionalIcon: prefersPromotionalIcon)
        }
    }
    #endif

    @ViewBuilder
    private var fallbackStoreView: some View {
        List {
            ForEach(ids, id: \.self) { id in
                HStack(spacing: 12) {
                    if let customIcon = customIcon {
                        customIcon(UniStoreProduct(id: id))
                    } else if let placeholder = placeholderIcon {
                        placeholder()
                    } else {
                        Image(systemName: "cart.fill")
                            .foregroundColor(.accentColor)
                    }

                    VStack(alignment: .leading, spacing: 4) {
                        Text(id)
                            .font(.headline)
                        Text("In-App Purchase")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }

                    Spacer()

                    Button("Buy") {}
                        .buttonStyle(.borderedProminent)
                }
                .padding(.vertical, 4)
            }
        }
    }
}

// MARK: - UniSubscriptionStoreView

/// A cross-platform view that loads and merchandises auto-renewable subscriptions.
///
/// On iOS 17+, macOS 14+, tvOS 17+, and visionOS 1+, `UniSubscriptionStoreView` leverages StoreKit's native view.
/// On earlier releases, it degrades gracefully to a standard subscription card list.
public struct UniSubscriptionStoreView<Header: View>: View {
    private let groupID: String?
    private let productIDs: [String]?
    private let visibleRelationships: UniSubscriptionRelationship
    private let header: (() -> Header)?

    public init(
        groupID: String,
        visibleRelationships: UniSubscriptionRelationship = .all
    ) where Header == EmptyView {
        self.groupID = groupID
        self.productIDs = nil
        self.visibleRelationships = visibleRelationships
        self.header = nil
    }

    public init(
        productIDs: [String]
    ) where Header == EmptyView {
        self.groupID = nil
        self.productIDs = productIDs
        self.visibleRelationships = .all
        self.header = nil
    }

    public init(
        groupID: String,
        @ViewBuilder header: @escaping () -> Header
    ) {
        self.groupID = groupID
        self.productIDs = nil
        self.visibleRelationships = .all
        self.header = header
    }

    public var body: some View {
        Group {
            #if canImport(StoreKit)
                #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
                    if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                        #if !os(watchOS)
                            nativeSubscriptionStoreView
                        #else
                            fallbackSubscriptionView
                        #endif
                    } else {
                        fallbackSubscriptionView
                    }
                #else
                    fallbackSubscriptionView
                #endif
            #else
                fallbackSubscriptionView
            #endif
        }
    }

    #if canImport(StoreKit)
    @available(iOS 17.0, macOS 14.0, tvOS 17.0, visionOS 1.0, *)
    @ViewBuilder
    private var nativeSubscriptionStoreView: some View {
        if let groupID = groupID {
            if let header = header {
                SubscriptionStoreView(groupID: groupID) {
                    header()
                }
            } else if visibleRelationships == .upgrade {
                SubscriptionStoreView(groupID: groupID, visibleRelationships: .upgrade)
            } else {
                SubscriptionStoreView(groupID: groupID)
            }
        } else if let productIDs = productIDs {
            SubscriptionStoreView(productIDs: productIDs)
        }
    }
    #endif

    @ViewBuilder
    private var fallbackSubscriptionView: some View {
        VStack(spacing: 16) {
            if let header = header {
                header()
            } else {
                VStack(spacing: 4) {
                    Text("Subscriptions")
                        .font(.title2.bold())
                    Text("Unlock all premium features")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .padding(.top)
            }

            let items = productIDs ?? [groupID ?? "subscription_tier"]
            ForEach(items, id: \.self) { item in
                HStack {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(item)
                            .font(.headline)
                        Text("Auto-renewable subscription")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Spacer()
                    Button("Subscribe") {}
                        .buttonStyle(.borderedProminent)
                }
                .padding()
                .background(Color.secondary.opacity(0.1))
                .cornerRadius(12)
            }
        }
        .padding()
    }
}
