import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ScrollViewsSmokeTests: XCTestCase {
    @MainActor
    func testScrollViewsContractsCompile() {
        _ = ScrollViewsSmokeView()
    }
}

private struct ScrollViewsSmokeView: View {
    var body: some View {
        UniScrollView {
            VStack {
                Text("A")
                Text("B")
            }
        }
        .uniScrollEdgeEffectStyle(.hard, for: .vertical)
    }
}
