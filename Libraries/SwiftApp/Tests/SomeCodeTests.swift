import XCTest
@testable import SwiftApp

final class Tests: XCTestCase {
    func test() {
        XCTAssertEqual(text, "This is a public property in the app code!")
    }

    func testHostAppDoesNotExist() {
        let delegateText = (UIApplication.shared.delegate as? AppDelegate)?.text
        XCTAssertEqual(delegateText, nil)
    }
}
