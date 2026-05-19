import SwiftUI
import XCTest

@testable import UniSwiftUi

final class DividersSmokeTests: XCTestCase {
    @MainActor
    func testDividersContractsCompile() {
        _ = DividersSmokeView()
    }
}

private struct DividersSmokeView: View {
    var body: some View {
        VStack {
            UniDivider()
                .uniDividerColor(.red)

            HStack {
                Text("Left")
                UniDivider()
                Text("Right")
            }
        }
    }
}
