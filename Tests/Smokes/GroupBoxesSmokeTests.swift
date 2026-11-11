import SwiftUI
import XCTest

@testable import ExploreSwiftUI

final class GroupBoxesSmokeTests: XCTestCase {
    @MainActor
    func testGroupBoxesContractsCompile() {
        _ = GroupBoxesSmokeView()
    }
}

private struct GroupBoxesSmokeView: View {
    var body: some View {
        VStack {
            UniGroupBox("Label") {
                Text("Content")
            }
            .uniGroupBoxBackgroundStyle(.thinMaterial)
        }
    }
}
