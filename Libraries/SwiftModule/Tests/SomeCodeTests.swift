import XCTest
import SwiftModule

final class Tests: XCTestCase {
    func test() {
        XCTAssertEqual(text, "Hello, World!")
    }

    func testResourceInRoot() {
        // The content of the file should be nil because during unit testing there is no bundle containing the resources
        XCTAssertEqual(textFileContent, nil)
    }

    func testResourceInSubdirectory() {
        // The content of the file should be nil because during unit testing there is no bundle containing the resources
        XCTAssertEqual(textFileContent2, nil)
    }
}
