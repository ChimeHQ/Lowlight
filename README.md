<div align="center">

[![Build Status][build status badge]][build status]
[![Discord][discord badge]][discord]

</div>

# Lowlight
A simple syntax processing system that priorities latency over correctness

- O(1) "parsing"
- Very simple data-based description of languages
- Get information about tokens and scopes

You may be wondering why someone would ever want something like this. To do accurate syntax analysis, you have to parse. Parsing requires processing a document, in its entirety, from beginning to end.

- The parsing system itself requires initialization
- The document must then be parsed
- Some queries must be run over the parse tree to get the needed information

All of these components require non-zero time, and that time scales, at best, linearly with the size of the document. Lowlight can process fragments of documents, and can do it in O(1) time. It does not produce parse trees, only enough information to make reasonable guesses at tokens and scopes.

Lowlight is useful as very fast first pass. It fits in well with a multi-pass highlighting system like [Neon][neon].

> [!WARNING]
> This is currenty very WIP.

## Installation

```swift
dependencies: [
    .package(url: "https://github.com/ChimeHQ/Lowlight", branch: "main")
],
```

## Contributing and Collaboration

I would love to hear from you! Issues, Discussions, or pull requests work great. A [Discord server][discord] is also available for live help, but I have a strong bias towards answering in the form of documentation.

I prefer collaboration, and would love to find ways to work together if you have a similar project.

I prefer indentation with tabs for improved accessibility. But, I'd rather you use the system you want and make a PR than hesitate because of whitespace.

By participating in this project you agree to abide by the [Contributor Code of Conduct](CODE_OF_CONDUCT.md).

[build status]: https://github.com/ChimeHQ/Lowlight/actions
[build status badge]: https://github.com/ChimeHQ/Lowlight/workflows/CI/badge.svg
[discord]: https://discord.gg/esFpX6sErJ
[discord badge]: https://img.shields.io/badge/Discord-purple?logo=Discord&label=Chat&color=%235A64EC
[neon]: https://github.com/ChimeHQ/Neon
