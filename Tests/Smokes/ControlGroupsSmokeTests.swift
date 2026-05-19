import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ControlGroupsSmokeTests: XCTestCase {
    @MainActor
    func testControlGroupsContractsCompile() {
        _ = ControlGroupsSmokeView()
    }
}

private struct ControlGroupsSmokeView: View {
    var body: some View {
        VStack {
            UniControlGroup {
                Button("1") {}
                Button("2") {}
            }
            .uniControlGroupStyle(.navigation)

            UniControlGroup("Palette", systemImage: "paintpalette") {
                Button("Red") {}
            }
            .uniControlGroupStyle(.palette)
        }
    }
}
