import SwiftUI

struct CompletionView: View {
    @ObservedObject var model: AppViewModel
    @State private var appeared = false

    var body: some View {
        ZStack {
            ConfettiView()
            ScrollView {
                VStack(spacing: 12) {
                    LadybugView(celebrating: true)
                        .scaleEffect(appeared ? 1 : 0.5)
                    Text("Amazing job!")
                        .font(.system(.largeTitle, design: .rounded, weight: .black))
                        .foregroundStyle(BugColor.orange)
                    VStack(spacing: 10) {
                        Image(systemName: "ladybug.fill")
                            .font(.system(size: 58))
                            .foregroundStyle(BugColor.red)
                            .symbolEffect(.bounce, options: .repeating.speed(0.5))
                        Text("+1 Bug Sticker")
                            .font(.title2.bold())
                        Text("You have \(model.stickers)!")
                            .font(.headline)
                            .foregroundStyle(BugColor.ink.opacity(0.65))
                    }
                    .padding(22)
                    .frame(maxWidth: .infinity)
                    .background(.white.opacity(0.92), in: RoundedRectangle(cornerRadius: 26))
                    .padding(.vertical, 10)
                    PrimaryButton(title: "Next Mission", icon: "arrow.right") {
                        model.nextMission()
                    }
                    SecondaryButton(title: "Done", icon: "house.fill") {
                        model.done()
                    }
                }
                .padding(24)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear {
            withAnimation(.bouncy(duration: 0.7)) { appeared = true }
        }
    }
}

#Preview { CompletionView(model: AppViewModel()) }
