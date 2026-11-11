import SwiftUI

/// A cross-platform toggle control that supports single bindings, multi-source collections,
/// and adaptive styling (`.switch`, `.button`, `.checkbox`).
///
/// `UniToggle` bridges modern SwiftUI toggle features (like multi-source binding on iOS 16+)
/// down to legacy OS versions (iOS 15, macOS 12, tvOS 15, watchOS 8, visionOS 1).
///
/// Example:
/// ```swift
/// UniToggle("Enable Notifications", isOn: $isEnabled)
///     .uniToggleStyle(.switch)
///
/// // Multi-source collection binding
/// UniToggle("Mark All Complete", sources: $items, isOn: \.isDone)
/// ```
public struct UniToggle<Label: View>: View {
    @Binding private var isOn: Bool
    private let label: Label

    @Environment(\.uniToggleStyle) private var toggleStyle

    // MARK: - Initializers with isOn Binding

    public init(isOn: Binding<Bool>, @ViewBuilder label: () -> Label) {
        self._isOn = isOn
        self.label = label()
    }

    public init(_ titleKey: LocalizedStringKey, isOn: Binding<Bool>) where Label == Text {
        self._isOn = isOn
        self.label = Text(titleKey)
    }

    public init<S: StringProtocol>(_ title: S, isOn: Binding<Bool>) where Label == Text {
        self._isOn = isOn
        self.label = Text(title)
    }

    public init(
        _ titleKey: LocalizedStringKey,
        systemImage: String,
        isOn: Binding<Bool>
    ) where Label == SwiftUI.Label<Text, Image> {
        self._isOn = isOn
        self.label = SwiftUI.Label(titleKey, systemImage: systemImage)
    }

    public init<S: StringProtocol>(
        _ title: S,
        systemImage: String,
        isOn: Binding<Bool>
    ) where Label == SwiftUI.Label<Text, Image> {
        self._isOn = isOn
        self.label = SwiftUI.Label(title, systemImage: systemImage)
    }

    public init(
        _ titleKey: LocalizedStringKey,
        image: Image,
        isOn: Binding<Bool>
    ) where Label == SwiftUI.Label<Text, Image> {
        self._isOn = isOn
        self.label = SwiftUI.Label { Text(titleKey) } icon: { image }
    }

    // MARK: - Multi-source Initializers (iOS 16+ Bridge)

    public init<C: MutableCollection & RandomAccessCollection>(
        _ titleKey: LocalizedStringKey,
        sources: Binding<C>,
        isOn keyPath: WritableKeyPath<C.Element, Bool>
    ) where Label == Text, C.Index: Hashable {
        let binding = Binding<Bool>(
            get: {
                sources.wrappedValue.isEmpty ? false : sources.wrappedValue.allSatisfy { $0[keyPath: keyPath] }
            },
            set: { newValue in
                for index in sources.wrappedValue.indices {
                    sources.wrappedValue[index][keyPath: keyPath] = newValue
                }
            }
        )
        self._isOn = binding
        self.label = Text(titleKey)
    }

    public init<C: MutableCollection & RandomAccessCollection, S: StringProtocol>(
        _ title: S,
        sources: Binding<C>,
        isOn keyPath: WritableKeyPath<C.Element, Bool>
    ) where Label == Text, C.Index: Hashable {
        let binding = Binding<Bool>(
            get: {
                sources.wrappedValue.isEmpty ? false : sources.wrappedValue.allSatisfy { $0[keyPath: keyPath] }
            },
            set: { newValue in
                for index in sources.wrappedValue.indices {
                    sources.wrappedValue[index][keyPath: keyPath] = newValue
                }
            }
        )
        self._isOn = binding
        self.label = Text(title)
    }

    public init<C: MutableCollection & RandomAccessCollection>(
        sources: Binding<C>,
        isOn keyPath: WritableKeyPath<C.Element, Bool>,
        @ViewBuilder label: () -> Label
    ) where C.Index: Hashable {
        let binding = Binding<Bool>(
            get: {
                sources.wrappedValue.isEmpty ? false : sources.wrappedValue.allSatisfy { $0[keyPath: keyPath] }
            },
            set: { newValue in
                for index in sources.wrappedValue.indices {
                    sources.wrappedValue[index][keyPath: keyPath] = newValue
                }
            }
        )
        self._isOn = binding
        self.label = label()
    }

    // MARK: - Body & Styling

    public var body: some View {
        Group {
            switch toggleStyle {
            case .automatic:
                Toggle(isOn: $isOn) { label }
            case .switch:
                #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
                    Toggle(isOn: $isOn) { label }
                        .toggleStyle(.switch)
                #elseif os(tvOS)
                    if #available(tvOS 18.0, *) {
                        Toggle(isOn: $isOn) { label }
                            .toggleStyle(.switch)
                    } else {
                        Toggle(isOn: $isOn) { label }
                    }
                #else
                    Toggle(isOn: $isOn) { label }
                #endif
            case .button:
                #if os(iOS) || os(macOS) || os(watchOS) || os(visionOS)
                    if #available(iOS 15.0, macOS 12.0, watchOS 9.0, visionOS 1.0, *) {
                        Toggle(isOn: $isOn) { label }
                            .toggleStyle(.button)
                    } else {
                        Toggle(isOn: $isOn) { label }
                    }
                #else
                    Toggle(isOn: $isOn) { label }
                #endif
            case .checkbox:
                #if os(macOS)
                    Toggle(isOn: $isOn) { label }
                        .toggleStyle(.checkbox)
                #else
                    // Checkbox style polyfill for iOS / watchOS / tvOS / visionOS
                    Button(action: { isOn.toggle() }) {
                        HStack(spacing: 8) {
                            Image(systemName: isOn ? "checkmark.square.fill" : "square")
                                .foregroundColor(isOn ? .accentColor : .secondary)
                            label
                        }
                    }
                    .buttonStyle(.plain)
                #endif
            }
        }
    }
}
