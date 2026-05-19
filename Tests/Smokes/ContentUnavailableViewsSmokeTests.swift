import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ContentUnavailableViewsSmokeTests: XCTestCase {
    @MainActor
    func testContentUnavailableViewsContractsCompile() {
        _ = ContentUnavailableViewsSmokeView()
    }
}

private struct ContentUnavailableViewsSmokeView: View {
    var body: some View {
        VStack {
            UniContentUnavailableView("No Results", systemImage: "magnifyingglass")
            UniContentUnavailableView.search(text: "Antigravity")
            UniContentUnavailableView("Empty", systemImage: "tray") {
                Button("Retry") {}
            }
        }
    }
}
