import XCTest
import SwiftModuleWithPrebuiltDependency

final class Tests: XCTestCase {
    func test() {
        XCTAssertEqual(text1, "Objc dependency version: 1.0")
        XCTAssertEqual(text2, "Swift dependency version: v5.0.0")
    }
}
