import Foundation

struct NoteSummary: Identifiable, Hashable {
    let id = UUID()
    var headline: String
    var keyIdeas: [String]
    var actionItems: [String]
    var themes: [String]
    var generatedAt: Date = Date()
}

enum NoteSummarizer {
    static func summarize(_ note: Note) -> NoteSummary {
        let lines = note.body
            .split(whereSeparator: \.isNewline)
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let sentences = note.body
            .components(separatedBy: CharacterSet(charactersIn: ".!?"))
            .map { $0.trimmingCharacters(in: .whitespacesAndNewlines) }
            .filter { !$0.isEmpty }

        let actionItems = lines
            .filter { line in
                let lowercased = line.lowercased()
                return line.hasPrefix("-")
                    || lowercased.contains("try ")
                    || lowercased.contains("draft ")
                    || lowercased.contains("make ")
                    || lowercased.contains("ship ")
                    || lowercased.contains("save ")
            }
            .map { $0.trimmingCharacters(in: CharacterSet(charactersIn: "- "))}

        let keyIdeas = Array(sentences.prefix(3))
        let themes = topThemes(from: note.body)

        return NoteSummary(
            headline: headline(for: note, fallback: sentences.first),
            keyIdeas: keyIdeas.isEmpty ? ["No clear idea yet. Add a few lines, then summarize again."] : keyIdeas,
            actionItems: actionItems.isEmpty ? ["Choose one next action from this note."] : Array(actionItems.prefix(4)),
            themes: themes
        )
    }

    private static func headline(for note: Note, fallback: String?) -> String {
        if !note.title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            return note.title
        }
        return fallback ?? "Untitled thought"
    }

    private static func topThemes(from body: String) -> [String] {
        let stopWords: Set<String> = [
            "about", "after", "again", "also", "and", "before", "but", "can", "for",
            "from", "have", "into", "like", "not", "one", "should", "that", "the",
            "this", "today", "with", "would", "you"
        ]

        let words = body
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { $0.count > 3 && !stopWords.contains($0) }

        let counts = Dictionary(grouping: words, by: { $0 }).mapValues(\.count)
        let themes = counts
            .sorted { lhs, rhs in
                if lhs.value == rhs.value { return lhs.key < rhs.key }
                return lhs.value > rhs.value
            }
            .prefix(3)
            .map { $0.key.capitalized }

        return themes.isEmpty ? ["Reflection"] : themes
    }
}
