import Foundation

/// Represents a range in the input with an associated identifier.
public struct Token: Hashable, Sendable {
	public let name: String
	public let range: NSRange
}

/// Represents a textual scope.
public struct Scope: Hashable, Sendable {

}

/// Type that uses a language model to produce tokens and scopes.
public struct Processor {
	public struct Output: Hashable, Sendable {
		public let tokens: [Token]
		public let scopes: [Scope]
	}

	public let language: Language

	public init(language: Language) {
		self.language = language
	}

	public func process(_ input: String) -> Output {
		.init(
			tokens: processTokens(for: input),
			scopes: processScopes(for: input)
		)
	}

	public func processTokens(for input: String) -> [Token] {
		var tokens = [Token]()

		if let pattern = try? NSRegularExpression(pattern: language.keywordPattern), language.keywords.isEmpty == false {
			let matches = pattern.matches(in: input, range: NSRange(0..<input.utf16.count))

			for match in matches {
				let range = match.range(at: 0)
				guard range.length > 0 else { continue }

				tokens.append(Token(name: "keyword", range: range))
			}
		}

		if let pattern = try? NSRegularExpression(pattern: language.symbolsPattern), language.symbols.isEmpty == false {
			let matches = pattern.matches(in: input, range: NSRange(0..<input.utf16.count))

			for match in matches {
				let range = match.range(at: 0)
				guard range.length > 0 else { continue }

				tokens.append(Token(name: "keyword.operator.text", range: range))
			}
		}

		return tokens
	}

	public func processScopes(for input: String) -> [Scope] {
		[]
	}
}
