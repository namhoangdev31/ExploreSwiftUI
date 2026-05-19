import SwiftUI
import XCTest

@testable import UniSwiftUi

final class TabViewsSmokeTests: XCTestCase {
    @MainActor
    func testTabViewsContractsCompile() {
        _ = TabViewsSmokeView()
    }
}

private struct TabViewsSmokeView: View {
    @State private var selection = "home"
    @State private var customizationData = Data()

    var body: some View {
        if #available(iOS 18.0, macOS 15.0, tvOS 18.0, visionOS 2.0, watchOS 11.0, *) {
            TabView(selection: $selection) {
                // Individual Tab with Customization and Badges
                UniValueTab("Home", systemImage: "house", value: "home") {
                    HomeContentView()
                }
                .uniCustomizationID("tab.home")
                .uniTabBadge(5)

                // Grouped Tabs (TabSection) for Sidebar
                UniTabSection("Personal") {
                    UniValueTab(
                        "Search", systemImage: "magnifyingglass", value: "search", role: .search
                    ) {
                        Text("Search Screen")
                    }
                    .uniCustomizationID("tab.search")

                    UniValueTab("Profile", systemImage: "person", value: "profile") {
                        Text("User Profile")
                    }
                    .uniCustomizationID("tab.profile")
                    .uniTabBadge("New")
                }
            }
            .uniTabViewStyle(.sidebarAdaptable)
            .uniTabViewCustomization($customizationData)
            .uniTabViewSidebarHeader {
                Text("App Sidebar").font(.caption).bold().padding(.vertical, 4)
            }
            .uniTabViewSidebarFooter {
                Text("Build 1.0.0").font(.caption2).padding(.vertical, 4)
            }
            // Future-proofing iOS 26+ Liquid Glass features
            .uniTabViewBottomAccessory {
                HStack {
                    Image(systemName: "music.note")
                    Text("Now Playing: SwiftUI Rocks")
                    Spacer()
                    Button("Next") {}
                }
                .padding()
                .background(.ultraThinMaterial)
                .cornerRadius(12)
            }
            .uniTabBarMinimizeBehavior(.onScrollDown)
        } else {
            // Legacy Fallback for iOS 13-17
            TabView(selection: $selection) {
                Text("Home Screen Content")
                    .tabItem { Label("Home", systemImage: "house") }
                    .tag("home")

                Text("Profile Screen Content")
                    .tabItem { Label("Profile", systemImage: "person") }
                    .tag("profile")
            }
        }
    }
}

private struct HomeContentView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("Home View Content")
                    .font(.title)
                Text("Scroll down to test minimize behavior (iOS 26+)")
                    .foregroundColor(.secondary)

                ForEach(0..<50) { i in
                    Text("Data Row \(i)")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.secondary.opacity(0.1))
                        .cornerRadius(8)
                }
            }
            .padding()
        }
    }
}
