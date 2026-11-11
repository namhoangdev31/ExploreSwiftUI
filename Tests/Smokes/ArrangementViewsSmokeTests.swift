import SwiftUI
import XCTest

@testable import ExploreSwiftUI

final class ArrangementViewsSmokeTests: XCTestCase {
    @MainActor
    func testArrangementViewsContractsCompile() {
        _ = ArrangementViewsSmokeView()
    }
}

private struct ArrangementViewsSmokeView: View {
    @State private var currentHinge: UniDeviceHinge? = nil
    @Environment(\.uniOverlayArrangementZIndex) private var zIndex
    @Environment(\.uniSplitArrangementAxis) private var splitAxis

    var body: some View {
        VStack {
            UniArrangementView {
                Color.blue
                    .uniOverlayArrangementEdge(.trailing)
                    .uniOverlayArrangementEdge(HorizontalEdge.leading)
                    .uniOverlayArrangementEdge(VerticalEdge.top)
            } secondary: {
                Color.orange
                    .uniSplitArrangementLayoutRatio(0.24)
                    .uniSplitArrangementLayoutRatio(minHorizontal: 0.2, idealHorizontal: 0.4, maxHorizontal: 0.8)
                    .uniSplitArrangementLayoutSize(minWidth: 100, idealWidth: 200, maxWidth: 300)
                    .uniSplitArrangementFixedLayoutSize(horizontal: true, vertical: false)
            }
            .uniArrangementViewStyle(.splitVertical)

            UniArrangementView {
                Text("ZIndex: \(zIndex), axis: \(String(describing: splitAxis))")
            } secondary: {
                Text("Secondary")
            }
            .uniArrangementViewStyle(.overlay)

            GeometryReader { proxy in
                ZStack {
                    ForEach(proxy.uniReservedRegions(kind: .division)) { region in
                        Rectangle()
                            .fill(Color.purple)
                            .frame(width: region.frame.width, height: region.frame.height)
                    }
                    let _ = proxy.uniContentMargins(for: .container)
                }
            }
            .uniOnHingeChange { _, newContext in
                currentHinge = newContext.hinge
            }
            .uniOnHingeChange(isEnabled: true) { hinge in
                currentHinge = hinge
            }
        }
    }
}
