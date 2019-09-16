import XCTest
import SwiftModuleWithPrebuiltDependency

final class Tests: XCTestCase {
    func test() {
        XCTAssertEqual(text1, "1.0")
        XCTAssertEqual(text2, "v5.0.0")
    }
}
