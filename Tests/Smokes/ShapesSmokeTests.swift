import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ShapesSmokeTests: XCTestCase {
    @MainActor
    func testShapesContractsCompile() {
        _ = ShapesSmokeView()
    }
}

private struct ShapesSmokeView: View {
    var body: some View {
        UniShape()
            .uniShapeTint(.blue)
    }
}
