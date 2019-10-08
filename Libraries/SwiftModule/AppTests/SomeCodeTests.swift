import XCTest
import SwiftModule

final class Tests: XCTestCase {
    func testResourceInRoot() {
        XCTAssertEqual(textFileContent, "Hello, World!")
    }

    func testResourceInSubdirectory() {
        XCTAssertEqual(textFileContent2, "Hello, World!")

    }
}
