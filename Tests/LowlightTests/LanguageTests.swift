import XCTest
import Lowlight

final class LanguageTests: XCTestCase {
    func testLanguageWithOneKeyword() throws {
        let language = Language()

		XCTAssertNotNil(language)
    }
}
