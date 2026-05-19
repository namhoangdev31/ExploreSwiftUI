import SwiftUI
import XCTest

@testable import UniSwiftUi

final class LabelsSmokeTests: XCTestCase {
    @MainActor
    func testLabelsContractsCompile() {
        _ = LabelsSmokeView()
    }
}

private struct LabelsSmokeView: View {
    var body: some View {
        VStack {
            UniLabel("Star", systemImage: "star")
            UniLabel("Gear") { Image(systemName: "gear") }
        }
    }
}
