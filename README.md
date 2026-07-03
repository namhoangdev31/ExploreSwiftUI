# ExploreSwiftUI 🚀

ExploreSwiftUI is a state-of-the-art, high-fidelity compatibility and uni layout library for SwiftUI. It provides an enterprise-ready, unified API surface to seamlessly leverage modern SwiftUI capabilities (from **iOS 18+** through **iOS 26+ / WWDC25** and up to **iOS 27+ / WWDC26**) while guaranteeing elegant, high-fidelity fallbacks on older platforms (down to **iOS 15**, **macOS 12**, **tvOS 15**, **watchOS 8**, and **visionOS 1**).

With ExploreSwiftUI, you write clean, future-proof SwiftUI code once, and it automatically scales down to legacy operating systems without triggering build-time availability warnings or cluttering your codebase with nested `#if os(...)` and `if #available(...)` blocks.

> 📖 **For AI Agents & Integrators**: See [`DESIGN.md`](DESIGN.md) for the complete, exhaustive API catalog optimized for code generation.

---

## 📱 Platform & Version Matrix

| Platform | Deployment Target (Min) | Fully Leverages Modern APIs (Max) |
| :--- | :--- | :--- |
| **iOS** | iOS 15.0 | iOS 27.0+ |
| **macOS** | macOS 12.0 (macOS 15.0 for TabContent) | macOS 27.0+ |
| **tvOS** | tvOS 15.0 | tvOS 27.0+ |
| **watchOS** | watchOS 8.0 | watchOS 27.0+ |
| **visionOS** | visionOS 1.0 | visionOS 27.0+ |

---

## ✨ Features

- 🛠️ **Polymorphic DSLs**: Write unified structures (like `UniTabView`) that dynamically compile to modern `TabContent` structures on newer systems and legacy View-based structures on older OS versions.
- ⚙️ **Smart Availability Flow**: Dynamically evaluate platform capabilities via simple parameters, completely bypassing verbose runtime compiler blocks.
- 🎨 **Unified Design Tokens**: Modern Glassmorphic, Prominent, and Tinted styling tokens with native fallbacks on older systems.
- 🔍 **Safe Formatting Polyfills**: High-fidelity formatters for Text (currencies, floats, percentages) that automatically choose native formatters or robust fallback formatters.
- ⚡ **Zero-Change Modifier System**: Call standard modifiers like `.uniForegroundStyle()` or `.uniButtonBorderShape()` safely on any target deployment platform.
- 🆕 **iOS 27+ / WWDC26 Bridges**: First-class support for `SwipeActionsContainer`, `Slider` ticks, `AsyncImage` with `URLRequest`, reordering APIs, and more.
- 🧩 **60+ Components & 100+ Modifiers**: Covers Buttons, Navigation, TabViews, Lists, Pickers, Gauges, Sliders, Alerts, Materials, Glass Effects, Shapes, and more.

---

## 📦 Installation

To integrate **ExploreSwiftUI** into your project, add the following dependency to your `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/namhoangdev31/ExploreSwiftUI.git", from: "1.0.1")
]
```

Or add it directly via Xcode: **File** > **Add Packages...** and search for `ExploreSwiftUI`.

---

## 🚀 Core API: Availability & Control Flow

### 1. Dynamic Platform Checking (`isAvailable`)

Instead of nesting raw platform checks, check compatibility with clean, parameter-driven runtime evaluations.

> [!NOTE]
> `isAvailable` evaluates platform compatibility dynamically at runtime using `ProcessInfo`, returning `false` if the platform is mismatched, ensuring safe execution on any platform.

```swift
import ExploreSwiftUI

// 1. By Major Version
if UniPlatformVersion.isAvailable(iOS: 18, macOS: 15) {
    // Elegant modern layout logic
}

// 2. By Major & Minor Versions (using tuples)
if UniPlatformVersion.isAvailable(iOS: (16, 4), macOS: (13, 3)) {
    // Advanced sheet presentation or specific system sheets
}
```

### 2. Conditional SwiftUI Layout Modifiers (`View.if`)

The library exposes a highly convenient conditional layout modifier on `View` to safely apply styling inline without breaking the SwiftUI ViewBuilder type system.

