import SwiftUI

/// A container that presents rows of data arranged in a single column.
///
/// `UniList` provides a unified wrapper around SwiftUI's `List`, allowing you to
/// easily switch between different platform-standard list styles using the
/// `uniListStyle` modifier.
///
/// Example:
/// ```swift
/// UniList(style: .insetGrouped) {
///     Text("Row 1")
///     Text("Row 2")
/// }
/// ```
public struct UniList<Content: View>: View {
    private let style: UniListStyleType
    private let content: () -> Content

    /// Creates an uni list with custom content.
    ///
    /// - Parameters:
    ///   - style: The list style to apply (e.g., `.grouped`, `.insetGrouped`).
    ///   - content: A view builder describing the rows of the list.
    public init(
        style: UniListStyleType = .automatic,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.style = style
        self.content = content
    }

    public var body: some View {
        List {
            content()
        }
        .uniListStyle(style)
    }
}

extension UniList {
    /// Creates a data-driven uni list.
    ///
    /// This initializer automatically handles the creation of rows for each element in the
    /// provided data collection.
    ///
    /// Example:
    /// ```swift
    /// UniList(users) { user in
    ///     Text(user.name)
    /// }
    /// ```
    ///
    /// - Parameters:
    ///   - data: The collection of identifiable data to display.
    ///   - style: The list style to apply.
    ///   - rowContent: A view builder that describes a single row for an element in the data.
    public init<Data: RandomAccessCollection, RowContent: View>(
        _ data: Data,
        style: UniListStyleType = .automatic,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) where Content == ForEach<Data, Data.Element.ID, RowContent>, Data.Element: Identifiable {
        self.style = style
        self.content = { ForEach(data, content: rowContent) }
    }

    /// Creates a data-driven uni list using an explicit ID key path.
    public init<Data: RandomAccessCollection, ID: Hashable, RowContent: View>(
        _ data: Data,
        id: KeyPath<Data.Element, ID>,
        style: UniListStyleType = .automatic,
        @ViewBuilder rowContent: @escaping (Data.Element) -> RowContent
    ) where Content == ForEach<Data, ID, RowContent> {
        self.style = style
        self.content = { ForEach(data, id: id, content: rowContent) }
    }
}
