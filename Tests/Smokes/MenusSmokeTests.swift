import SwiftUI
import XCTest

@testable import UniSwiftUi

final class MenusSmokeTests: XCTestCase {
    @MainActor
    func testMenusContractsCompile() {
        _ = MenusSmokeView()
    }
}

private struct MenusSmokeView: View {
    var body: some View {
        VStack {
            UniMenuActionButton {
                Button("1") {}
                Section("2") {
                    Button("Nested") {}
                }
                Divider()
                Button("3") {}
            } label: {
                Text("Menu")
            } primaryAction: {
                print("Primary")
            }
            .uniMenuOrder(.fixed)

            Text("Context")
                .uniContextMenu {
                    Button("Edit") {}
                } preview: {
                    Text("Preview")
                }
        }
    }
}
