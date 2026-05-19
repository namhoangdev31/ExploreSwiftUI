import SwiftUI
import XCTest

@testable import UniSwiftUi

final class GaugesSmokeTests: XCTestCase {
    @MainActor
    func testGaugesContractsCompile() {
        _ = GaugesSmokeView()
    }
}

private struct GaugesSmokeView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                UniGauge(value: 0.75) {
                    Text("Accessory Linear")
                }
                .uniGaugeStyle(.accessoryLinear)
                .uniGaugeTint(.blue)

                UniGauge(value: 0.5, in: 0...1) {
                    Text("Accessory Circular")
                } currentValueLabel: {
                    Text("50%")
                } minimumValueLabel: {
                    Text("0")
                } maximumValueLabel: {
                    Text("100")
                }
                .uniGaugeStyle(.accessoryCircularCapacity)

                UniGauge(value: 0.3) {
                    Text("Automatic")
                }
                .uniGaugeStyle(.automatic)

                UniGauge(value: 0.6) {
                    Text("Linear")
                }
                .uniGaugeStyle(.linear)

                UniGauge(value: 0.4) {
                    Text("Circular")
                }
                .uniGaugeStyle(.circular)
            }
            .padding()
        }
    }
}
