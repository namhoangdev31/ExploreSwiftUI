import SwiftUI

extension View {
    
    // MARK: - Alert
    
    /// Presents a unified alert with a title, message, and actions.
    ///
    /// Example:
    /// ```swift
    /// .uniAlert("Delete File", isPresented: $showAlert) {
    ///     Button("Delete", role: .destructive) { }
    ///     Button("Cancel", role: .cancel) { }
    /// } message: {
    ///     Text("Are you sure you want to delete this file?")
    /// }
    /// ```
    @ViewBuilder
    public func uniAlert<A: View, M: View>(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A,
        @ViewBuilder message: () -> M
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            self.alert(titleKey, isPresented: isPresented, actions: actions, message: message)
        } else {
            self.alert(isPresented: isPresented) {
                Alert(title: Text(titleKey))
            }
        }
    }

    /// Presents a unified alert with a title and actions.
    @ViewBuilder
    public func uniAlert<A: View>(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            self.alert(titleKey, isPresented: isPresented, actions: actions)
        } else {
            self.alert(isPresented: isPresented) {
                Alert(title: Text(titleKey))
            }
        }
    }
    
    /// Presents a unified alert with a string title, message, and actions.
    @ViewBuilder
    public func uniAlert<S: StringProtocol, A: View, M: View>(
        _ title: S,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A,
        @ViewBuilder message: () -> M
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            self.alert(title, isPresented: isPresented, actions: actions, message: message)
        } else {
            self.alert(isPresented: isPresented) {
                Alert(title: Text(title))
            }
        }
    }

    /// Presents a unified alert with a string title and actions.
    @ViewBuilder
    public func uniAlert<S: StringProtocol, A: View>(
        _ title: S,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            self.alert(title, isPresented: isPresented, actions: actions)
        } else {
            self.alert(isPresented: isPresented) {
                Alert(title: Text(title))
            }
        }
    }

    // MARK: - Confirmation Dialog
    
    /// Presents a unified confirmation dialog with a title, message, and actions.
    ///
    /// Example:
    /// ```swift
    /// .uniConfirmationDialog("Select Photo", isPresented: $showDialog) {
    ///     Button("Take Photo") { }
    ///     Button("Choose from Library") { }
    ///     Button("Cancel", role: .cancel) { }
    /// } message: {
    ///     Text("Choose a source for your photo.")
    /// }
    /// ```
    @ViewBuilder
    public func uniConfirmationDialog<A: View, M: View>(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A,
        @ViewBuilder message: () -> M
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            self.confirmationDialog(titleKey, isPresented: isPresented, actions: actions, message: message)
        } else {
            #if os(iOS) || os(tvOS) || os(watchOS)
            self.actionSheet(isPresented: isPresented) {
                ActionSheet(title: Text(titleKey))
            }
            #else
            self
            #endif
        }
    }

    /// Presents a unified confirmation dialog with a title and actions.
    @ViewBuilder
    public func uniConfirmationDialog<A: View>(
        _ titleKey: LocalizedStringKey,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            self.confirmationDialog(titleKey, isPresented: isPresented, actions: actions)
        } else {
            #if os(iOS) || os(tvOS) || os(watchOS)
            self.actionSheet(isPresented: isPresented) {
                ActionSheet(title: Text(titleKey))
            }
            #else
            self
            #endif
        }
    }
    
    /// Presents a unified confirmation dialog with a string title, message, and actions.
    @ViewBuilder
    public func uniConfirmationDialog<S: StringProtocol, A: View, M: View>(
        _ title: S,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A,
        @ViewBuilder message: () -> M
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            self.confirmationDialog(title, isPresented: isPresented, actions: actions, message: message)
        } else {
            #if os(iOS) || os(tvOS) || os(watchOS)
            self.actionSheet(isPresented: isPresented) {
                ActionSheet(title: Text(title))
            }
            #else
            self
            #endif
        }
    }

    /// Presents a unified confirmation dialog with a string title and actions.
    @ViewBuilder
    public func uniConfirmationDialog<S: StringProtocol, A: View>(
        _ title: S,
        isPresented: Binding<Bool>,
        @ViewBuilder actions: () -> A
    ) -> some View {
        if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
            self.confirmationDialog(title, isPresented: isPresented, actions: actions)
        } else {
            #if os(iOS) || os(tvOS) || os(watchOS)
            self.actionSheet(isPresented: isPresented) {
                ActionSheet(title: Text(title))
            }
            #else
            self
            #endif
        }
    }
}
