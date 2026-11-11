import SwiftUI
import XCTest

@testable import ExploreSwiftUI

final class StoreViewsSmokeTests: XCTestCase {
    @MainActor
    func testStoreViewsContractsCompile() {
        _ = StoreViewsSmokeView()
    }
}

private struct StoreViewsSmokeView: View {
    @State private var showManageSubscriptions = false
    @State private var showAppStoreOverlay = false

    var body: some View {
        VStack {
            UniStoreView(ids: ["pro_sub_1", "pro_sub_2"])
                .uniStoreButton(.visible, for: .restorePurchases)
                .uniStoreButton(.hidden, for: .cancellation)

            UniStoreView(ids: ["product_1"]) { product in
                Image(systemName: "star.fill")
            } placeholderIcon: {
                ProgressView()
            }

            UniSubscriptionStoreView(groupID: "group_123")

            UniSubscriptionStoreView(productIDs: ["sub_a", "sub_b"])

            UniSubscriptionStoreView(groupID: "group_456", visibleRelationships: .upgrade)

            UniSubscriptionStoreView(groupID: "group_789") {
                Text("Custom Marketing Header")
            }

            Button("Manage Subscriptions") {
                showManageSubscriptions = true
            }
            .uniManageSubscriptionsSheet(isPresented: $showManageSubscriptions)
            .uniAppStoreOverlay(isPresented: $showAppStoreOverlay, appIdentifier: "123456789")
        }
    }
}
