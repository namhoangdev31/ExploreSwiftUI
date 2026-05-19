import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ColorsSmokeTests: XCTestCase {
    @MainActor
    func testColorsContractsCompile() {
        _ = ColorsSmokeView()
    }
}

private struct ColorsSmokeView: View {
    var body: some View {
        VStack {
            Rectangle()
                .fill(UniColor.systemFill)
                .frame(width: 50, height: 50)

            Text("Primary")
                .uniForegroundStyle(.blue, hierarchy: .primary)

            Text("Secondary Gradient")
                .uniForegroundStyle(.blue, gradient: true, hierarchy: .secondary)

            Text("Tertiary")
                .uniForegroundStyle(.orange, hierarchy: .tertiary, opacity: 0.8)

            Text("Quaternary")
                .uniForegroundStyle(.green, hierarchy: .quaternary)
        }
    }
}
