import SwiftUI
import XCTest

@testable import UniSwiftUi

final class MaterialSmokeTests: XCTestCase {
    @MainActor
    func testMaterialContractsCompile() {
        _ = MaterialSmokeView()
    }
}

private struct MaterialSmokeView: View {
    var body: some View {
        VStack {
            Text("Background")
                .uniMaterialBackground(.thin, cornerRadius: 10)
        }
    }
}
