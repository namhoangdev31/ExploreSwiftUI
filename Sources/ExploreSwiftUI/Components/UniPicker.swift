import SwiftUI

/// A highly uni picker component that allows users to select from a set of mutually exclusive values.
///
/// `UniPicker` provides a unified API for pickers across all Apple platforms:
/// - **Modern OS**: Leverages the native `Picker` component and applies uni styles
///   like `.menu`, `.segmented`, or `.wheel`.
/// - **Value Label Support**: Includes built-in support for displaying the currently
///   selected value alongside the picker's label.
///
/// Example:
/// ```swift
/// UniPicker("Priority", selection: $priority, style: .segmented) {
///     Text("Low").tag(Priority.low)
///     Text("High").tag(Priority.high)
/// }
/// ```
public struct UniPicker<SelectionValue: Hashable, Content: View, Label: View>: View {
    private let selection: Binding<SelectionValue>
    private let style: UniPickerStyle
    private let content: () -> Content
    private let label: () -> Label
    private let currentValueLabel: AnyView?

    /// Creates an uni picker with custom label and content.
    ///
    /// - Parameters:
    ///   - selection: A binding to the selected value.
    ///   - style: The visual style to apply (e.g., `.wheel`, `.segmented`).
    ///   - content: A view builder describing the options in the picker.
    ///   - label: A view builder describing the picker's label.
    public init(
        selection: Binding<SelectionValue>,
        style: UniPickerStyle = .automatic,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping () -> Label
    ) {
        self.selection = selection
        self.style = style
        self.content = content
        self.label = label
        self.currentValueLabel = nil
    }

    /// Creates an uni picker with a custom current value label.
    public init<V: View>(
        selection: Binding<SelectionValue>,
        style: UniPickerStyle = .automatic,
        @ViewBuilder content: @escaping () -> Content,
        @ViewBuilder label: @escaping () -> Label,
        @ViewBuilder currentValueLabel: @escaping () -> V
    ) {
        self.selection = selection
        self.style = style
        self.content = content
        self.label = label
        self.currentValueLabel = AnyView(currentValueLabel())
    }

    // MARK: - Convenience Initializers

    /// Creates an uni picker with a localized title key.
    public init(
        _ titleKey: LocalizedStringKey,
        selection: Binding<SelectionValue>,
        style: UniPickerStyle = .automatic,
        @ViewBuilder content: @escaping () -> Content
    ) where Label == Text {
        self.init(
            selection: selection,
            style: style,
            content: content
        ) {
            Text(titleKey)
        }
    }

    /// Creates an uni picker with a title and a system image.
    public init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        selection: Binding<SelectionValue>,
        style: UniPickerStyle = .automatic,
        @ViewBuilder content: @escaping () -> Content
    ) where Label == SwiftUI.Label<Text, Image> {
        self.init(
            selection: selection,
            style: style,
            content: content
        ) {
            SwiftUI.Label(titleKey, systemImage: systemImage)
        }
    }

    public var body: some View {
        Group {
            if let currentValueLabel {
                UniValueLabelPicker(
                    selection: selection,
                    content: content,
                    label: label
                ) {
                    currentValueLabel
                }
            } else {
                Picker(selection: selection) {
                    content()
                } label: {
                    label()
                }
            }
        }
        .uniPickerStyle(style)
    }
}
