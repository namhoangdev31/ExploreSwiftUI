import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ProductViewsSmokeTests: XCTestCase {
    @MainActor
    func testProductViewsContractsCompile() {
        _ = ProductViewsSmokeView()
    }
}

private struct ProductViewsSmokeView: View {
    var body: some View {
        VStack {
            UniProductView(id: "com.example.subscription.yearly")
            
            UniProductView(id: "com.example.subscription.monthly") {
                Image(systemName: "cart")
            } placeholderIcon: {
                ProgressView()
            }
        }
        .uniProductViewStyle(.compact)
    }
}
