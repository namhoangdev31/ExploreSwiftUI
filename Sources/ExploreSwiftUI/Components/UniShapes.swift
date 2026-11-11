import SwiftUI

/// A shape that replaces itself with a version of the container's relative shape.
///
/// `UniContainerRelativeShape` provides a bridge for the modern container-relative
/// geometry features:
/// - **Modern OS (iOS 14+, macOS 11+)**: Leverages the native `ContainerRelativeShape`
///   which automatically computes its corner radius to match the nearest container's radius.
/// - **Legacy Fallback (iOS 13)**: Falls back to a standard `Rectangle` to maintain
///   the structural layout on older systems.
///
/// Example:
/// ```swift
/// UniContainerRelativeShape()
///     .fill(Color.blue)
///     .padding(4)
/// ```
public struct UniContainerRelativeShape: InsettableShape {
    var insetAmount: CGFloat = 0

    /// Creates an uni container relative shape.
    public init() {}

    public func path(in rect: CGRect) -> Path {
        if #available(iOS 14.0, macOS 11.0, tvOS 14.0, watchOS 7.0, visionOS 1.0, *) {
            return ContainerRelativeShape().inset(by: insetAmount).path(in: rect)
        } else {
            return Rectangle().inset(by: insetAmount).path(in: rect)
        }
    }

    /// Returns a new shape that is inset by the given amount.
    public func inset(by amount: CGFloat) -> UniContainerRelativeShape {
        var shape = self
        shape.insetAmount += amount
        return shape
    }
}

/// An uni generic shape component that defaults to a container-relative shape or rectangle.
public struct UniShape: InsettableShape {
    private var base: UniContainerRelativeShape
    
    public init() {
        self.base = UniContainerRelativeShape()
    }
    
    public func path(in rect: CGRect) -> Path {
        base.path(in: rect)
    }
    
    public func inset(by amount: CGFloat) -> UniShape {
        var copy = self
        copy.base = base.inset(by: amount)
        return copy
    }
}

extension Shape {
    /// Applies a tint color or style to a shape.
    @ViewBuilder
    public func uniShapeTint<S: ShapeStyle>(_ style: S) -> some View {
        self.fill(style)
    }
}
