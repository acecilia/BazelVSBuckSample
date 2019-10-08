import XCTest
@testable import SwiftApp

final class Tests: XCTestCase {
    func testBundleAccess() {
        XCTAssertEqual(swiftModuleTextFileContent, "Hello, World!")
        XCTAssertEqual(swiftModuleTextFileContent2, "Hello, World!")
    }

    func testHostAppExists() {
        let delegateText = (UIApplication.shared.delegate as? AppDelegate)?.text
        XCTAssertEqual(delegateText, "This is an internal property in the app delegate!")
    }
}
