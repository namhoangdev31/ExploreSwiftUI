import SwiftUI

struct UniAsyncImageURLSessionKey: EnvironmentKey {
    static let defaultValue: URLSession? = nil
}

extension EnvironmentValues {
    /// The URL session for uni asynchronous image downloads.
    public var uniAsyncImageURLSession: URLSession? {
        get { self[UniAsyncImageURLSessionKey.self] }
        set { self[UniAsyncImageURLSessionKey.self] = newValue }
    }
}

extension View {
    /// Sets the URL session for asynchronous image downloads.
    ///
    /// Example:
    /// ```swift
    /// ContentView()
    ///     .uniAsyncImageURLSession(customSession)
    /// ```
    @ViewBuilder
    public func uniAsyncImageURLSession(_ session: URLSession) -> some View {
        #if os(iOS) || os(macOS) || os(watchOS) || os(tvOS)
            if #available(iOS 27.0, macOS 27.0, watchOS 27.0, tvOS 27.0, *) {
                self.asyncImageURLSession(session)
                    .environment(\.uniAsyncImageURLSession, session)
            } else {
                self.environment(\.uniAsyncImageURLSession, session)
            }
        #else
            self.environment(\.uniAsyncImageURLSession, session)
        #endif
    }
}
