import Foundation

/// The model of the Lowlight language.
public struct Language: Codable, Hashable, Sendable {
	public let keywords: Set<String>
	public let symbols: Set<String>

	public init(keywords: Set<String> = [], symbols: Set<String> = []) {
		self.keywords = keywords
		self.symbols = symbols
	}

	var keywordPattern: String {
		"(" + keywords.joined(separator: "|") + ")"
	}

	var symbolsPattern: String {
		"(" + symbols.joined(separator: "|") + ")"
	}
}
