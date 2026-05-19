import SwiftUI

/// Types of symbol animations supported by `uniSymbolEffect`.
public enum UniSymbolEffect {
    /// A bouncing animation (Discrete).
    case bounce
    /// A pulsing animation (Indefinite).
    case pulse
    /// A variable color animation (Indefinite).
    case variableColor
}

extension View {
    /// Adds a symbol effect to the view, with fallback animations for older OS versions.
    ///
    /// - **iOS 17+**: Uses native `.symbolEffect` with SF Symbols 5/6.
    /// - **iOS 15-16**: Uses a custom view modifier to simulate the effect (e.g. scale or opacity changes).
    ///
    /// - Parameters:
    ///   - effect: The type of effect to apply.
    ///   - isActive: A boolean value that triggers the effect. For discrete effects like `.bounce`,
    ///               the effect triggers whenever this value changes. For indefinite effects like `.pulse`,
    ///               the effect is active while this value is true.
    ///
    /// Example:
    /// ```swift
    /// Image(systemName: "wifi")
    ///     .uniSymbolEffect(.bounce, isActive: isBouncing)
    /// ```
    @ViewBuilder
    public func uniSymbolEffect(_ effect: UniSymbolEffect, isActive: Bool = true) -> some View {
        #if os(iOS) || os(macOS) || os(tvOS) || os(watchOS) || os(visionOS)
        if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, visionOS 1.0, *) {
            switch effect {
            case .bounce:
                self.symbolEffect(.bounce, value: isActive)
            case .pulse:
                self.symbolEffect(.pulse, isActive: isActive)
            case .variableColor:
                self.symbolEffect(.variableColor, isActive: isActive)
            }
        } else {
            self.modifier(UniSymbolEffectModifier(effect: effect, isActive: isActive))
        }
        #else
        self.modifier(UniSymbolEffectModifier(effect: effect, isActive: isActive))
        #endif
    }
}

/// A custom view modifier that simulates SF Symbol animations on older operating systems.
private struct UniSymbolEffectModifier: ViewModifier {
    let effect: UniSymbolEffect
    let isActive: Bool

    // We use a local state to trigger the discrete animation on change
    @State private var bounceTrigger = false

    func body(content: Content) -> some View {
        switch effect {
        case .bounce:
            content
                .scaleEffect(bounceTrigger ? 1.2 : 1.0)
                .animation(.spring(response: 0.3, dampingFraction: 0.5, blendDuration: 0), value: bounceTrigger)
                .onChange(of: isActive) { _ in
                    bounceTrigger = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                        bounceTrigger = false
                    }
                }
        case .pulse:
            content
                .opacity(isActive ? 0.5 : 1.0)
                .animation(isActive ? .easeInOut(duration: 1).repeatForever(autoreverses: true) : .default, value: isActive)
        case .variableColor:
            // variableColor is hard to simulate natively without custom shaders.
            // We'll fallback to a subtle opacity pulse to indicate activity.
            content
                .opacity(isActive ? 0.7 : 1.0)
                .animation(isActive ? .linear(duration: 0.5).repeatForever(autoreverses: true) : .default, value: isActive)
        }
    }
}
