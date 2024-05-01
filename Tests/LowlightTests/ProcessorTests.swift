import XCTest
import Lowlight

final class ProcessorTests: XCTestCase {
	func testLineComments() throws {
		let language = Language(patterns: [Pattern(element: .comment, match: .toEndOfLine("//"))])
		let processor = Processor(language: language)

		let input = """
// leading comment
   // after whitespace
abc def // trailing comment
// comment inside // comment
"""

		let tokens = processor.processTokens(for: input)
		let expected = [
			Token(.comment, range: NSRange(0..<18)),
			Token(.comment, range: NSRange(22..<41)),
			Token(.comment, range: NSRange(50..<69)),
			Token(.comment, range: NSRange(70..<98)),
		]

		XCTAssertEqual(tokens, expected)
	}

	func testSingleExactMatch() throws {
		let language = Language(patterns: [Pattern(element: .keyword, match: .exact("abc"))])
		let processor = Processor(language: language)

		let tokens = processor.processTokens(for: "abc ")

		let expected = [
			Token(.keyword, range: NSRange(0..<3)),
		]

		XCTAssertEqual(tokens, expected)
	}

	func testSingleExactMatchEOF() throws {
		let language = Language(patterns: [Pattern(element: .keyword, match: .exact("abc"))])
		let processor = Processor(language: language)

		let tokens = processor.processTokens(for: "abc")

		let expected = [
			Token(.keyword, range: NSRange(0..<3)),
		]

		XCTAssertEqual(tokens, expected)
	}

	func testExactMatches() throws {
		let language = Language(patterns: [Pattern(element: .keyword, match: .exact("abc"))])
		let processor = Processor(language: language)

		let input = """
abc
dabc abc
 abc
abcabc
"""

		let tokens = processor.processTokens(for: input)
		let expected = [
			Token(.keyword, range: NSRange(0..<3)),
			Token(.keyword, range: NSRange(9..<12)),
			Token(.keyword, range: NSRange(14..<17)),
		]

		XCTAssertEqual(tokens, expected)
	}

	func testEndOfLineFollowedByNewlineThenExact() throws {
		let language = Language(keywords: ["abc"], lineComment: "--")
		let processor = Processor(language: language)

		let input = """
-- comment

abc def
"""

		let tokens = processor.processTokens(for: input)
		let expected = [
			Token(.comment, range: NSRange(0..<10)),
			Token(.keyword, range: NSRange(12..<15)),
		]

		XCTAssertEqual(tokens, expected)
	}
}
