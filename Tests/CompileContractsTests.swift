import Foundation
import SwiftUI
import XCTest

@testable import ExploreSwiftUI

final class CompileContractsTests: XCTestCase {
    func testOSGenerationOrdering() {
        XCTAssertTrue(UniOSGeneration.v26.rawValue > UniOSGeneration.v18.rawValue)
        XCTAssertTrue(UniOSGeneration.v18.rawValue > UniOSGeneration.v15.rawValue)
    }

    func testPlatformCapabilityFlagsEvaluate() {
        _ = UniPlatformVersion.supportsWWDC25Design
        _ = UniPlatformVersion.supportsTabContentAPI
        _ = UniPlatformVersion.supportsAdaptableTabCustomization
        _ = UniPlatformVersion.supportsAdvancedSheetPresentation
        _ = UniPlatformVersion.supportsAdvancedListAPI
        _ = UniPlatformVersion.supportsAdvancedPickerAPI
    }

    func testExploreSwiftUIRSSFixtureHasFullCoverage() throws {
        let xmlData = try loadExploreSwiftUIRSSFixtureData()
        let feed = try ExploreSwiftUIRSSParser.parse(data: xmlData)

        XCTAssertEqual(feed.lastBuildDate, "Tue, 03 Nov 2026 11:16:15 GMT")
        XCTAssertEqual(feed.items.count, 249, "RSS must include all published cases from snapshot.")
        XCTAssertTrue(
            feed.items.allSatisfy(\.hasRequiredCoreFields),
            "Every RSS case must contain core fields: title/link/guid/pubDate/content."
        )
        XCTAssertEqual(
            feed.items.filter { !$0.summary.isEmpty }.count,
            246,
            "Snapshot currently has 246 item descriptions and 3 empty descriptions."
        )
        XCTAssertEqual(
            Set(feed.items.map(\.guid)).count, 249, "Each RSS case must have a unique guid.")

        let componentCounts = Dictionary(grouping: feed.items, by: \.component).mapValues(\.count)
        let expectedComponentCounts: [String: Int] = [
            "alert": 4,
            "arrangementview": 6,
            "asyncimage": 4,
            "button": 11,
            "color": 10,
            "concentricrectangle": 2,
            "contentunavailableview": 3,
            "controlgroup": 5,
            "datepicker": 11,
            "divider": 4,
            "gauge": 11,
            "geometryreader": 1,
            "glasseffectcontainer": 1,
            "groupbox": 3,
            "label": 4,
            "labeledcontent": 3,
            "link": 5,
            "list": 32,
            "material": 1,
            "menu": 8,
            "navigation": 6,
            "picker": 15,
            "productview": 6,
            "progressview": 4,
            "scrollview": 1,
            "shapes": 1,
            "sheet": 12,
            "slider": 6,
            "storeview": 6,
            "subscriptionstoreview": 6,
            "tabview": 24,
            "text": 1,
            "textfield": 1,
            "toggle": 5,
            "toolbars": 9,
            "view": 15,
            "viewthatfits": 2,
        ]

        XCTAssertEqual(
            componentCounts, expectedComponentCounts,
            "Component coverage differs from RSS snapshot.")
        XCTAssertEqual(componentCounts.count, 37, "RSS must contain all expected components.")
    }
}

// MARK: - RSS Parser Infrastructure

struct ExploreSwiftUIRSSFeed: Sendable {
    let lastBuildDate: String
    let items: [ExploreSwiftUIRSSItem]
}

struct ExploreSwiftUIRSSItem: Hashable, Sendable, CustomStringConvertible {
    let title: String
    let link: String
    let guid: String
    let pubDate: String
    let summary: String
    let contentEncoded: String

    var component: String {
        let marker = "/library/"
        guard let markerRange = link.range(of: marker) else {
            return ""
        }

        let pathAfterMarker = link[markerRange.upperBound...]
        return pathAfterMarker.split(separator: "/").first.map(String.init) ?? ""
    }

