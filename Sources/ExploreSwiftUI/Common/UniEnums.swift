import SwiftUI

// MARK: - Label & Text Enums

/// An uni label style type to match native `LabelStyle`.
///
/// Example:
/// ```swift
/// UniLabel("Home", systemImage: "house")
///     .uniLabelStyle(.titleAndIcon)
/// ```
public enum UniLabelStyleType: Sendable {
    case automatic
    case iconOnly
    case titleAndIcon
    case titleOnly
}

/// Defines number formatting options for `UniText`.
///
/// Example:
/// ```swift
/// UniText(1234.56, format: .currency(code: "USD"))
/// UniText(0.75, format: .percent)
/// ```
public enum UniNumberFormat: Sendable {
    case currency(code: String)
    case percent
    case decimal(fractionLength: Int? = nil, grouping: Bool = true, scientific: Bool = false)
}

/// Defines width styles for measurement formatting.
///
/// Example:
/// ```swift
/// UniText(measurement, width: .abbreviated) // "5 kg"
/// UniText(measurement, width: .wide)        // "5 kilograms"
/// ```
public enum UniMeasurementWidth: Sendable {
    case wide
    case narrow
    case abbreviated
}

/// Defines patterns for time duration formatting.
///
/// Example:
/// ```swift
/// UniText(seconds: 3660, pattern: .hourMinute) // "1:01"
/// ```
public enum UniTimePattern: Sendable {
    case hourMinute
    case minuteSecond
}

// MARK: - Button & Control Enums

/// Defines semantic roles for uni buttons.
public enum UniButtonRole: Sendable {
    case cancel
    case close
    case confirm
    case destructive
}

/// Defines sizing behaviors for uni buttons.
public enum UniButtonSizing: Sendable {
    case automatic
    case fitted
    case flexible
}

/// Defines visual styles for uni buttons, including polyfilled glass styles.
///
/// Example:
/// ```swift
/// UniButton("Click Me") {}
///     .uniButtonStyle(.glassProminent)
/// ```
public enum UniButtonStyle: Sendable {
    case automatic
    case plain
    case borderless
    case bordered
    case borderedProminent
    case glass
    case glassProminent
}

/// An uni control size type to match native `ControlSize`.
///
/// Example:
/// ```swift
/// UniButton("Small") {}
///     .uniControlSize(.small)
/// ```
public enum UniControlSize: Sendable {
    case mini
    case small
    case regular
    case large
    case extraLarge

    @available(iOS 15.0, macOS 10.15, tvOS 15.0, watchOS 9.0, visionOS 1.0, *)
    public var native: ControlSize {
        switch self {
        case .mini: return .mini
        case .small: return .small
        case .regular: return .regular
        case .large: return .large
        case .extraLarge:
            #if os(visionOS)
                return .extraLarge
            #else
                if #available(iOS 17.0, macOS 14.0, tvOS 17.0, watchOS 10.0, *) {
                    return .extraLarge
                } else {
                    return .large
                }
            #endif
        }
    }
}

/// Defines border shapes for uni buttons.
public enum UniButtonBorderShape: Sendable {
    case automatic
    case roundedRectangle
    case capsule
    case circle
    case roundedRectangleRadius(CGFloat)
}

/// Defines hierarchical importance levels for views (Primary, Secondary, etc.).
public enum UniHierarchicalVariant: Sendable {
    case primary
    case secondary
    case tertiary
    case quaternary
    case quinary
}

// MARK: - Material & Effect Enums

/// Defines standard levels of material thickness.
///
/// Example:
/// ```swift
/// MyView()
///     .uniBackgroundMaterial(.thin)
/// ```
public enum UniMaterialType: Sendable {
    case ultraThin
    case thin
    case regular
    case thick
    case ultraThick
}

/// Defines material styles for background fills.
public enum UniMaterialStyle: Sendable {
    case ultraThin
    case thin
    case regular
    case thick
    case ultraThick
}

/// Defines variants for glass effect buttons.
public enum UniGlassButtonVariant: Sendable {
    case regular
    case prominent
}

/// Defines semantic hierarchical levels for color styles.
public enum UniColorHierarchy: Sendable {
    case primary
    case secondary
    case tertiary
    case quaternary
    case quinary
}

// MARK: - Layout & Container Enums

/// Defines axes for `UniViewThatFits`.
public enum UniViewThatFitsAxes: Sendable {
    case horizontal
    case vertical
    case all

    @available(iOS 16.0, macOS 13.0, watchOS 9.0, tvOS 16.0, *)
    public var native: Axis.Set {
        switch self {
        case .horizontal: return .horizontal
        case .vertical: return .vertical
        case .all: return [.horizontal, .vertical]
        }
    }
}

/// Defines placements for container background styles.
public enum UniContainerBackgroundPlacement: Sendable {
    case navigation
    case navigationSplitView

