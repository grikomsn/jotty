import Foundation
import UIKit

enum PDFExportService {
    static func makePDF(note: Note, summary: NoteSummary? = nil) throws -> URL {
        let pageBounds = CGRect(x: 0, y: 0, width: 595, height: 842)
        let margin: CGFloat = 52
        let renderer = UIGraphicsPDFRenderer(bounds: pageBounds)
        let filename = "\(sanitizedFilename(note.title))-jotty.pdf"
        let url = FileManager.default.temporaryDirectory.appendingPathComponent(filename)

        try renderer.writePDF(to: url) { context in
            var y = margin

            func beginPageIfNeeded(for height: CGFloat) {
                if y + height > pageBounds.height - margin {
                    context.beginPage()
                    y = margin
                }
            }

            func drawText(_ text: String, font: UIFont, color: UIColor = .label, spacing: CGFloat = 12) {
                let rect = CGRect(x: margin, y: y, width: pageBounds.width - (margin * 2), height: .greatestFiniteMagnitude)
                let attributes: [NSAttributedString.Key: Any] = [
                    .font: font,
                    .foregroundColor: color
                ]
                let attributed = NSAttributedString(string: text, attributes: attributes)
                let measured = attributed.boundingRect(
                    with: CGSize(width: rect.width, height: .greatestFiniteMagnitude),
                    options: [.usesLineFragmentOrigin, .usesFontLeading],
                    context: nil
                )
                beginPageIfNeeded(for: ceil(measured.height) + spacing)
                attributed.draw(in: CGRect(x: rect.minX, y: y, width: rect.width, height: ceil(measured.height)))
                y += ceil(measured.height) + spacing
            }

            context.beginPage()
            drawText("Jotty", font: .systemFont(ofSize: 14, weight: .semibold), color: .secondaryLabel, spacing: 18)
            drawText(note.title.isEmpty ? "Untitled thought" : note.title, font: .systemFont(ofSize: 30, weight: .bold), spacing: 20)
            drawText(note.body.isEmpty ? "No note body yet." : note.body, font: .systemFont(ofSize: 13), spacing: 24)

            if let summary {
                drawText("Summary", font: .systemFont(ofSize: 18, weight: .bold), spacing: 12)
                drawText(summary.keyIdeas.joined(separator: "\n\n"), font: .systemFont(ofSize: 13), spacing: 16)
                drawText("Actions", font: .systemFont(ofSize: 15, weight: .semibold), spacing: 8)
                drawText(summary.actionItems.map { "- \($0)" }.joined(separator: "\n"), font: .systemFont(ofSize: 13), spacing: 16)
            }
        }

        return url
    }

    private static func sanitizedFilename(_ value: String) -> String {
        let trimmed = value.trimmingCharacters(in: .whitespacesAndNewlines)
        let fallback = trimmed.isEmpty ? "untitled-thought" : trimmed
        let safe = fallback
            .lowercased()
            .components(separatedBy: CharacterSet.alphanumerics.inverted)
            .filter { !$0.isEmpty }
            .joined(separator: "-")
        return safe.isEmpty ? "untitled-thought" : safe
    }
}
