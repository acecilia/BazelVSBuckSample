import XCTest
import SwiftModuleWithPrebuiltDependency

final class Tests: XCTestCase {
    func test() {
        XCTAssertEqual(text1, "AFNetworking version: 1.0")
        XCTAssertEqual(text2, "FileKit version: v5.0.0")
    }
}