```swift
Text("Explore SwiftUI")
    // Applies the modifier block only if the platform supports advanced sheets
    .if(UniPlatformVersion.supportsAdvancedSheetPresentation) { view in
        view.presentationDetents([.medium, .large])
    }
```

You can also use a dual-branch condition (`then` vs `else`):

```swift
Text("Premium Status")
    .if(
        UniPlatformVersion.supportsTabContentAPI,
        then: { $0.foregroundStyle(.blue).bold() },
        else: { $0.foregroundColor(.blue) }
    )
```

### 3. Conditional Side Effects (`runIf`)

Safely manage setup, configuration, or analytical code based on dynamic capability.

```swift
UniPlatformVersion.runIf(UniPlatformVersion.supportsAdvancedListAPI) {
    // Perform layout pre-caching or advanced data-fetching configurations
}
```

---

## 🎨 Major Components Showcase

### 1. Unified Tab Navigation (`UniTabView`)

One of the most complex SwiftUI challenges is bridging iOS 18+'s new `TabContent` API (which uses non-View protocols) with legacy `TabView` structures. ExploreSwiftUI resolves this using a **Polymorphic DSL** descriptor pattern.

```swift
@State private var selectedTab = 0

UniTabView(selection: $selectedTab) {
    UniTab("Today", systemImage: "sparkles", value: 0) {
        HomeView()
    }
    
    UniTab("Search", systemImage: "magnifyingglass", value: 1, role: .search) {
        SearchView()
    }
    
    UniTabSection("Account") {
        UniTab("Profile", systemImage: "person.crop.circle", value: 2) {
            ProfileView()
        }
        UniTab("Settings", systemImage: "gearshape", value: 3) {
            SettingsView()
        }
    }
}
```

- **On iOS 18+ / macOS 15+**: Compiled natively using the new `Tab` and `TabSection` containers.
- **On iOS 15-17**: Seamlessly degraded into a standard `TabView` with `.tabItem` and `.tag` modifiers.

### 2. Uni Buttons (`UniButton`)

The standard `Button` API varies widely across OS versions. `UniButton` abstracts roles, styling sizes, and border shapes dynamically.

```swift
UniButton("Delete Record", role: .destructive, action: deleteItem)
    .uniButtonStyle(.glassProminent)     // Renders Glass style on iOS 26+, fallbacks to Bordered on older systems
    .uniButtonSizing(.flexible)          // Fills width on older platforms using elegant framing polyfills
    .uniButtonBorderShape(.capsule)      // Gracefully falls back if shapes aren't natively supported
```

### 3. Content Unavailable Placeholders (`UniContentUnavailableView`)

Provide modern empty-state layouts natively supported on newer systems, with high-fidelity fallbacks on older platforms.

```swift
UniContentUnavailableView(
    "No Active Trades",
    systemImage: "chart.line.downtrend.xyaxis",
    description: "Please check your algorithm setup or explore active market connections to proceed."
) {
    UniButton("Start New Strategy", action: startStrategy)
}
```

### 4. High-Fidelity Text Formatters (`UniText`)

Display numbers, percentages, and currencies reliably on any operating system without dealing with localized formatters manually.

```swift
// Automatically parses double value to localized currency output safely
UniText(1250.75, format: .currency(code: "USD"))
    .uniTracking(0.5) // Gracefully applies kerning/tracking inline safely
```

### 5. Unified Navigation (`UniNavigationStack` & `UniNavigationSplitView`)

Apple transitioned from `NavigationView` to `NavigationStack` and `NavigationSplitView`. ExploreSwiftUI handles this dynamically.

```swift
// Unified Stack Navigation
UniNavigationStack {
    List(items) { item in
        UniNavigationLink(value: item) {
            Text(item.name)
        }
    }
    .uniNavigationDestination(for: Item.self) { item in
        DetailView(item: item)
    }
}
```

- **On iOS 16+**: Utilizes native high-performance `NavigationStack` with `navigationDestination(for:destination:)`.
- **On iOS 15**: Fallbacks to `NavigationView` and simulates link routing via traditional `NavigationLink(destination:isActive:label:)` with a binded state.

### 6. Enhanced ScrollView Modifiers (`uniScrollTargetBehavior` & `uniScrollPosition`)

