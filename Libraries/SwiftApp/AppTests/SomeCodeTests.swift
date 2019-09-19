import XCTest
@testable import SwiftApp

final class Tests: XCTestCase {
    func testHostAppExists() {
        let delegateText = (UIApplication.shared.delegate as? AppDelegate)?.text
        XCTAssertEqual(delegateText, "This is an internal property in the app delegate!")
    }
}
