import SwiftUI

struct AppShell: View {
    let store: NoteStore
    @State private var selectedTab: AppTab = .notes

    var body: some View {
        Group {
            switch selectedTab {
            case .notes:
                NotesListView(store: store)
            case .ideas:
                IdeasView()
            case .archive:
                ArchiveView(store: store)
            }
        }
        .safeAreaInset(edge: .bottom) {
            tabBar
        }
    }

    private var tabBar: some View {
        HStack(spacing: 8) {
            ForEach(AppTab.allCases) { tab in
                Button {
                    selectedTab = tab
                } label: {
                    VStack(spacing: 4) {
                        Image(systemName: tab.systemImage)
                            .font(.system(size: 18, weight: .semibold))
                        Text(tab.title)
                            .font(.caption2.weight(.medium))
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .foregroundStyle(selectedTab == tab ? Color.jottyInk : Color.jottyInk.opacity(0.52))
                    .background {
                        if selectedTab == tab {
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(Color.jottySage.opacity(0.15))
                        }
                    }
                }
                .buttonStyle(.plain)
                .accessibilityLabel(tab.title)
            }
        }
        .padding(.horizontal, 16)
        .padding(.top, 8)
        .padding(.bottom, 6)
        .background(Color.jottyPaper.opacity(0.98))
    }
}

private enum AppTab: String, CaseIterable, Identifiable {
    case notes
    case ideas
    case archive

    var id: String { rawValue }

    var title: String {
        switch self {
        case .notes: "Notes"
        case .ideas: "Ideas"
        case .archive: "Archive"
        }
    }

    var systemImage: String {
        switch self {
        case .notes: "note.text"
        case .ideas: "sparkles"
        case .archive: "archivebox"
        }
    }
}

#Preview {
    AppShell(store: NoteStore())
}
