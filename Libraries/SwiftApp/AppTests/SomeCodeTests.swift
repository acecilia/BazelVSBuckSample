import XCTest
@testable import SwiftApp

final class Tests: XCTestCase {
    func test() {
        let text = (UIApplication.shared.delegate as? AppDelegate)?.text
        XCTAssertEqual(text, "This is the app delegate!")
    }
}
