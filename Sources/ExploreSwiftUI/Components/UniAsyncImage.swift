import SwiftUI

#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

/// A unified view that loads and displays an image asynchronously.
///
/// `UniAsyncImage` bridges the advanced `AsyncImage` features (like `URLRequest` support
/// and custom `URLSession` injection) down to older OS versions.
///
/// Example:
/// ```swift
/// UniAsyncImage(url: URL(string: "https://example.com/image.png")) { phase in
///     if let image = phase.image {
///         image.resizable().aspectRatio(contentMode: .fit)
///     } else if phase.error != nil {
///         Color.red // error
///     } else {
///         Color.blue // placeholder
///     }
/// }
/// ```
public struct UniAsyncImage<Content: View>: View {
    enum Source {
        case url(URL?)
        case request(URLRequest)
    }

    private let source: Source
    private let scale: CGFloat
    private let transaction: Transaction
    private let content: (AsyncImagePhase) -> Content

    @Environment(\.uniAsyncImageURLSession) private var session

    /// Creates an instance that loads an image from the specified URL.
    public init(
        url: URL?,
        scale: CGFloat = 1,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.source = .url(url)
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    /// Creates an instance that loads an image from the specified URL request.
    public init(
        request: URLRequest,
        scale: CGFloat = 1,
        transaction: Transaction = Transaction(),
        @ViewBuilder content: @escaping (AsyncImagePhase) -> Content
    ) {
        self.source = .request(request)
        self.scale = scale
        self.transaction = transaction
        self.content = content
    }

    public var body: some View {
        Group {
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
                if #available(iOS 27.0, macOS 27.0, watchOS 27.0, tvOS 27.0, *) {
                    switch source {
                    case .url(let url):
                        AsyncImage(url: url, scale: scale, transaction: transaction, content: content)
                    case .request(let request):
                        AsyncImage(request: request, scale: scale, transaction: transaction, content: content)
                    }
                } else if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, *) {
                    switch source {
                    case .url(let url):
                        if session == nil {
                            AsyncImage(url: url, scale: scale, transaction: transaction, content: content)
                        } else {
                            CustomLoaderView(source: source, session: session ?? .shared, scale: scale, transaction: transaction, content: content)
                        }
                    case .request:
                        CustomLoaderView(source: source, session: session ?? .shared, scale: scale, transaction: transaction, content: content)
                    }
                } else {
                    fallbackView
                }
            #else
                fallbackView
            #endif
        }
    }

    private var fallbackView: some View {
        content(.empty)
    }
}

extension UniAsyncImage where Content == Image {
    /// Creates an instance that loads an image from the specified URL.
    public init(url: URL?, scale: CGFloat = 1) {
        self.init(url: url, scale: scale) { phase in
            if let image = phase.image {
                return image
            } else {
                #if canImport(UIKit)
                return Image(uiImage: UIImage())
                #elseif canImport(AppKit)
                return Image(nsImage: NSImage())
                #else
                return Image(systemName: "photo")
                #endif
            }
        }
    }

    /// Creates an instance that loads an image from the specified URL request.
    public init(request: URLRequest, scale: CGFloat = 1) {
        self.init(request: request, scale: scale) { phase in
            if let image = phase.image {
                return image
            } else {
                #if canImport(UIKit)
                return Image(uiImage: UIImage())
                #elseif canImport(AppKit)
                return Image(nsImage: NSImage())
                #else
                return Image(systemName: "photo")
                #endif
            }
        }
    }
}

extension UniAsyncImage {
    /// Creates an instance that loads an image from the specified URL and shows a placeholder until it finishes.
    public init<I: View, P: View>(
        url: URL?,
        scale: CGFloat = 1,
        @ViewBuilder content: @escaping (Image) -> I,
        @ViewBuilder placeholder: @escaping () -> P
    ) where Content == _ConditionalContent<I, P> {
        self.init(url: url, scale: scale) { phase in
            if let image = phase.image {
                content(image)
            } else {
                placeholder()
            }
        }
    }

    /// Creates an instance that loads an image from the specified URL request and shows a placeholder until it finishes.
    public init<I: View, P: View>(
        request: URLRequest,
        scale: CGFloat = 1,
        @ViewBuilder content: @escaping (Image) -> I,
        @ViewBuilder placeholder: @escaping () -> P
    ) where Content == _ConditionalContent<I, P> {
        self.init(request: request, scale: scale) { phase in
            if let image = phase.image {
                content(image)
            } else {
                placeholder()
            }
        }
    }
}

@available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *)
struct CustomLoaderView<Content: View>: View {
    let source: UniAsyncImage<Content>.Source
    let session: URLSession
    let scale: CGFloat
    let transaction: Transaction
    let content: (AsyncImagePhase) -> Content

    @State private var phase: AsyncImagePhase = .empty

    var body: some View {
        content(phase)
            .task(id: url) {
                await loadImage()
            }
    }

    private var url: URL? {
        switch source {
        case .url(let url): return url
        case .request(let request): return request.url
        }
    }

    private func loadImage() async {
        guard let url else {
            phase = .empty
            return
        }

        let request: URLRequest
        switch source {
        case .url:
            request = URLRequest(url: url)
        case .request(let req):
            request = req
        }

        phase = .empty

        do {
            let (data, _) = try await session.data(for: request)
            #if canImport(UIKit)
            if let uiImage = UIImage(data: data, scale: scale) {
                withAnimation(transaction.animation) {
                    phase = .success(Image(uiImage: uiImage))
                }
            } else {
                phase = .failure(URLError(.cannotDecodeContentData))
            }
            #elseif canImport(AppKit)
            if let nsImage = NSImage(data: data) {
                withAnimation(transaction.animation) {
                    phase = .success(Image(nsImage: nsImage))
                }
            } else {
                phase = .failure(URLError(.cannotDecodeContentData))
            }
            #else
            phase = .failure(URLError(.unknown))
            #endif
        } catch {
            withAnimation(transaction.animation) {
                phase = .failure(error)
            }
        }
    }
}