Leverage iOS 17+ ScrollView features safely on iOS 15/16.

```swift
@State private var scrollID: Int?

UniScrollView(.horizontal) {
    LazyHStack {
        ForEach(0..<100) { item in
            CardView(item).id(item)
        }
    }
}
.uniScrollTargetBehavior(.paging) // Native on iOS 17+, safely ignored on older platforms
.uniScrollPosition(id: $scrollID) // Native on iOS 17+, falls back to ScrollViewReader programmatically
```

### 7. Modern Share Sheets (`UniShareLink`)

Dynamically trigger sharing workflows using the latest native sheet layouts.

```swift
UniShareLink(item: URL(string: "https://apple.com")!) {
    Label("Share Article", systemImage: "square.and.arrow.up")
}

// Share text dynamically
UniShareLink(item: "Read this amazing content!") {
    Label("Share Message", systemImage: "message")
}
```

- **On iOS 16+**: Leverages standard native `ShareLink`.
- **On iOS 15**: Seamlessly triggers UIKit's `UIActivityViewController` inside an automatically managed hidden sheet.

### 8. Dynamic Symbol Animations (`uniSymbolEffect`)

SF Symbols 5/6 introduce dynamic motion. ExploreSwiftUI simulates these animations on older devices.

```swift
@State private var isBouncing = false

Image(systemName: "wifi")
    .uniSymbolEffect(.bounce, isActive: isBouncing) // Simulates bounce via spring scale on iOS 15-16
```

Supported effects: `.bounce`, `.pulse`, `.variableColor`, `.breathe`, `.rotate`, `.wiggle`.

### 9. Unified Alerts & Dialogs (`uniAlert` & `uniConfirmationDialog`)

Unify the messy, ever-changing alert API syntax across iOS releases.

```swift
.uniAlert("Confirm Action", isPresented: $showAlert) {
    Button("Delete", role: .destructive) { }
    Button("Cancel", role: .cancel) { }
} message: {
    Text("This action cannot be undone.")
}
```

Also supports error-based alerts (`uniAlert(error:actions:)`), item-based alerts, and `uniConfirmationDialog` with the same overloads.

### 10. Glass Effects & Materials (`uniGlassEffect` & `UniGlassEffectContainer`)

iOS 26+ introduced native glass materials. ExploreSwiftUI bridges these with automatic material fallbacks.

```swift
// Glass effect on any view
Card()
    .uniGlassEffect()

// Glass container with custom shape
UniGlassEffectContainer {
    HStack {
        Image(systemName: "star.fill")
        Text("Featured")
    }
}

// Glass button variants
UniButton("Action") { doSomething() }
    .uniGlassButton(variant: .prominent)
```

### 11. Gauges (`UniGauge`)

Unified gauge display with 8 visual styles, bridging iOS 16+ `Gauge` with `ProgressView` fallback.

```swift
UniGauge(value: 0.75, style: .accessoryCircular) {
    Text("Battery")
} currentValueLabel: {
    Text("75%")
}
.uniGaugeTint(.green)
```

### 12. Disclosure & Outline Groups

Hierarchical data views with platform-guarded native APIs and graceful fallbacks.

```swift
// Expandable section
UniDisclosureGroup("Advanced Options", isExpanded: $expanded) {
    Toggle("Enable Debug Mode", isOn: $debug)
    Toggle("Verbose Logging", isOn: $verbose)
}

// Tree data
UniOutlineGroup(fileSystem, children: \.children) { item in
    Label(item.name, systemImage: item.isDirectory ? "folder" : "doc")
}
```

### 13. Reordering (iOS 27+)

Bridge the new iOS 27 reordering APIs with `onMove` fallback on older platforms.

```swift
List {
    ForEach(items) { item in
        Text(item.name)
    }
    .uniReorderable()
}
.uniReorderContainer(for: Item.self) { item, destination in
    moveItem(item, to: destination)
}
```

### 14. Sliders with Tick Marks (`UniSlider`)

iOS 27+ native slider ticks with visual fallback on older platforms.

```swift
UniSlider(value: $temperature, in: 60...90, step: 5) {
    Text("Temperature")
} minimumValueLabel: {
    Text("60°")
} maximumValueLabel: {
    Text("90°")
} ticks: {
    UniSliderTick(65) { Text("65") }
    UniSliderTick(75) { Text("75") }
    UniSliderTick(85) { Text("85") }
}
```

