import SwiftUI

#if canImport(UIKit)
    import UIKit
#endif

#if canImport(AppKit)
    import AppKit
#endif

// MARK: - Uni Link

/// A control for navigating to a URL with platform-specific handling and legacy OS fallbacks.
///
/// `UniLink` provides a unified way to open URLs:
/// - **Modern OS (iOS 14+, macOS 11+)**: Leverages the native `Link` component.
/// - **Legacy Fallback (iOS 13)**: Uses a `Button` that triggers `UIApplication.shared.open`
///   or `NSWorkspace.shared.open` to ensure navigation works on older systems.
///
/// Example:
/// ```swift
/// UniLink("Visit Website", destination: URL(string: "https://apple.com")!)
/// ```
public struct UniLink<Label: View>: View {
    let url: URL
    let label: () -> Label

    /// Creates an uni link with a custom label view.
    public init(destination: URL, @ViewBuilder label: @escaping () -> Label) {
        self.url = destination
        self.label = label
    }

    /// Creates an uni link with a localized title key.
    public init(_ titleKey: LocalizedStringKey, destination: URL) where Label == Text {
        self.url = destination
        self.label = { Text(titleKey) }
    }

    /// Creates an uni link with a string title.
    public init<S: StringProtocol>(_ title: S, destination: URL) where Label == Text {
        self.url = destination
        self.label = { Text(title) }
    }

    public var body: some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
            if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *) {
                Link(destination: url, label: label)
            } else {
                Button(action: openURL) {
                    label()
                }
            }
        #else
            Button(action: openURL) {
                label()
            }
        #endif
    }

    private func openURL() {
        #if canImport(UIKit) && !os(watchOS)
            UIApplication.shared.open(url)
        #elseif canImport(AppKit)
            NSWorkspace.shared.open(url)
        #endif
    }
}



// MARK: - Uni HelpLink

/// A button that opens app-specific help documentation.
///
/// `UniHelpLink` provides access to help resources:
/// - **macOS 14+**: Uses the native `HelpLink` for consistent system behavior.
/// - **Other Platforms**: Falls back to a standard button with a question mark icon
///   that executes the provided help action.
///
/// Example:
/// ```swift
/// UniHelpLink {
///     openHelpDocumentation()
/// }
/// ```
public struct UniHelpLink<Label: View>: View {
    let action: () -> Void
    let label: () -> Label

    /// Creates a help link with a custom label view.
    public init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    /// Creates a help link with a default question mark icon.
    public init(action: @escaping () -> Void) where Label == Image {
        self.action = action
        self.label = { Image(systemName: "questionmark.circle") }
    }

    public var body: some View {
        #if os(macOS)
            if #available(macOS 14.0, *) {
                HelpLink(action: action)
            } else {
                Button(action: action) { label() }
            }
        #else
            Button(action: action) { label() }
        #endif
    }
}

// MARK: - Uni TextFieldLink

/// A control that requests text input from the user when pressed.
///
/// `UniTextFieldLink` bridges the gap for specialized input controls:
/// - **watchOS 9+**: Uses the native `TextFieldLink`.
/// - **Other Platforms**: Polyfills via a standard button that presents a sheet
///   containing a `Form` and `TextField` for consistent input gathering.
///
/// Example:
/// ```swift
/// UniTextFieldLink("Enter Name", prompt: Text("Full Name")) { name in
///     save(name)
/// }
/// ```
public struct UniTextFieldLink<Label: View>: View {
    let title: String
    let prompt: Text?
    let onSubmit: (String) -> Void
    let label: () -> Label

    @State private var isPresented = false
    @State private var text = ""

    /// Creates a text field link with custom label and prompt.
    public init(
        _ title: String, prompt: Text? = nil, onSubmit: @escaping (String) -> Void,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.title = title
        self.prompt = prompt
        self.onSubmit = onSubmit
        self.label = label
    }

    /// Creates a text field link with a string title.
    public init(_ title: String, prompt: Text? = nil, onSubmit: @escaping (String) -> Void)
    where Label == Text {
        self.title = title
        self.prompt = prompt
        self.onSubmit = onSubmit
        self.label = { Text(title) }
    }

    public var body: some View {
        #if os(watchOS)
            if #available(watchOS 9.0, *) {
                TextFieldLink(title, prompt: prompt) { str in
                    onSubmit(str)
                } label: {
                    label()
                }
            } else {
                fallbackButton
            }
        #else
            fallbackButton
        #endif
    }

    private var fallbackButton: some View {
        Button {
            isPresented = true
        } label: {
            label()
        }
        .sheet(isPresented: $isPresented) {
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
                NavigationView {
                    Form {
                        TextField(title, text: $text)
                    }
                    .navigationTitle(title)
                    #if os(iOS) || os(macOS)
                        .toolbar {
                            ToolbarItem(placement: .confirmationAction) {
                                Button("Done") {
                                    onSubmit(text)
                                    isPresented = false
                                }
                            }
                        }
                    #endif
                }
            #endif
        }
    }
}