    var hasRequiredCoreFields: Bool {
        [title, link, guid, pubDate, contentEncoded].allSatisfy { !$0.isEmpty }
    }

    var description: String {
        "\(guid) [\(component)]"
    }
}

final class ExploreSwiftUIRSSParser: NSObject, XMLParserDelegate {
    private var lastBuildDate = ""
    private var items: [ExploreSwiftUIRSSItem] = []
    private var currentItem = MutableItem()
    private var isInsideItem = false
    private var currentTextValue = ""

    static func parse(data: Data) throws -> ExploreSwiftUIRSSFeed {
        let delegate = ExploreSwiftUIRSSParser()
        delegate.items.reserveCapacity(260)
        delegate.currentTextValue.reserveCapacity(2048)
        let parser = XMLParser(data: data)
        parser.delegate = delegate
        parser.shouldProcessNamespaces = true

        guard parser.parse() else {
            throw parser.parserError ?? NSError(domain: "ExploreSwiftUITests", code: 2)
        }

        return ExploreSwiftUIRSSFeed(
            lastBuildDate: delegate.lastBuildDate,
            items: delegate.items
        )
    }

    func parser(
        _ parser: XMLParser,
        didStartElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?,
        attributes attributeDict: [String: String] = [:]
    ) {
        let currentElementName = normalizedName(
            elementName: elementName,
            namespaceURI: namespaceURI,
            qualifiedName: qName
        )
        currentTextValue.removeAll(keepingCapacity: true)

        if currentElementName == "item" {
            isInsideItem = true
            currentItem = MutableItem()
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        currentTextValue += string
    }

    func parser(
        _ parser: XMLParser,
        didEndElement elementName: String,
        namespaceURI: String?,
        qualifiedName qName: String?
    ) {
        let endedElementName = normalizedName(
            elementName: elementName,
            namespaceURI: namespaceURI,
            qualifiedName: qName
        )
        let normalizedValue = currentTextValue.trimmingCharacters(in: .whitespacesAndNewlines)

        if isInsideItem {
            switch endedElementName {
            case "title":
                currentItem.title = normalizedValue
            case "link":
                currentItem.link = normalizedValue
            case "guid":
                currentItem.guid = normalizedValue
            case "pubDate":
                currentItem.pubDate = normalizedValue
            case "description":
                currentItem.summary = normalizedValue
            case "content:encoded":
                currentItem.contentEncoded = normalizedValue
            case "item":
                items.append(currentItem.finalize())
                currentItem = MutableItem()
                isInsideItem = false
            default:
                break
            }
        } else if endedElementName == "lastBuildDate" {
            lastBuildDate = normalizedValue
        }

        currentTextValue.removeAll(keepingCapacity: true)
    }

    private func normalizedName(
        elementName: String,
        namespaceURI: String?,
        qualifiedName: String?
    ) -> String {
        if let qualifiedName {
            return qualifiedName
        }

        if namespaceURI == "http://purl.org/rss/1.0/modules/content/", elementName == "encoded" {
            return "content:encoded"
        }

        return elementName
    }
}

func loadExploreSwiftUIRSSFixtureData() throws -> Data {
    let fixtureURL =
        Bundle.module.url(
            forResource: "exploreswiftui_feed",
            withExtension: "xml",
            subdirectory: "Fixtures"
        )
        ?? Bundle.module.url(
            forResource: "exploreswiftui_feed",
            withExtension: "xml"
        )

    guard let fixtureURL else {
        throw NSError(domain: "ExploreSwiftUITests", code: 1)
    }

    return try Data(contentsOf: fixtureURL)
}

private struct MutableItem {
    var title = ""
    var link = ""
    var guid = ""
    var pubDate = ""
    var summary = ""
    var contentEncoded = ""

    func finalize() -> ExploreSwiftUIRSSItem {
        ExploreSwiftUIRSSItem(
            title: title,
            link: link,
            guid: guid,
            pubDate: pubDate,
            summary: summary,
            contentEncoded: contentEncoded
        )
    }
}