### 15. Swipe Actions Container (iOS 27+)

Ensure only one active swipe within a container using the new `swipeActionsContainer` API.

```swift
List {
    ForEach(items) { item in
        Text(item.name)
            .uniSwipeActions {
                Button(role: .destructive) { delete(item) } label: {
                    Label("Delete", systemImage: "trash")
                }
            }
    }
}
.uniSwipeActionsContainer()
```

---

## 🛠️ Complete Uni Components Reference

### View Components (32)

| Component | Modern SwiftUI Counterpart | Fallback Behavior |
| :--- | :--- | :--- |
| `UniButton` | `Button(role:action:)` | Resolves custom destructive/close roles, caps bounds, and maps layout sizes. |
| `UniRoleButton` | `Button(role:)` | Semantic roles (cancel, close, confirm, destructive) with auto localized titles. |
| `UniRenameButton` | `RenameButton` | Native on iOS 16+, custom button fallback. |
| `UniPasteButton` | `PasteButton` | Native on iOS 16+, clipboard-reading fallback. |
| `UniEditButton` | `EditButton` | Native on all platforms. |
| `UniMenuActionButton` | `Menu` with `primaryAction` | Menu with optional primary action. |
| `UniText` | `Text(value, format:)` | Standardizes number formatters and safely applies text tracking/kerning. |
| `UniLabel` | `Label` | Platform-agnostic label with icon and title rendering. |
| `UniLabeledContent` | `LabeledContent` (iOS 16+) | `HStack` fallback on iOS 15. |
| `UniNavigationStack` | `NavigationStack` | Falls back to `NavigationView` on iOS 15. |
| `UniNavigationSplitView` | `NavigationSplitView` | Falls back to `NavigationView` with sidebar. |
| `UniNavigationSplitView3` | `NavigationSplitView` (3-column) | Falls back to `NavigationView`. |
| `UniTabView` | `TabView` + `Tab` (iOS 18) | Bridges `TabContent` down to `.tabItem` + `.tag`. |
| `UniList` | `List` | Styled list with automatic platform adaptation. |
| `UniDisclosureGroup` | `DisclosureGroup` (iOS 14+) | `VStack` fallback on tvOS/watchOS. |
| `UniOutlineGroup` | `OutlineGroup` (iOS 14+) | Flat `ForEach` fallback on tvOS/watchOS. |
| `UniGroupBox` | `GroupBox` | Styled group box container. |
| `UniControlGroup` | `ControlGroup` (iOS 15+) | Grouped controls. |
| `UniScrollView` | `ScrollView` | Wraps layout axes and sets up margin trackers. |
| `UniViewThatFits` | `ViewThatFits` (iOS 16+) | Falls back to scrollable layout. |
| `UniAsyncImage` | `AsyncImage` | URLRequest support (iOS 27+ native), custom loader fallback. |
| `UniPicker` | `Picker` | Correctly resolves styles (menus, segmented, wheels). |
| `UniDatePicker` | `DatePicker` | Maps date styles cleanly. |
| `UniMultiDatePicker` | `MultiDatePicker` (iOS 16+) | Multi-date selection. |
| `UniSlider` | `Slider` + ticks (iOS 27+) | Slider with tick marks and tint. |
| `UniProgressView` | `ProgressView` | Standardizes progress layouts across platforms. |
| `UniGauge` | `Gauge` (iOS 16+) | 8 visual styles with `ProgressView` fallback. |
| `UniContentUnavailableView` | `ContentUnavailableView` (iOS 17+) | High-fidelity VStack fallback. |
| `UniShareLink` | `ShareLink` (iOS 16+) | `UIActivityViewController` on iOS 15. |
| `UniMenu` | `Menu` | Menu with primary action support. |
| `UniGlassEffectContainer` | Glass material (iOS 26+) | Material background polyfill. |
| `UniProductView` | `ProductView` (StoreKit, iOS 17+) | StoreKit product view bridge. |

### Bridge Modifiers (26 files, 100+ modifiers)

