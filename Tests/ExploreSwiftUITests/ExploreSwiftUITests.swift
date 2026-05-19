import Testing
import SwiftUI
@testable import ExploreSwiftUI

@MainActor
struct ExploreSwiftUITests {

    @Test func testIsAvailableMajor() async throws {
        // Our current system major version is known at runtime
        let major = AdaptivePlatformVersion.currentMajor
        
        // checking the current major should be true on any platform we run on
        #expect(AdaptivePlatformVersion.isAvailable(iOS: major, macOS: major, tvOS: major, watchOS: major, visionOS: major) == true)
        
        // checking a far future major should be false
        #expect(AdaptivePlatformVersion.isAvailable(iOS: 999, macOS: 999, tvOS: 999, watchOS: 999, visionOS: 999) == false)
    }

    @Test func testIsAvailableTuple() async throws {
        let major = AdaptivePlatformVersion.currentMajor
        
        // checking current major with minor 0 should be true on any platform we run on
        #expect(AdaptivePlatformVersion.isAvailable(iOS: (major, 0), macOS: (major, 0), tvOS: (major, 0), watchOS: (major, 0), visionOS: (major, 0)) == true)
        
        // checking a far future version should be false
        #expect(AdaptivePlatformVersion.isAvailable(iOS: (999, 0), macOS: (999, 0), tvOS: (999, 0), watchOS: (999, 0), visionOS: (999, 0)) == false)
    }

    @Test func testRunIf() async throws {
        var executed = false
        AdaptivePlatformVersion.runIf(true) {
            executed = true
        }
        #expect(executed == true)
        
        var executedFalse = false
        AdaptivePlatformVersion.runIf(false) {
            executedFalse = true
        }
        #expect(executedFalse == false)
        
        let value = AdaptivePlatformVersion.runIf(true, then: { "yes" }, else: { "no" })
        #expect(value == "yes")
        
        let value2 = AdaptivePlatformVersion.runIf(false, then: { "yes" }, else: { "no" })
        #expect(value2 == "no")
    }

    @available(iOS 13.0, macOS 10.15, tvOS 13.0, watchOS 6.0, *)
    @Test func testSwiftUIConditionalExtensions() async throws {
        let view = Text("Hello")
        
        // Test .if(condition) transform compiles and runs successfully
        let _ = view.if(true) { $0.bold() }
        let _ = view.if(false) { $0.bold() }
        
        // Test .if(condition, then, else) transform compiles and runs successfully
        let _ = view.if(true, then: { $0.italic() }, else: { $0.bold() })
        let _ = view.if(false, then: { $0.italic() }, else: { $0.bold() })
    }
}

