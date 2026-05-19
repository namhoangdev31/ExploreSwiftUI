import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ButtonsSmokeTests: XCTestCase {
    @MainActor
    func testButtonsContractsCompile() {
        _ = ButtonsSmokeView()
    }
}

private struct ButtonsSmokeView: View {
    var body: some View {
        VStack {
            UniButton("Fitted") {}
                .uniButtonStyle(.borderedProminent)
                .uniButtonSizing(.fitted)

            UniButton("Flexible") {}
                .uniButtonStyle(.glass)
                .uniButtonSizing(.flexible)

            UniButton("Cancel", role: .cancel) {}
                .uniButtonBorderShape(.capsule)

            UniButton("Close", systemImage: "xmark", role: .close) {}
                .uniButtonTint(.red)

            UniRoleButton(role: .confirm) {}
            UniRenameButton {}
            UniPasteButton { _ in }
            UniEditButton()
        }
    }
}
