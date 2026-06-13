import Foundation

struct Note: Identifiable, Hashable, Codable {
    var id: UUID = UUID()
    var title: String
    var body: String
    var mood: NoteMood
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var isArchived: Bool = false
}

enum NoteMood: String, CaseIterable, Codable, Identifiable {
    case spark
    case calm
    case plan

    var id: String { rawValue }

    var title: String {
        switch self {
        case .spark: "Spark"
        case .calm: "Calm"
        case .plan: "Plan"
        }
    }

    var systemImage: String {
        switch self {
        case .spark: "sparkles"
        case .calm: "leaf"
        case .plan: "checklist"
        }
    }
}

extension Note {
    static let samples: [Note] = [
        Note(
            title: "Morning ideas",
            body: """
            What would make today feel lighter?

            Try a thirty minute sketch of the onboarding flow before checking messages. The point is momentum, not polish.

            Potential action:
            - Draft the first note card interaction
            - Save the strong examples for the evening review
            """,
            mood: .spark,
            createdAt: .now.addingTimeInterval(-7_200),
            updatedAt: .now.addingTimeInterval(-3_600)
        ),
        Note(
            title: "Little product bets",
            body: """
            The app should feel like a place to catch raw thinking before it gets too serious.

            Small bets:
            - Keep the editor quiet
            - Make summary feel like a helpful second look
            - Export should create something clean enough to share
            """,
            mood: .plan,
            createdAt: .now.addingTimeInterval(-86_400),
            updatedAt: .now.addingTimeInterval(-80_000)
        ),
        Note(
            title: "Things worth trying",
            body: """
            Use one prompt per day. Keep it short enough that it does not become homework.

            A good prompt should start movement: What is one thing I am avoiding that would take less than ten minutes?
            """,
            mood: .calm,
            createdAt: .now.addingTimeInterval(-172_800),
            updatedAt: .now.addingTimeInterval(-170_000)
        )
    ]
}
