import SwiftUI
import XCTest

@testable import UniSwiftUi

final class PickersSmokeTests: XCTestCase {
    @MainActor
    func testPickersContractsCompile() {
        _ = PickersSmokeView()
    }
}

private struct PickersSmokeView: View {
    @State private var selection = 1
    var body: some View {
        VStack {
            UniPicker("Mode", selection: $selection) {
                Text("A").tag(1)
                Text("B").tag(2)
            }
            .uniPickerStyle(.menu)

            UniPicker("Radio", selection: $selection) {
                Text("1").tag(1)
                Text("2").tag(2)
            }
            .uniPickerStyle(.radioGroup)
            .uniHorizontalRadioGroupLayout()

            UniValueLabelPicker(selection: $selection) {
                Text("X").tag(1)
            } label: {
                Text("Picker")
            } currentValueLabel: {
                Text("Value: \(selection)")
            }
        }
        .uniDefaultWheelPickerItemHeight(44)
    }
}
