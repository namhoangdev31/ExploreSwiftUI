import SwiftUI
import XCTest

@testable import ExploreSwiftUI

final class ViewsSmokeTests: XCTestCase {
    @MainActor
    func testViewsContractsCompile() {
        _ = ViewsSmokeView()
    }
}

private struct ViewsSmokeView: View {
    @Environment(\.uniToolbarVerticalEdge) private var verticalEdge
    @Environment(\.uniSystemPrefersReducedResourceUsage) private var lowResource
    @Environment(\.uniIsTabViewSidebarAvailable) private var sidebarAvailable
    @Environment(\.uniAccessibilityPrefersCrossFadeTransitions) private var crossFade
    @Environment(\.uniAccessibilityReduceHighlightingEffects) private var reduceHighlight

    var body: some View {
        VStack {
            Text("Surface: \(lowResource), \(sidebarAvailable), \(crossFade), \(reduceHighlight)")
                .uniControlSize(.mini)
                .uniContainerBackground(.thinMaterial, for: .navigation)
                .uniBackgroundExtensionEffect()
                .uniGlassEffect()
                .uniToolbarVerticalBehavior(.disabled)
                .uniContentMargins(for: .container)

            GeometryReader { proxy in
                let margins = proxy.uniContentMargins(for: .container)
                Text("Margins: \(margins.top)")
            }
        }
    }
}
