import SwiftUI

struct IdeasView: View {
    private let prompts = [
        "What would make today feel lighter?",
        "What small thing has been waiting for attention?",
        "What would I try if this only had to be a draft?",
        "Where do I already have momentum?"
    ]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    Text("Use a prompt when the page feels too blank.")
                        .font(.system(.title3, design: .serif).weight(.semibold))
                        .foregroundStyle(Color.jottyInk)
                        .padding(.bottom, 6)

                    ForEach(prompts, id: \.self) { prompt in
                        Text(prompt)
                            .font(.body.weight(.medium))
                            .foregroundStyle(Color.jottyInk)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(.white.opacity(0.76), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                    }
                }
                .padding(20)
            }
            .background(Color.jottyPaper.ignoresSafeArea())
            .navigationTitle("Ideas")
            .toolbarBackground(Color.jottyPaper, for: .navigationBar)
        }
    }
}

#Preview {
    IdeasView()
}
