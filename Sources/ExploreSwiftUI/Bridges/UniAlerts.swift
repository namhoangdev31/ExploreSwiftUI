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

    // MARK: - New Alert Modifiers (Error & Item bindings)

    /// Presents an alert when an error is present.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .uniAlert(error: $error) {
    ///         Button("OK") {}
    ///     }
    /// ```
    @ViewBuilder
    public func uniAlert<E: LocalizedError, A: View>(
        error: Binding<E?>,
        @ViewBuilder actions: @escaping () -> A
    ) -> some View {
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
            if #available(iOS 27.0, macOS 27.0, watchOS 27.0, tvOS 27.0, *) {
                self.alert(error: error, actions: actions)
            } else {
                let isPresented = Binding<Bool>(
                    get: { error.wrappedValue != nil },
                    set: { if !$0 { error.wrappedValue = nil } }
                )
                if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
                    self.alert(
                        error.wrappedValue?.errorDescription ?? "Error",
                        isPresented: isPresented,
                        presenting: error.wrappedValue,
                        actions: { _ in actions() }
                    )
                } else {
                    self.alert(isPresented: isPresented) {
                        Alert(
                            title: Text(error.wrappedValue?.errorDescription ?? "Error"),
                            message: nil,
                            dismissButton: nil
                        )
                    }
                }
            }
        #else
            let isPresented = Binding<Bool>(
                get: { error.wrappedValue != nil },
                set: { if !$0 { error.wrappedValue = nil } }
            )
            self.alert(isPresented: isPresented) {
                Alert(
                    title: Text(error.wrappedValue?.errorDescription ?? "Error"),
                    message: nil,
                    dismissButton: nil
                )
            }
        #endif
    }

    /// Presents an alert with a message when an error is present.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .uniAlert(error: $error, actions: { _ in
    ///         Button("Retry") {}
    ///     }, message: { error in
    ///         Text(error.localizedDescription)
    ///     })
    /// ```
    @ViewBuilder
    public func uniAlert<E: LocalizedError, A: View, M: View>(
        error: Binding<E?>,
        @ViewBuilder actions: @escaping (E) -> A,
        @ViewBuilder message: @escaping (E) -> M
    ) -> some View {
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
            if #available(iOS 27.0, macOS 27.0, watchOS 27.0, tvOS 27.0, *) {
                self.alert(error: error, actions: actions, message: message)
            } else {
                let isPresented = Binding<Bool>(
                    get: { error.wrappedValue != nil },
                    set: { if !$0 { error.wrappedValue = nil } }
                )
                if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
                    self.alert(
                        error.wrappedValue?.errorDescription ?? "Error",
                        isPresented: isPresented,
                        presenting: error.wrappedValue,
                        actions: actions,
                        message: message
                    )
                } else {
                    self.alert(isPresented: isPresented) {
                        Alert(
                            title: Text(error.wrappedValue?.errorDescription ?? "Error"),
                            message: nil,
                            dismissButton: nil
                        )
                    }
                }
            }
        #else
            let isPresented = Binding<Bool>(
                get: { error.wrappedValue != nil },
                set: { if !$0 { error.wrappedValue = nil } }
            )
            self.alert(isPresented: isPresented) {
                Alert(
                    title: Text(error.wrappedValue?.errorDescription ?? "Error"),
                    message: nil,
                    dismissButton: nil
                )
            }
        #endif
    }

    /// Presents an alert using the given data to produce the alert’s content.
    ///
    /// Example:
    /// ```swift
    /// Text("Hello")
    ///     .uniAlert("Purchase", item: $selectedItem) { item in
    ///         Button("Buy \(item.name)") {}
    ///     }
    /// ```
    @ViewBuilder
    public func uniAlert<Item, A: View>(
        _ titleKey: LocalizedStringKey,
        item: Binding<Item?>,
        @ViewBuilder actions: @escaping (Item) -> A
    ) -> some View {
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
            if #available(iOS 27.0, macOS 27.0, watchOS 27.0, tvOS 27.0, *) {
                self.alert(titleKey, item: item, actions: actions)
            } else {
                let isPresented = Binding<Bool>(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                )
                if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
                    self.alert(
                        titleKey,
                        isPresented: isPresented,
                        presenting: item.wrappedValue,
                        actions: actions
                    )
                } else {
                    self.alert(isPresented: isPresented) {
                        Alert(title: Text(titleKey))
                    }
                }
            }
        #else
            let isPresented = Binding<Bool>(
                get: { item.wrappedValue != nil },
                set: { if !$0 { item.wrappedValue = nil } }
            )
            self.alert(isPresented: isPresented) {
                Alert(title: Text(titleKey))
            }
        #endif
    }

    /// Presents an alert with a message using the given data to produce the alert’s content.
    @ViewBuilder
    public func uniAlert<Item, A: View, M: View>(
        _ titleKey: LocalizedStringKey,
        item: Binding<Item?>,
        @ViewBuilder actions: @escaping (Item) -> A,
        @ViewBuilder message: @escaping (Item) -> M
    ) -> some View {
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
            if #available(iOS 27.0, macOS 27.0, watchOS 27.0, tvOS 27.0, *) {
                self.alert(titleKey, item: item, actions: actions, message: message)
            } else {
                let isPresented = Binding<Bool>(
                    get: { item.wrappedValue != nil },
                    set: { if !$0 { item.wrappedValue = nil } }
                )
                if #available(iOS 15.0, macOS 12.0, tvOS 15.0, watchOS 8.0, visionOS 1.0, *) {
                    self.alert(
                        titleKey,
                        isPresented: isPresented,
                        presenting: item.wrappedValue,
                        actions: actions,
                        message: message
                    )
                } else {
                    self.alert(isPresented: isPresented) {
                        Alert(title: Text(titleKey))
                    }
                }
            }
        #else
            let isPresented = Binding<Bool>(
                get: { item.wrappedValue != nil },
                set: { if !$0 { item.wrappedValue = nil } }
            )
            self.alert(isPresented: isPresented) {
                Alert(title: Text(titleKey))
            }
        #endif
    }

    /// Presents an alert using the given data to produce the alert’s content.
    @ViewBuilder
    public func uniAlert<S: StringProtocol, Item, A: View>(
        _ title: S,
        item: Binding<Item?>,
        @ViewBuilder actions: @escaping (Item) -> A
    ) -> some View {
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
            if #available(iOS 27.0, macOS 27.0, watchOS 27.0, tvOS 27.0, *) {
                self.alert(title, item: item, actions: actions)
            } else {
                self.uniAlert(LocalizedStringKey(String(title)), item: item, actions: actions)
            }
        #else
            self.uniAlert(LocalizedStringKey(String(title)), item: item, actions: actions)
        #endif
    }

    /// Presents an alert with a message using the given data to produce the alert’s content.
    @ViewBuilder
    public func uniAlert<S: StringProtocol, Item, A: View, M: View>(
        _ title: S,
        item: Binding<Item?>,
        @ViewBuilder actions: @escaping (Item) -> A,
        @ViewBuilder message: @escaping (Item) -> M
    ) -> some View {
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
            if #available(iOS 27.0, macOS 27.0, watchOS 27.0, tvOS 27.0, *) {
                self.alert(title, item: item, actions: actions, message: message)
            } else {
                self.uniAlert(LocalizedStringKey(String(title)), item: item, actions: actions, message: message)
            }
        #else
            self.uniAlert(LocalizedStringKey(String(title)), item: item, actions: actions, message: message)
        #endif
    }
}
