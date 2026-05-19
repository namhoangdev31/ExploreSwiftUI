import SwiftUI
import XCTest

@testable import UniSwiftUi

final class SheetsSmokeTests: XCTestCase {
    @MainActor
    func testSheetsContractsCompile() {
        _ = SheetsSmokeView()
    }
}

private struct SheetsSmokeView: View {
    @State private var isBasicPresented = false
    @State private var isAdvancedPresented = false
    @State private var selectedDetent: UniPresentationDetent = .medium

    var body: some View {
        List {
            Section("Basic Sheet") {
                Button("Open Sheet (Detents & Background)") {
                    isBasicPresented = true
                }
                .sheet(isPresented: $isBasicPresented) {
                    VStack(spacing: 20) {
                        Text("Uni Sheet")
                            .font(.headline)
                        Text("Current Detent: \(selectedDetent == .medium ? "Medium" : "Large")")
                        Button("Close") { isBasicPresented = false }
                    }
                    .uniPresentationDetents([.medium, .large], selection: $selectedDetent)
                    .uniPresentationBackground(.ultraThinMaterial)
                    .uniPresentationDragIndicator(.visible)
                }
            }

            Section("Advanced Sheet") {
                Button("Open Sheet (Interaction & Sizing)") {
                    isAdvancedPresented = true
                }
                .sheet(isPresented: $isAdvancedPresented) {
                    ScrollView {
                        VStack(spacing: 20) {
                            Text("Advanced Features")
                                .font(.headline)

                            ForEach(0..<20) { i in
                                Text("Scrollable Item \(i)")
                            }

                            Button("Close") { isAdvancedPresented = false }
                                .padding()
                        }
                    }
                    .padding()
                    // Sizing (iOS 18+)
                    .uniPresentationSizing(.fitted)
                    // Visuals
                    .uniPresentationCornerRadius(32)
                    // Interactions
                    .uniPresentationContentInteraction(.scrolls)
                    .uniPresentationBackgroundInteraction(.enabledUpThrough(.medium))
                    .uniInteractiveDismissDisabled(false)
                }
            }
        }
    }
}
