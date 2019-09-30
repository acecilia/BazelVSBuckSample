import XCTest
import SwiftModule

final class Tests: XCTestCase {
    func testResources() {
        XCTAssertEqual(textFileContent, "Hello, World!")
    }
}
