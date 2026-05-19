import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ToolbarsSmokeTests: XCTestCase {
    @MainActor
    func testToolbarsContractsCompile() {
        if #available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *) {
            _ = ToolbarsSmokeView()
        }
    }
}

@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, visionOS 1.0, *)
private struct ToolbarsSmokeView: View {
    var body: some View {
        NavigationStack {
            VStack {
                Text("Smoke Test Content")
            }
            #if !os(tvOS) && !os(watchOS)
                .uniNavigationSubtitle("Uni Subtitle")
            #endif
            .toolbar {
                ToolbarItem(placement: .uni(.title)) {
                    Text("Title")
                }

                UniToolbarSpacer(.flexible)

                ToolbarItem(placement: .uni(.subtitle)) {
                    Text("Sub")
                }

                ToolbarItemGroup {
                    Button("Action A") {}
                    Button("Action B") {}
                }

                UniToolbarSpacer(.fixed, fallbackLength: 12)

                #if !os(tvOS) && !os(watchOS)
                    ToolbarItem {
                        Button("Shared") {}
                    }
                    .uniSharedBackgroundVisibility(.visible)
                #endif
            }
        }
    }
}
