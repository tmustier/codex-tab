import Foundation

public struct CodexTabTitles: Sendable, Equatable {
    public var newTitle: String
    public var runningTitle: String
    public var doneTitle: String
    public var noCommitTitle: String
    public var timeoutTitle: String

    public init(
        newTitle: String,
        runningTitle: String,
        doneTitle: String,
        noCommitTitle: String,
        timeoutTitle: String
    ) {
        self.newTitle = newTitle
        self.runningTitle = runningTitle
        self.doneTitle = doneTitle
        self.noCommitTitle = noCommitTitle
        self.timeoutTitle = timeoutTitle
    }

    public static let defaults = CodexTabTitles(
        newTitle: "codex:new",
        runningTitle: "codex:running...",
        doneTitle: "codex:✅",
        noCommitTitle: "codex:🚧",
        timeoutTitle: "codex:🛑"
    )

    public func applyingSpec(_ spec: String) throws -> CodexTabTitles {
        try CodexTabTitles.parseSpec(spec, base: self)
    }

    public static func parseSpec(_ spec: String, base: CodexTabTitles = .defaults) throws -> CodexTabTitles {
        let trimmed = spec.trimmingCharacters(in: .whitespacesAndNewlines)
        if trimmed.isEmpty {
            return base
        }

        if !trimmed.contains("=") {
            return try parseOrderedSpec(trimmed)
        }

        var titles = base
        for rawPart in trimmed.split(separator: ",", omittingEmptySubsequences: true) {
            let part = rawPart.trimmingCharacters(in: .whitespacesAndNewlines)
            guard let eq = part.firstIndex(of: "=") else {
                throw TitlesSpecError.invalidPair(part)
            }
            let key = part[..<eq].trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let value = stripQuotes(part[part.index(after: eq)...].trimmingCharacters(in: .whitespacesAndNewlines))

            switch key {
            case "new":
                titles.newTitle = value
            case "running":
                titles.runningTitle = value
            case "done":
                titles.doneTitle = value
            case "no_commit", "no-commit":
                titles.noCommitTitle = value
            case "timeout":
                titles.timeoutTitle = value
            default:
                throw TitlesSpecError.unknownKey(key)
            }
        }

        return titles
    }

    private static func parseOrderedSpec(_ spec: String) throws -> CodexTabTitles {
        let parts = spec.split(separator: "|", omittingEmptySubsequences: false).map(String.init)
        guard parts.count == 5 else {
            throw TitlesSpecError.invalidOrderedCount(parts.count)
        }
        return CodexTabTitles(
            newTitle: parts[0],
            runningTitle: parts[1],
            doneTitle: parts[2],
            noCommitTitle: parts[3],
            timeoutTitle: parts[4]
        )
    }

    private static func stripQuotes(_ value: String) -> String {
        guard let first = value.first, let last = value.last, value.count >= 2 else {
            return value
        }
        if (first == "\"" && last == "\"") || (first == "'" && last == "'") {
            return String(value.dropFirst().dropLast())
        }
        return value
    }
}

public enum TitlesSpecError: Error, CustomStringConvertible {
    case invalidOrderedCount(Int)
    case invalidPair(String)
    case unknownKey(String)

    public var description: String {
        switch self {
        case let .invalidOrderedCount(count):
            return "Expected 5 '|' separated titles (got \(count))."
        case let .invalidPair(pair):
            return "Invalid title spec segment: \(pair)"
        case let .unknownKey(key):
            return "Unknown title key: \(key)"
        }
    }
}

