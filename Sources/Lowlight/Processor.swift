import Foundation

/// Represents a range in the input with an associated identifier.
public struct Token: Hashable, Sendable {
	public let element: Pattern.Element
	public let range: NSRange

	public init(_ element: Pattern.Element, range: NSRange) {
		self.element = element
		self.range = range
	}

	init(_ pattern: Pattern, input: String, start: String.Index, offset: Int) {
		let end = input.index(start, offsetBy: offset)

		self.range = NSRange(start..<end, in: input)
		self.element = pattern.element
	}
}

/// Represents a textual scope.
public struct Scope: Hashable, Sendable {

}

extension CharacterSet {
	func contains(_ character: Character) -> Bool {
		character.unicodeScalars.allSatisfy { contains($0) }
	}
}

/// Type that uses a language model to produce tokens and scopes.
public struct Processor {
	public struct Output: Hashable, Sendable {
		public let tokens: [Token]
		public let scopes: [Scope]
	}

	private enum State {
		case scanning
		case matching(patterns: Set<Pattern>, start: String.Index, length: Int)
		case matched(Pattern, start: String.Index, length: Int)
		case advancingUntil(CharacterSet, pattern: Pattern, start: String.Index)
		case skipping
		case advanceToBoundary

		mutating func advance() {
			guard case let .matching(patterns: patterns, start: start, length: length) = self else {
				fatalError()
			}

			self = .matching(patterns: patterns, start: start, length: length + 1)
		}
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
		var state = State.scanning
		var tokens = [Token]()

		var index = input.startIndex
		let patterns = language.patterns
		let anchors = CharacterSet.whitespacesAndNewlines

		while index < input.endIndex {
			let char = input[index]

			switch state {
			case .scanning:
				let possible = patterns.filter { $0.match.matches(char, at: 0) }

				if possible.isEmpty {
					state = .skipping
					continue
				}

				state = .matching(patterns: possible, start: index, length: 1)
			case .skipping:
				if anchors.contains(char) {
					state = .advanceToBoundary
				}
			case .advanceToBoundary:
				if anchors.contains(char) == false {
					state = .scanning
					continue
				}
			case let .matching(patterns: active, start: start, length: length):
				let newLength = length + 1

				let remaining = active.filter { $0.match.matches(char, at: length) }

				// no matches, continue
				guard remaining.isEmpty == false else {
					state = .scanning
					continue
				}

				// more than one match, keep going
				guard let pattern = remaining.first, remaining.count == 1 else {
					state = .matching(patterns: remaining, start: start, length: newLength)
					break
				}

				switch pattern.match {
				case let .exact(value):
					if newLength < value.count {
						state = .matching(patterns: remaining, start: start, length: newLength)
						break
					}

					state = .matched(pattern, start: start, length: newLength)
				case .toEndOfLine:
					state = .advancingUntil(.newlines, pattern: pattern, start: start)
				}
			case let .matched(pattern, start: start, length: length):
				if anchors.contains(char) == false {
					state = .skipping
					break
				}

				tokens.append(Token(pattern, input: input, start: start, offset: length))

				state = .scanning
			case let .advancingUntil(charSet, pattern: pattern, start: start):
				guard charSet.contains(char) else {
					break
				}

				let range = NSRange(start..<index, in: input)

				tokens.append(Token(pattern.element, range: range))

				state = .scanning
				continue
			}

			index = input.index(after: index)
		}

		switch state {
		case let .advancingUntil(_, pattern: pattern, start: start):
			let range = NSRange(start..<index, in: input)

			tokens.append(Token(pattern.element, range: range))
		case let .matched(pattern, start: start, length: length):
			tokens.append(Token(pattern, input: input, start: start, offset: length))
		default:
			break
		}

		return tokens
	}

	public func processScopes(for input: String) -> [Scope] {
		[]
	}
}
