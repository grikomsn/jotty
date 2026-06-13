import SwiftUI

@main
struct JottyApp: App {
    @State private var store = NoteStore()

    var body: some Scene {
        WindowGroup {
            AppShell(store: store)
        }
    }
}
