import SwiftUI
import XCTest

@testable import UniSwiftUi

final class ProgressViewsSmokeTests: XCTestCase {
    @MainActor
    func testProgressViewsContractsCompile() {
        _ = ProgressViewsSmokeView()
    }
}

private struct ProgressViewsSmokeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 30) {
                Section("Indeterminate") {
                    UniProgressView("Loading...")
                        .uniProgressViewStyle(.circular)

                    UniProgressView {
                        Text("Custom Indeterminate")
                    }
                    .uniProgressViewStyle(.linear)
                }

                Section("Value-based") {
                    UniProgressView("Downloading", value: 0.6)
                        .uniProgressViewStyle(.linear)
                        .uniProgressTint(.blue)

                    UniProgressView(value: 0.3) {
                        Text("Circular Progress")
                    }
                    .uniProgressViewStyle(.circular)
                    .uniProgressTint(.orange)
                }

                Section("Timer-based") {
                    if #available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, *) {
                        UniProgressView(
                            timerInterval: DateInterval(
                                start: Date(), end: Date().addingTimeInterval(30)),
                            countsDown: true
                        ) {
                            Text("Countdown")
                        } currentValueLabel: {
                            Text("Time remaining")
                        }
                    }
                }
            }
            .padding()
        }
    }
}
