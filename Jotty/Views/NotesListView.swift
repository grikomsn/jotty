import SwiftUI

struct NotesListView: View {
    let store: NoteStore
    @State private var path: [Note.ID] = []

    var body: some View {
        NavigationStack(path: $path) {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    header

                    if store.activeNotes.isEmpty {
                        EmptyStateView(
                            title: "Nothing here yet",
                            message: "Start with one loose thought. Jotty can shape it later."
                        )
                    } else {
                        LazyVStack(spacing: 12) {
                            ForEach(store.activeNotes) { note in
                                Button {
                                    path.append(note.id)
                                } label: {
                                    NoteCard(note: note)
                                }
                                .buttonStyle(.plain)
                            }
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.jottyPaper.ignoresSafeArea())
            .navigationTitle("")
            .toolbar(.hidden, for: .navigationBar)
            .navigationDestination(for: Note.ID.self) { noteID in
                NoteEditorView(store: store, noteID: noteID)
            }
        }
    }

    private var header: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(alignment: .center) {
                Text("Jotty")
                    .font(.system(size: 44, weight: .bold, design: .serif))
                    .foregroundStyle(Color.jottyInk)

                Spacer()

                Button {
                    path.append(store.createNote())
                } label: {
                    Label("New", systemImage: "square.and.pencil")
                        .font(.headline)
                }
                .buttonStyle(.borderedProminent)
                .tint(.jottyAmber)
            }
            .padding(.bottom, 12)

            Text("Daily brainstorming")
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(Color.jottyInk.opacity(0.64))

            Text("Catch the thought while it is still warm.")
                .font(.system(.title2, design: .serif).weight(.semibold))
                .foregroundStyle(Color.jottyInk)

            Text("Summaries and PDF export are ready as simple local tools. The smarter version can come next.")
                .font(.callout)
                .foregroundStyle(Color.jottyInk.opacity(0.68))
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
}

private struct NoteCard: View {
    let note: Note

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(alignment: .firstTextBaseline) {
                Label(note.mood.title, systemImage: note.mood.systemImage)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(note.mood.tint)

                Spacer()

                Text(note.updatedAt.jottyRelativeLabel)
                    .font(.caption)
                    .foregroundStyle(Color.jottyInk.opacity(0.58))
            }

            Text(note.title)
                .font(.headline)
                .foregroundStyle(Color.jottyInk)
                .lineLimit(1)

            Text(note.body.isEmpty ? "Tap to start writing." : note.body)
                .font(.callout)
                .foregroundStyle(Color.jottyInk.opacity(0.66))
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
        .overlay {
            RoundedRectangle(cornerRadius: 8, style: .continuous)
                .stroke(.black.opacity(0.06), lineWidth: 1)
        }
    }
}

struct EmptyStateView: View {
    var title: String
    var message: String

    var body: some View {
        VStack(spacing: 10) {
            Image(systemName: "note.text.badge.plus")
                .font(.title)
                .foregroundStyle(Color.jottySage)
            Text(title)
                .font(.headline)
            Text(message)
                .font(.callout)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
        .padding(24)
        .background(Color.jottyCard, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }
}

#Preview {
    NotesListView(store: NoteStore())
}
