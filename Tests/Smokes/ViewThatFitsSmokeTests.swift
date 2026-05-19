import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ViewThatFitsSmokeTests: XCTestCase {
    @MainActor
    func testViewThatFitsContractsCompile() {
        _ = ViewThatFitsSmokeView()
    }
}

private struct ViewThatFitsSmokeView: View {
    var body: some View {
        UniViewThatFits(axes: .horizontal) {
            Text("A very long text that may not fit in the current space")
            Text("A shorter text")
            Text("Fit")
        }
    }
}
