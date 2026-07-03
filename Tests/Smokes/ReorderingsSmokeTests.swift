import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ReorderingsSmokeTests: XCTestCase {
    @MainActor
    func testReorderingsContractsCompile() {
        if #available(iOS 27.0, macOS 27.0, watchOS 27.0, *) {
            _ = ReorderingsSmokeView()
        }
    }
}

@available(iOS 27.0, macOS 27.0, watchOS 27.0, *)
private struct SmokeItem: Identifiable {
    let id: String
    let databaseID: String
    let name: String
}

@available(iOS 27.0, macOS 27.0, watchOS 27.0, *)
private struct SmokeSection: Identifiable {
    let id: String
    let name: String
    let items: [SmokeItem]
}

@available(iOS 27.0, macOS 27.0, watchOS 27.0, *)
private struct ReorderingsSmokeView: View {
    @State private var items: [SmokeItem] = []
    @State private var sections: [SmokeSection] = []

    var body: some View {
        VStack {
            // Test 1: uniReorderContainer(for:isEnabled:move:) & uniReorderable()
            VStack {
                ForEach(items) { item in
                    Text(item.name)
                }
                .uniReorderable()
            }
            .uniReorderContainer(for: SmokeItem.self) { difference in
                print(difference.sources)
            }

            // Test 2: uniReorderContainer(for:in:isEnabled:move:) & uniReorderable(collectionID:)
            List {
                ForEach(sections) { section in
                    Section(section.name) {
                        ForEach(section.items) { item in
                            Text(item.name)
                        }
                        .uniReorderable(collectionID: section.id)
                    }
                }
            }
            .uniReorderContainer(for: SmokeItem.self, in: String.self) { difference in
                print(difference.sources)
            }

            // Test 3: uniReorderContainer(for:itemID:isEnabled:move:)
            VStack {
                ForEach(items, id: \.databaseID) { item in
                    Text(item.name)
                }
                .uniReorderable()
            }
            .uniReorderContainer(for: SmokeItem.self, itemID: \.databaseID) { difference in
                print(difference.sources)
            }

            // Test 4: uniReorderContainer(for:itemID:in:isEnabled:move:)
            List {
                ForEach(sections) { section in
                    Section(section.name) {
                        ForEach(section.items, id: \.databaseID) { item in
                            Text(item.name)
                        }
                        .uniReorderable(collectionID: section.id)
                    }
                }
            }
            .uniReorderContainer(for: SmokeItem.self, itemID: \.databaseID, in: String.self) { difference in
                print(difference.sources)
            }
        }
    }
}
