import SwiftUI
#if canImport(StoreKit)
import StoreKit
#endif

extension View {

    /// Configures the visibility of standard StoreKit buttons (cancellation, restore purchases).
    ///
    /// - Parameters:
    ///   - visibility: Visibility mode (`.automatic`, `.visible`, `.hidden`).
    ///   - kind: Button kind (`.cancellation`, `.restorePurchases`).
    ///
    /// Example:
    /// ```swift
    /// UniStoreView(ids: ["pro_yearly"])
    ///     .uniStoreButton(.visible, for: .restorePurchases)
    /// ```
    @ViewBuilder
    public func uniStoreButton(
        _ visibility: UniStoreButtonVisibility = .visible,
        for kind: UniStoreButtonKind
    ) -> some View {
        #if canImport(StoreKit)
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS) || os(watchOS)
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
                    #if !os(watchOS)
                        let nativeVisibility: Visibility = {
                            switch visibility {
                            case .automatic: return .automatic
                            case .visible: return .visible
                            case .hidden: return .hidden
                            }
                        }()

                        switch kind {
                        case .cancellation:
                            self.storeButton(nativeVisibility, for: .cancellation)
                        case .restorePurchases:
                            self.storeButton(nativeVisibility, for: .restorePurchases)
                        }
                    #else
                        self
                    #endif
                } else {
                    self
                }
            #else
                self
            #endif
        #else
            self
        #endif
    }

    /// Displays the native App Store subscription management sheet.
    ///
    /// - Parameter isPresented: A binding that controls sheet presentation.
    @ViewBuilder
    public func uniManageSubscriptionsSheet(isPresented: Binding<Bool>) -> some View {
        #if canImport(StoreKit)
            #if os(iOS) || os(visionOS)
                if #available(iOS 15.0, visionOS 1.0, *) {
                    self.manageSubscriptionsSheet(isPresented: isPresented)
                } else {
                    self
                }
            #else
                self
            #endif
        #else
            self
        #endif
    }

    /// Displays an App Store product overlay when a condition is met.
    ///
    /// - Parameters:
    ///   - isPresented: Binding to control presentation.
    ///   - appIdentifier: Target iTunes App ID.
    @ViewBuilder
    public func uniAppStoreOverlay(
        isPresented: Binding<Bool>,
        appIdentifier: String
    ) -> some View {
        #if canImport(StoreKit)
            #if os(iOS) || os(visionOS)
                if #available(iOS 14.0, visionOS 1.0, *) {
                    self.appStoreOverlay(isPresented: isPresented) {
                        SKOverlay.AppConfiguration(appIdentifier: appIdentifier, position: .bottom)
                    }
                } else {
                    self
                }
            #else
                self
            #endif
        #else
            self
        #endif
    }
}
