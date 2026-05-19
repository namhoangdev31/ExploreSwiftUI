import SwiftUI
import XCTest

@testable import UniSwiftUi

final class TextSmokeTests: XCTestCase {
    @MainActor
    func testTextContractsCompile() {
        _ = TextSmokeView()
    }
}

private struct TextSmokeView: View {
    var body: some View {
        VStack {
            UniFormattedText(1234.56, format: .currency(code: "USD"))
            UniFormattedText(0.42, format: .percent)
        }
    }
}
