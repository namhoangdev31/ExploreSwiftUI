import SwiftUI
import XCTest

@testable import UniSwiftUi

final class AlertsSmokeTests: XCTestCase {
    @MainActor
    func testAlertsContractsCompile() {
        _ = AlertsSmokeView()
    }
}

private struct AlertsSmokeView: View {
    @State private var error: ActiveError? = nil
    @State private var activeItem: ActiveItem? = nil

    struct ActiveError: LocalizedError {
        var errorDescription: String? { "Sample Error" }
    }

    struct ActiveItem: Identifiable {
        let id = UUID()
        let name: String
    }

    var body: some View {
        Text("Alert Smoke Test")
            .uniAlert(error: $error) {
                Button("OK") {}
            }
            .uniAlert(error: $error, actions: { _ in
                Button("Retry") {}
                Button("Cancel", role: .cancel) {}
            }, message: { error in
                Text("Error Details: \(error.localizedDescription)")
            })
            .uniAlert("Item Details", item: $activeItem) { item in
                Button("Purchase \(item.name)") {}
            }
            .uniAlert("Item Custom Title", item: $activeItem, actions: { item in
                Button("Delete \(item.name)", role: .destructive) {}
            }, message: { item in
                Text("Are you sure you want to delete \(item.name)?")
            })
    }
}
