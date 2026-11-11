import SwiftUI
import XCTest

@testable import ExploreSwiftUI

final class NavigationSmokeTests: XCTestCase {
    @MainActor
    func testNavigationContractsCompile() {
        _ = NavigationSmokeView()
    }
}

private struct NavigationSmokeView: View {
    @State private var compactColumn: UniPreferredCompactColumn = .detail

    var body: some View {
        VStack {
            NavigationStack {
                Text("Nav")
                    .uniNavigationTitle("Title", subtitle: "Subtitle")
            }
            .uniNavigationTransition(.crossFade)

            UniNavigationSplitView(preferredCompactColumn: $compactColumn) {
                Text("Sidebar")
                    .uniHideSidebarToggle()
            } detail: {
                Text("Detail")
            }

            UniNavigationSplitView3(preferredCompactColumn: $compactColumn) {
                Text("Sidebar 3")
            } content: {
                Text("Content 3")
            } detail: {
                Text("Detail 3")
            }
        }
    }
}
