import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ListsSmokeTests: XCTestCase {
    @MainActor
    func testListsContractsCompile() {
        _ = ListsSmokeView()
    }
}

private struct ListsSmokeView: View {
    struct Item: Identifiable {
        let id = UUID()
        let name: String
        let children: [Item]?
    }

    var body: some View {
        List {
            Section("Group") {
                Text("Row")
                    .uniListRowSeparator(.hidden)
                    .uniListRowBackground(Color.blue.opacity(0.1))
                    .uniSwipeActions { Button("Swipe") {} }
                    .uniBadge(1)
            }
            .uniSectionIndexLabel("S")
            .uniListSectionSeparator(.visible)

            UniDisclosureGroup("Disclosure") {
                Text("Nested")
            }

            UniOutlineGroup([Item(name: "A", children: nil)], children: \.children) { item in
                Text(item.name)
            }
        }
        .uniListStyle(.insetGrouped)
        .uniListRowSpacing(4)
        .uniListSectionSpacing(.compact)
        .uniRefreshable {}
        .uniListSectionIndexVisibility(.visible)
    }
}
