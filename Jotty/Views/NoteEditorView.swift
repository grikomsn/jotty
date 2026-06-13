import SwiftUI

struct NoteEditorView: View {
    let store: NoteStore
    let noteID: Note.ID

    var body: some View {
        if store.note(id: noteID) != nil {
            NoteEditorContent(note: noteBinding)
        } else {
            EmptyStateView(
                title: "Note moved",
                message: "This note is no longer available."
            )
            .padding()
            .background(Color.jottyPaper.ignoresSafeArea())
        }
    }

    private var noteBinding: Binding<Note> {
        Binding(
            get: {
                store.note(id: noteID) ?? Note(title: "Missing note", body: "", mood: .calm)
            },
            set: { updatedNote in
                store.update(updatedNote)
            }
        )
    }
}

private struct NoteEditorContent: View {
    @Binding var note: Note
    @State private var summaryPresentation: SummaryPresentation?
    @State private var selectedMood: NoteMood = .spark

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                moodPicker

                TextField("Title", text: $note.title)
                    .font(.system(.title2, design: .serif).weight(.semibold))
                    .textFieldStyle(.plain)
                    .padding(.top, 4)

                TextEditor(text: $note.body)
                    .font(.body)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 320)
                    .padding(12)
                    .background(.white.opacity(0.74), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    .overlay {
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(.black.opacity(0.07), lineWidth: 1)
                    }

                Button {
                    summaryPresentation = SummaryPresentation(
                        note: note,
                        summary: NoteSummarizer.summarize(note)
                    )
                } label: {
                    Label("Summarize", systemImage: "wand.and.stars")
                        .frame(maxWidth: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.jottyInk)
                .disabled(note.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
            }
            .padding(20)
        }
        .background(Color.jottyPaper.ignoresSafeArea())
        .navigationTitle(note.title.isEmpty ? "Untitled" : note.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Menu {
                    Button {
                        summaryPresentation = SummaryPresentation(
                            note: note,
                            summary: NoteSummarizer.summarize(note)
                        )
                    } label: {
                        Label("Summarize", systemImage: "wand.and.stars")
                    }

                    Button {
                        summaryPresentation = SummaryPresentation(
                            note: note,
                            summary: NoteSummarizer.summarize(note)
                        )
                    } label: {
                        Label("Export PDF", systemImage: "doc.richtext")
                    }
                } label: {
                    Image(systemName: "ellipsis.circle")
                }
            }
        }
        .sheet(item: $summaryPresentation) { presentation in
            SummaryExportSheet(note: presentation.note, summary: presentation.summary)
                .presentationDetents([.medium, .large])
        }
        .onAppear {
            selectedMood = note.mood
        }
        .onChange(of: selectedMood) { _, newValue in
            note.mood = newValue
        }
    }

    private var moodPicker: some View {
        Picker("Mood", selection: $selectedMood) {
            ForEach(NoteMood.allCases) { mood in
                Label(mood.title, systemImage: mood.systemImage)
                    .tag(mood)
            }
        }
        .pickerStyle(.segmented)
    }
}

private struct SummaryPresentation: Identifiable {
    let id = UUID()
    let note: Note
    let summary: NoteSummary
}

#Preview {
    NavigationStack {
        NoteEditorView(store: NoteStore(), noteID: Note.samples[0].id)
    }
}
