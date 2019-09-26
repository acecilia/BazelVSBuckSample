import XCTest
@testable import SwiftApp

final class Tests: XCTestCase {
    func test() {
        XCTAssertEqual(text, "This is an internal property in the app code!")
        XCTAssertEqual(swiftModuleText, "Hello, World!")
        XCTAssertEqual(swiftModuleWithoutTestsText, "Hello, World!")
        XCTAssertEqual(swiftModuleWithPrebuiltDependencyText1, "AFNetworking version: 1.0")
        XCTAssertEqual(swiftModuleWithPrebuiltDependencyText2, "FileKit version: v5.0.0")
    }

    func testHostAppDoesNotExist() {
        let delegateText = (UIApplication.shared.delegate as? AppDelegate)?.text
        XCTAssertEqual(delegateText, nil)
    }
}
