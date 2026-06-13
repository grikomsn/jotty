import SwiftUI

struct SummaryExportSheet: View {
    let note: Note
    let summary: NoteSummary
    @Environment(\.dismiss) private var dismiss
    @State private var pdfURL: URL?
    @State private var exportError: String?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    section("Key idea") {
                        Text(summary.keyIdeas.joined(separator: "\n\n"))
                            .font(.body)
                            .foregroundStyle(Color.jottyInk)
                    }

                    section("Actions") {
                        VStack(alignment: .leading, spacing: 10) {
                            ForEach(summary.actionItems, id: \.self) { item in
                                Label(item, systemImage: "arrow.right.circle")
                                    .font(.callout)
                                    .foregroundStyle(Color.jottyInk)
                            }
                        }
                    }

                    section("Themes") {
                        FlowTags(items: summary.themes)
                    }

                    VStack(spacing: 12) {
                        Button {
                            exportPDF()
                        } label: {
                            Label("Export PDF", systemImage: "doc.richtext")
                                .frame(maxWidth: .infinity)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(.jottyInk)

                        if let pdfURL {
                            ShareLink(item: pdfURL) {
                                Label("Share PDF", systemImage: "square.and.arrow.up")
                                    .frame(maxWidth: .infinity)
                            }
                            .buttonStyle(.bordered)
                        }

                        if let exportError {
                            Text(exportError)
                                .font(.caption)
                                .foregroundStyle(.red)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                }
                .padding(20)
            }
            .background(Color.jottyPaper.ignoresSafeArea())
            .navigationTitle("Summary")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }

    private func section<Content: View>(_ title: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(title)
                .font(.headline)
                .foregroundStyle(Color.jottyInk)
            content()
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(.white.opacity(0.75), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
    }

    private func exportPDF() {
        do {
            pdfURL = try PDFExportService.makePDF(note: note, summary: summary)
            exportError = nil
        } catch {
            exportError = "Could not create the PDF. Try again."
        }
    }
}

private struct FlowTags: View {
    let items: [String]

    var body: some View {
        HStack {
            ForEach(items, id: \.self) { item in
                Text(item)
                    .font(.caption.weight(.semibold))
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(Color.jottySage.opacity(0.16), in: Capsule())
                    .foregroundStyle(Color.jottyInk)
            }
        }
    }
}

#Preview {
    SummaryExportSheet(
        note: Note.samples[0],
        summary: NoteSummarizer.summarize(Note.samples[0])
    )
}
