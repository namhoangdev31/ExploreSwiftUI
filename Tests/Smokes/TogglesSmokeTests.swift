import SwiftUI
import XCTest

@testable import ExploreSwiftUI

final class TogglesSmokeTests: XCTestCase {
    @MainActor
    func testTogglesContractsCompile() {
        _ = TogglesSmokeView()
    }
}

private struct TogglesSmokeView: View {
    @State private var isOn = false
    @State private var items = [
        ToggleItem(id: 1, isChecked: true),
        ToggleItem(id: 2, isChecked: false)
    ]

    var body: some View {
        VStack {
            UniToggle("Basic Toggle", isOn: $isOn)
                .uniToggleStyle(.switch)

            UniToggle("Button Toggle", systemImage: "star", isOn: $isOn)
                .uniToggleStyle(.button)

            UniToggle("Checkbox Toggle", isOn: $isOn)
                .uniToggleStyle(.checkbox)

            UniToggle("Multi Source Toggle", sources: $items, isOn: \.isChecked)

            UniToggle(isOn: $isOn) {
                HStack {
                    Image(systemName: "bell")
                    Text("Custom Label")
                }
            }
        }
    }
}

private struct ToggleItem: Identifiable {
    let id: Int
    var isChecked: Bool
}
