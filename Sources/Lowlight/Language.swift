import Foundation

public struct Pattern: Hashable, Sendable {
	public enum Behavior: Hashable, Sendable {
		case exact(String)
		case toEndOfLine(String)

		public func matches(_ character: Character, at offset: Int) -> Bool {
			switch self {
			case let .exact(string):
				let patternIdx = string.index(string.startIndex, offsetBy: offset)

				return string[patternIdx] == character
			case let .toEndOfLine(string):
				let patternIdx = string.index(string.startIndex, offsetBy: offset)

				return string[patternIdx] == character
			}
		}
	}

	public enum Element: Hashable, Sendable {
		case keyword
		case comment

		public var treeSitterHighlightName: String {
			switch self {
			case .comment:
				"comment"
			case .keyword:
				"keyword"
			}
		}
	}

	public let element: Element
	public let match: Behavior

	public init(element: Element, match: Behavior) {
		self.element = element
		self.match = match
	}
}

/// The model of the Lowlight language.
public struct Language: Hashable, Sendable {
	public let patterns: Set<Pattern>

	public init(patterns: Set<Pattern>) {
		self.patterns = patterns
	}

	public init(keywords: Set<String>, lineComment: String) {
		let keywordPatterns = keywords.map({ Pattern(element: .keyword, match: .exact($0)) })
		let patterns = keywordPatterns + [.init(element: .comment, match: .toEndOfLine(lineComment))]

		self.init(patterns: Set(patterns))
	}
}
