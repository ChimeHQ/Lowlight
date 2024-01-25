/// Represents a range in the input with an associated identifier.
public struct Token: Hashable, Sendable {

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
		Output(tokens: [], scopes: [])
	}

	public func processTokens(for input: String) -> [Token] {
		[]
	}

	public func processScopes(for input: String) -> [Scope] {
		[]
	}
}
