import Foundation
import Observation

@Observable
final class NoteStore {
    var notes: [Note]

    init(notes: [Note] = Note.samples) {
        self.notes = notes
    }

    var activeNotes: [Note] {
        notes
            .filter { !$0.isArchived }
            .sorted { $0.updatedAt > $1.updatedAt }
    }

    var archivedNotes: [Note] {
        notes
            .filter(\.isArchived)
            .sorted { $0.updatedAt > $1.updatedAt }
    }

    @discardableResult
    func createNote() -> Note.ID {
        let note = Note(
            title: "Untitled thought",
            body: "",
            mood: .spark
        )
        notes.insert(note, at: 0)
        return note.id
    }

    func note(id: Note.ID) -> Note? {
        notes.first { $0.id == id }
    }

    func update(_ note: Note) {
        guard let index = notes.firstIndex(where: { $0.id == note.id }) else { return }
        var updated = note
        updated.updatedAt = Date()
        notes[index] = updated
    }

    func archive(id: Note.ID) {
        guard let index = notes.firstIndex(where: { $0.id == id }) else { return }
        notes[index].isArchived = true
        notes[index].updatedAt = Date()
    }

    func restore(id: Note.ID) {
        guard let index = notes.firstIndex(where: { $0.id == id }) else { return }
        notes[index].isArchived = false
        notes[index].updatedAt = Date()
    }
}