| Category | Key Modifiers |
| :--- | :--- |
| **Alerts** | `.uniAlert(...)`, `.uniConfirmationDialog(...)` — 14 overloads |
| **Buttons** | `.uniButtonStyle(...)`, `.uniButtonSizing(...)`, `.uniButtonBorderShape(...)`, `.uniButtonTint(...)` |
| **Colors** | `.uniForegroundStyle(color:hierarchy:gradient:opacity:)` |
| **Glass** | `.uniGlassEffect()`, `.uniGlass(in:)`, `.uniGlassButton(variant:)`, `.uniBackgroundExtension(...)` |
| **Lists** | `.uniListStyle(...)`, `.uniBadge(...)`, `.uniSwipeActions(...)`, `.uniSwipeActionsContainer()`, `.uniRefreshable(...)` — 20+ modifiers |
| **Materials** | `.uniBackgroundMaterial(...)`, `.uniForegroundMaterial(...)` |
| **Menus** | `.uniMenuOrder(...)`, `.uniContextMenu(menuItems:preview:)` |
| **Navigation** | `.uniNavigationTitle(...)`, `.uniContainerBackground(...)`, `.uniToolbarBackground(...)` |
| **Pickers** | `.uniPickerStyle(...)`, `.uniHorizontalRadioGroupLayout(...)` |
| **Progress** | `.uniProgressViewStyle(...)`, `.uniProgressTint(...)` |
| **Gauges** | `.uniGaugeStyle(...)`, `.uniGaugeTint(...)` |
| **Reorderings** | `.uniReorderable()`, `.uniReorderContainer(for:move:)` — iOS 27+ native, `onMove` fallback |
| **Scroll** | `.uniScrollTargetBehavior(...)`, `.uniScrollPosition(id:)`, `.uniScrollEdgeEffectStyle(...)` |
| **Sheets** | `.uniPresentationDetents(...)`, `.uniPresentationSizing(...)`, `.uniPresentationCornerRadius(...)` — 9 modifiers |
| **Sliders** | `.uniSliderTint(...)`, `.uniSliderTicks(...)` |
| **Symbols** | `.uniSymbolEffect(...)` — bounce, pulse, variableColor, breathe, rotate, wiggle |
| **TabViews** | `.uniTabViewStyle(...)`, `.uniTabBarMinimizeBehavior(...)`, `.uniTabViewCustomization(...)` — 10+ modifiers |
| **Text** | `.uniTracking(...)`, `.uniKerning(...)`, `.uniBold(...)`, `.uniSemi(...)`, `.uniItalic(...)` |
| **Toolbars** | `ToolbarItemPlacement.uni(...)`, `.uniNavigationSubtitle(...)`, `.uniToolbar(removing:)` |

---

## 🏛️ Architecture Design Principles

ExploreSwiftUI follows a strict design paradigm to ensure maximum performance and seamless visual integration:

1. **Zero Functional Side-Effects**: Using an uni component will never disrupt the parent view layout, structure, or data binding hierarchy.
2. **Graceful Aesthetic Degradation**: When a modern effect (like glass prominent buttons or custom materials) isn't supported, the library degrades to the nearest high-fidelity native equivalent, ensuring your app always looks premium.
3. **No Legacy Bloat**: Fallback structures are lightweight and lazily evaluated to ensure excellent scroll performance and minimal memory footprint.

---

## 🧪 Testing & Verification

ExploreSwiftUI comes with a comprehensive testing suite to verify platform generation boundaries, capability configurations, and semantic contract coverages.

To run the smoke and contract tests:

```bash
swift test --disable-sandbox
```

---

## 📚 Documentation

- **[`DESIGN.md`](DESIGN.md)** — Exhaustive API reference for AI agents and integrators. Lists every public struct, enum, modifier, and static property with usage examples.
- **Source Code** — `Sources/ExploreSwiftUI/` with clear directory structure:
  - `Components/` — 32 concrete `View` structs
  - `Bridges/` — 26 files of `View` modifier extensions
  - `Common/` — Shared enums and design tokens

---

## 🤝 Credits & Acknowledgements

This library and its API references are compiled and synthesized based on information and resources from [ExploreSwiftUI](https://exploreswiftui.com/).

---

## 📄 License

ExploreSwiftUI is available under the **MIT License**. See the `LICENSE` file for details.
