import SwiftUI
import XCTest

@testable import UniSwiftUi

final class GlassEffectContainersSmokeTests: XCTestCase {
    @MainActor
    func testGlassEffectContainersContractsCompile() {
        _ = GlassEffectContainersSmokeView()
    }
}

private struct GlassEffectContainersSmokeView: View {
    var body: some View {
        UniGlassEffectContainer {
            Text("Glass Content")
                .uniGlass()
        }
    }
}
