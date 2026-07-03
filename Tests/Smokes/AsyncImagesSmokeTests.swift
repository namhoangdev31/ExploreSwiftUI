import SwiftUI
import XCTest

@testable import UniSwiftUi

final class AsyncImagesSmokeTests: XCTestCase {
    @MainActor
    func testAsyncImagesContractsCompile() {
        _ = AsyncImagesSmokeView()
    }
}

private struct AsyncImagesSmokeView: View {
    let url = URL(string: "https://exploreswiftui.com/logo.png")!
    
    var body: some View {
        VStack {
            UniAsyncImage(url: url) { image in
                image.resizable().aspectRatio(contentMode: .fit)
            } placeholder: {
                ProgressView()
            }
            
            UniAsyncImage(url: url, scale: 2.0) { phase in
                if let image = phase.image {
                    image
                } else if phase.error != nil {
                    Color.red
                } else {
                    Color.blue
                }
            }
        }
        .uniAsyncImageURLSession(.shared)
    }
}