    #if os(iOS) || os(watchOS)
        @available(iOS 18.0, watchOS 10.0, *)
        public var native: ContainerBackgroundPlacement {
            switch self {
            case .navigation:
                return .navigation
            case .navigationSplitView:
                if #available(iOS 18.0, watchOS 11.0, *) {
                    return .navigationSplitView
                } else {
                    return .navigation
                }
            }
        }
    #endif
}

/// Defines edge effect styles for scroll views.
public enum UniScrollEdgeEffectStyle: Sendable {
    case hard
}

// MARK: - Style Enums

/// Defines visual styles for `UniProgressView`.
public enum UniProgressViewStyle: Sendable {
    case automatic
    case linear
    case circular
}

/// Defines ordering behaviors for uni menus.
public enum UniMenuOrder: Sendable {
    case automatic
    case fixed
    case priority
}

/// Defines visual styles for `UniControlGroup`.
public enum UniControlGroupStyle: Sendable {
    case automatic
    case navigation
    case menu
    case compactMenu
    case palette
}

/// Defines visual styles for `UniDatePicker`.
public enum UniDatePickerStyle: Sendable {
    case automatic
    case wheel
    case graphical
    case field
    case stepperField
}

/// Defines visual styles for `UniPicker`.
public enum UniPickerStyle: Sendable {
    case automatic
    case menu
    case inline
    case navigationLink
    case palette
    case segmented
    case wheel
    case radioGroup
}

/// Defines visual styles for `UniGauge`.
public enum UniGaugeStyle: Sendable {
    case automatic
    case linear
    case linearCapacity
    case circular
    case accessoryLinear
    case accessoryLinearCapacity
    case accessoryCircular
    case accessoryCircularCapacity
}

// MARK: - List & Sheet Enums

/// Defines visual styles for `UniList`.
public enum UniListStyleType: Sendable {
    case automatic
    case plain
    case grouped
    case insetGrouped
    case sidebar
    case inset
    case elliptical  // watchOS
    case carousel  // watchOS
    case bordered  // macOS
}

/// Defines section spacing for lists.
public enum UniListSectionSpacing: Sendable {
    case `default`
    case compact
    case custom(CGFloat)
}

/// Defines background prominence for list items.
public enum UniBackgroundProminence: Sendable {
    case standard
    case increased
}

/// Defines badge prominence for list items.
public enum UniBadgeProminence: Sendable {
    case standard
    case increased
}

/// Defines sizing behaviors for uni sheets.
public enum UniSheetSizing: Sendable {
    case automatic
    case fitted
    case page
}

/// Defines presentation detents for uni sheets.
public enum UniPresentationDetent: Hashable, Sendable {
    case medium
    case large
    case fraction(CGFloat)
    case height(CGFloat)
}

/// Defines background interaction behaviors for uni sheets.
public enum UniPresentationBackgroundInteraction: Sendable {
    case automatic
    case enabled
    case disabled
    case enabledUpThrough(UniPresentationDetent)
}

/// Defines content interaction behaviors for uni sheets.
public enum UniPresentationContentInteraction: Sendable {
    case automatic
    case scrolls
    case resizes
}

// MARK: - Toolbar & TabView Enums

/// Defines title placements for uni toolbars.
public enum UniToolbarTitlePlacement: Sendable {
    case automatic
    case title
    case subtitle
    case largeTitle
    case largeSubtitle
}

/// Defines spacer sizing behaviors for uni toolbars.
public enum UniToolbarSpacerSizing: Sendable {
    case fixed
    case flexible
}

/// Defines kinds of default toolbar items for uni removal or customization.
public enum UniToolbarDefaultItemKind: Sendable {
    case sidebarToggle
    case title
    case search
}

/// Defines visual styles for `UniTabView`.
public enum UniTabViewStyle: Sendable {
    case automatic
    case sidebarAdaptable
    case tabBarOnly
    case grouped
    case page(indexDisplayMode: UniPageTabIndexDisplayMode = .automatic)
    case verticalPage
}

/// Defines index display modes for page tab styles.
public enum UniPageTabIndexDisplayMode: Sendable {
    case automatic, always, never
}

/// Defines minimize behaviors for the tab bar on scroll.
public enum UniTabBarMinimizeBehavior: Sendable {
    case automatic, never, onScrollDown, onScrollUp
}

/// Defines adaptable placement behaviors for the tab bar.
public enum UniAdaptableTabBarPlacement: Sendable {
    case automatic, sidebar, tabBar
}

/// Defines placement behaviors for tab view bottom accessories.
public enum UniBottomAccessoryPlacement: Sendable {
    case inline, expanded, none
}

/// Defines customization placements for tabs.
public enum UniTabCustomizationPlacement: Hashable, Sendable {
    case automatic, tabBar, sidebar
}

/// Defines customization behaviors for tabs.
public enum UniTabCustomizationBehavior: Sendable {
    case automatic, reorderable, disabled
}

/// Defines semantic roles for tabs.
public enum UniTabRole: Sendable {
    case automatic, search
}
