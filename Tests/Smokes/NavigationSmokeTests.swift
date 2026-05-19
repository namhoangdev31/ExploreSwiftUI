import SwiftUI
import XCTest

@testable import UniSwiftUi

final class NavigationSmokeTests: XCTestCase {
    @MainActor
    func testNavigationContractsCompile() {
        _ = NavigationSmokeView()
    }
}

private struct NavigationSmokeView: View {
    var body: some View {
        NavigationStack {
            Text("Nav")
                .uniNavigationTitle("Title", subtitle: "Subtitle")
        }
    }
}
