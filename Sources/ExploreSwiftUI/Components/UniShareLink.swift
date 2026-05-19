import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

#if canImport(AppKit)
    import AppKit
#endif

/// A container that represents a share preview.
public struct UniSharePreview: Sendable {
    public let title: String
    public let image: Image?

    /// Creates a share preview with a title and an optional image.
    public init(_ title: String, image: Image? = nil) {
        self.title = title
        self.image = image
    }
}

/// A view that controls a sharing presentation, adapting to the best native experience.
///
/// `UniShareLink` provides a modern sharing interface:
/// - **Modern OS (iOS 16+, macOS 13+)**: Uses the native `ShareLink` for the standard share sheet.
/// - **Legacy Fallback**: Polyfills using `UIActivityViewController` on iOS or
///   `NSSharingServicePicker` on macOS via a standard button and sheet mechanism.
///
/// Example:
/// ```swift
/// UniShareLink(item: URL(string: "https://apple.com")!) {
///     Label("Share Link", systemImage: "square.and.arrow.up")
/// }
/// 
/// // Sharing a String
/// UniShareLink(item: "Check out this awesome app!") {
///     Label("Share Text", systemImage: "square.and.arrow.up")
/// }
/// ```
public struct UniShareLink<Label: View>: View {
    let items: [Any]
    let subject: Text?
    let message: Text?
    let preview: UniSharePreview?
    let label: () -> Label

    @State private var isSharePresented = false

    /// Creates a share link for a URL with custom options and a label.
    public init(
        item: URL, subject: Text? = nil, message: Text? = nil, preview: UniSharePreview? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.items = [item]
        self.subject = subject
        self.message = message
        self.preview = preview
        self.label = label
    }

    /// Creates a share link for a String with custom options and a label.
    public init(
        item: String, subject: Text? = nil, message: Text? = nil, preview: UniSharePreview? = nil,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.items = [item]
        self.subject = subject
        self.message = message
        self.preview = preview
        self.label = label
    }

    /// Creates a share link for a URL with a localized title key.
    public init(_ titleKey: LocalizedStringKey, item: URL) where Label == Text {
        self.items = [item]
        self.subject = nil
        self.message = nil
        self.preview = nil
        self.label = { Text(titleKey) }
    }

    /// Creates a share link for a String with a localized title key.
    public init(_ titleKey: LocalizedStringKey, item: String) where Label == Text {
        self.items = [item]
        self.subject = nil
        self.message = nil
        self.preview = nil
        self.label = { Text(titleKey) }
    }

    public var body: some View {
        #if os(iOS) || os(macOS) || os(visionOS) || os(watchOS)
            if #available(iOS 16.0, macOS 13.0, watchOS 9.0, visionOS 1.0, *) {
                if let url = items.first as? URL {
                    if let uniPreview = preview {
                        let sharePreview = SharePreview(
                            uniPreview.title,
                            image: uniPreview.image ?? Image(systemName: "photo"))
                        ShareLink(
                            item: url, subject: subject, message: message, preview: sharePreview,
                            label: label)
                    } else {
                        ShareLink(item: url, subject: subject, message: message, label: label)
                    }
                } else if let string = items.first as? String {
                    if let uniPreview = preview {
                        let sharePreview = SharePreview(
                            uniPreview.title,
                            image: uniPreview.image ?? Image(systemName: "photo"))
                        ShareLink(
                            item: string, subject: subject, message: message, preview: sharePreview,
                            label: label)
                    } else {
                        ShareLink(item: string, subject: subject, message: message, label: label)
                    }
                } else {
                    fallbackButton
                }
            } else {
                fallbackButton
            }
        #else
            fallbackButton
        #endif
    }

    private var fallbackButton: some View {
        Button(action: {
            #if os(iOS) || os(visionOS)
                isSharePresented = true
            #elseif os(macOS)
                // macOS fallback using NSSharingServicePicker
                #if canImport(AppKit)
                    let picker = NSSharingServicePicker(items: items)
                    picker.show(
                        relativeTo: .zero, of: NSApp.keyWindow!.contentView!, preferredEdge: .minY)
                #endif
            #endif
        }) {
            label()
        }
        #if os(iOS) || os(visionOS)
            .sheet(isPresented: $isSharePresented) {
                ActivityView(activityItems: items)
            }
        #endif
    }
}

#if os(iOS) || os(visionOS)
    private struct ActivityView: UIViewControllerRepresentable {
        let activityItems: [Any]

        func makeUIViewController(context: Context) -> UIActivityViewController {
            let controller = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
            return controller
        }

        func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context)
        {}
    }
#endif
