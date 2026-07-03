import SwiftUI

// MARK: - DynamicViewContent Extensions

extension DynamicViewContent {
    /// Enables reordering of views from this content inside the scope of a reorderable container.
    ///
    /// Example:
    /// ```swift
    /// VStack {
    ///     ForEach(items) { item in
    ///         Text(item.name)
    ///     }
    ///     .uniReorderable()
    /// }
    /// .uniReorderContainer(for: Item.self) { difference in
    ///     apply(difference: difference)
    /// }
    /// ```
    @available(iOS 27.0, macOS 27.0, watchOS 27.0, *)
    @available(tvOS, unavailable)
    @ViewBuilder
    public func uniReorderable() -> some DynamicViewContent<Self.Data> {
        #if os(iOS) || os(macOS) || os(watchOS)
            self.reorderable()
        #else
            self
        #endif
    }

    /// Enables reordering views from this content within and between sections in the scope of a reorderable container.
    ///
    /// Example:
    /// ```swift
    /// List {
    ///     ForEach(sections) { section in
    ///         Section(section.name) {
    ///             ForEach(section.items) { item in
    ///                 Text(item.name)
    ///             }
    ///             .uniReorderable(collectionID: section.id)
    ///         }
    ///     }
    /// }
    /// .uniReorderContainer(for: Item.self, in: Section.ID.self) { difference in
    ///     apply(difference: difference)
    /// }
    /// ```
    @available(iOS 27.0, macOS 27.0, watchOS 27.0, *)
    @available(tvOS, unavailable)
    @ViewBuilder
    public func uniReorderable(collectionID: some Hashable & Sendable) -> some DynamicViewContent<Self.Data> {
        #if os(iOS) || os(macOS) || os(watchOS)
            self.reorderable(collectionID: collectionID)
        #else
            self
        #endif
    }
}

// MARK: - View Extensions

extension View {
    /// Defines a container of reorderable views.
    ///
    /// Example:
    /// ```swift
    /// VStack {
    ///     ForEach(items) { item in
    ///         Text(item.name)
    ///     }
    ///     .uniReorderable()
    /// }
    /// .uniReorderContainer(for: Item.self) { difference in
    ///     apply(difference: difference)
    /// }
    /// ```
    @available(iOS 27.0, macOS 27.0, watchOS 27.0, *)
    @available(tvOS, unavailable)
    @ViewBuilder
    public func uniReorderContainer<Item>(
        for item: Item.Type,
        isEnabled: Bool = true,
        move: @escaping (_ difference: ReorderDifference<Item.ID, ReorderableSingleCollectionIdentifier>) -> Void
    ) -> some View where Item : Identifiable, Item.ID : Sendable {
        #if os(iOS) || os(macOS) || os(watchOS)
            self.reorderContainer(for: item, isEnabled: isEnabled, move: move)
        #else
            self
        #endif
    }

    /// Defines a container of reorderable views, with a type you specify to identify sections.
    ///
    /// Example:
    /// ```swift
    /// List {
    ///     ForEach(sections) { section in
    ///         Section(section.name) {
    ///             ForEach(section.items) { item in
    ///                 Text(item.name)
    ///             }
    ///             .uniReorderable(collectionID: section.id)
    ///         }
    ///     }
    /// }
    /// .uniReorderContainer(for: Item.self, in: Section.ID.self) { difference in
    ///     apply(difference: difference)
    /// }
    /// ```
    @available(iOS 27.0, macOS 27.0, watchOS 27.0, *)
    @available(tvOS, unavailable)
    @ViewBuilder
    public func uniReorderContainer<Item, CollectionID>(
        for item: Item.Type,
        in collectionID: CollectionID.Type,
        isEnabled: Bool = true,
        move: @escaping (_ difference: ReorderDifference<Item.ID, CollectionID>) -> Void
    ) -> some View where Item : Identifiable, CollectionID : Hashable, CollectionID : Sendable, Item.ID : Sendable {
        #if os(iOS) || os(macOS) || os(watchOS)
            self.reorderContainer(for: item, in: collectionID, isEnabled: isEnabled, move: move)
        #else
            self
        #endif
    }

    /// Defines a container of reorderable views, with a type and keypath you specify to identify items.
    ///
    /// Example:
    /// ```swift
    /// VStack {
    ///     ForEach(items, id: \.databaseID) { item in
    ///         Text(item.name)
    ///     }
    ///     .uniReorderable()
    /// }
    /// .uniReorderContainer(for: Item.self, itemID: \.databaseID) { difference in
    ///     apply(difference: difference)
    /// }
    /// ```
    @available(iOS 27.0, macOS 27.0, watchOS 27.0, *)
    @available(tvOS, unavailable)
    @ViewBuilder
    public func uniReorderContainer<Item, ItemID>(
        for item: Item.Type,
        itemID: KeyPath<Item, ItemID>,
        isEnabled: Bool = true,
        move: @escaping (_ difference: ReorderDifference<ItemID, ReorderableSingleCollectionIdentifier>) -> Void
    ) -> some View where ItemID : Hashable, ItemID : Sendable {
        #if os(iOS) || os(macOS) || os(watchOS)
            self.reorderContainer(for: item, itemID: itemID, isEnabled: isEnabled, move: move)
        #else
            self
        #endif
    }

    /// Defines a container of reorderable views, with a type and keypath you specify to identify items and a type you use to identify collections.
    ///
    /// Example:
    /// ```swift
    /// List {
    ///     ForEach(sections) { section in
    ///         Section(section.name) {
    ///             ForEach(section.items, id: \.databaseID) { item in
    ///                 Text(item.name)
    ///             }
    ///             .uniReorderable(collectionID: section.id)
    ///         }
    ///     }
    /// }
    /// .uniReorderContainer(for: Item.self, itemID: \.databaseID, in: Section.ID.self) { difference in
    ///     apply(difference: difference)
    /// }
    /// ```
    @available(iOS 27.0, macOS 27.0, watchOS 27.0, *)
    @available(tvOS, unavailable)
    @ViewBuilder
    public func uniReorderContainer<Item, ItemID, CollectionID>(
        for item: Item.Type,
        itemID: KeyPath<Item, ItemID>,
        in collectionID: CollectionID.Type,
        isEnabled: Bool = true,
        move: @escaping (_ difference: ReorderDifference<ItemID, CollectionID>) -> Void
    ) -> some View where ItemID : Hashable, ItemID : Sendable, CollectionID : Hashable, CollectionID : Sendable {
        #if os(iOS) || os(macOS) || os(watchOS)
            self.reorderContainer(for: item, itemID: itemID, in: collectionID, isEnabled: isEnabled, move: move)
        #else
            self
        #endif
    }
}
