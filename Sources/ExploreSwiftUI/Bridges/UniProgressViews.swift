import SwiftUI

extension View {

    /// Sets the visual style for uni progress views.
    ///
    /// This modifier maps `UniProgressViewStyle` to native SwiftUI `ProgressViewStyle`:
    /// - **Automatic**: Uses the system default style for the current context.
    /// - **Linear**: A progress bar style (iOS 14+, macOS 11+, etc.).
    /// - **Circular**: A spinning indeterminate or determinate indicator (iOS 14+, macOS 11+, etc.).
    ///
    /// Example:
    /// ```swift
    /// UniProgressView(value: 0.5)
    ///     .uniProgressViewStyle(.linear)
    /// ```
    @ViewBuilder
    public func uniProgressViewStyle(_ style: UniProgressViewStyle) -> some View {
        switch style {
        case .automatic:
            self.progressViewStyle(.automatic)
        case .linear:
            #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS) || os(visionOS)
                if #available(iOS 14.0, macOS 11.0, watchOS 7.0, tvOS 14.0, visionOS 1.0, *) {
                    self.progressViewStyle(.linear)
                } else {
                    self
                }
            #else
                self
            #endif
        case .circular:
            #if os(iOS) || os(macOS) || os(tvOS) || os(visionOS)
                if #available(iOS 14.0, macOS 11.0, tvOS 14.0, visionOS 1.0, *) {
                    self.progressViewStyle(.circular)
                } else {
                    self
                }
            #else
                self
            #endif
        }
    }

    /// Sets the tint color for uni progress views.
    ///
    /// This modifier uses the native `.tint()` API on modern systems and falls back to
    /// `.accentColor()` on older OS versions to maintain visual consistency.
    ///
    /// Example:
    /// ```swift
    /// MyProgressView()
    ///     .uniProgressTint(.blue)
    /// ```
    @ViewBuilder
    public func uniProgressTint(_ color: Color?) -> some View {
        if let color {
            if #available(iOS 15.0, macOS 12.0, watchOS 8.0, tvOS 15.0, *) {
                self.tint(color)
            } else {
                self.accentColor(color)
            }
        } else {
            self
        }
    }
}
