import SwiftUI

struct ArchiveView: View {
    let store: NoteStore

    var body: some View {
        NavigationStack {
            List {
                if store.archivedNotes.isEmpty {
                    EmptyStateView(
                        title: "Archive is quiet",
                        message: "Finished notes can rest here when you are ready."
                    )
                    .listRowBackground(Color.clear)
                    .listRowSeparator(.hidden)
                } else {
                    ForEach(store.archivedNotes) { note in
                        VStack(alignment: .leading, spacing: 6) {
                            Text(note.title)
                                .font(.headline)
                            Text(note.body)
                                .font(.callout)
                                .foregroundStyle(Color.jottyInk.opacity(0.66))
                                .lineLimit(2)
                        }
                        .swipeActions {
                            Button("Restore") {
                                store.restore(id: note.id)
                            }
                            .tint(.jottySage)
                        }
                    }
                }
            }
            .scrollContentBackground(.hidden)
            .background(Color.jottyPaper.ignoresSafeArea())
            .navigationTitle("Archive")
            .toolbarBackground(Color.jottyPaper, for: .navigationBar)
        }
    }
}

#Preview {
    ArchiveView(store: NoteStore())
}
