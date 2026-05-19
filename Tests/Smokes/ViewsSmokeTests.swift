import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ViewsSmokeTests: XCTestCase {
    @MainActor
    func testViewsContractsCompile() {
        _ = ViewsSmokeView()
    }
}

private struct ViewsSmokeView: View {
    var body: some View {
        Text("Surface")
            .uniControlSize(.mini)
            .uniContainerBackground(.thinMaterial, for: .navigation)
            .uniBackgroundExtensionEffect()
            .uniGlassEffect()
    }
}
