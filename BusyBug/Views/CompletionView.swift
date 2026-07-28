import SwiftUI

struct CompletionView: View {
    @ObservedObject var model: AppViewModel
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var appeared = false
    @State private var stickerRevealed = false
    @State private var stickerFlying = false

    var body: some View {
        ZStack {
            ConfettiView()
            ScrollView {
                VStack(spacing: 10) {
                    HStack {
                        Spacer()
                        Label("Bug Book", systemImage: "book.closed.fill")
                            .font(.subheadline.bold())
                            .foregroundStyle(BugColor.purple)
                            .padding(.horizontal, 12)
                            .frame(minHeight: 44)
                            .background(.white.opacity(0.9), in: Capsule())
                    }

                    LadybugView(state: .celebrating, size: 148)
                        .scaleEffect(appeared ? 1 : 0.55)

                    Text(celebrationMessage)
                        .font(.system(.largeTitle, design: .rounded, weight: .black))
                        .foregroundStyle(BugColor.orange)
                        .multilineTextAlignment(.center)

                    if let sticker = model.awardedSticker {
                        stickerReveal(sticker)
                    }

                    PrimaryButton(title: "Next Mission", icon: "arrow.right") {
                        model.nextMission()
                    }
                    SecondaryButton(title: "Choose a Place", icon: "mappin.and.ellipse") {
                        model.done()
                    }
                }
                .padding(24)
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity)
            }
        }
        .onAppear { startCelebration() }
    }

    private func stickerReveal(_ sticker: BugSticker) -> some View {
        VStack(spacing: 8) {
            ZStack {
                BugStickerView(sticker: sticker, isEarned: true, size: 96, showName: false)
                    .scaleEffect(stickerRevealed ? 1 : 0.2)
                    .opacity(stickerRevealed ? 1 : 0)
                BugStickerView(sticker: sticker, isEarned: true, size: 96, showName: false)
                    .scaleEffect(stickerFlying ? 0.2 : 1)
                    .offset(x: stickerFlying ? 118 : 0, y: stickerFlying ? -180 : 0)
                    .opacity(stickerFlying ? 0 : 0.9)
            }
            Text("You found \(sticker.name)!")
                .font(.title3.bold())
                .multilineTextAlignment(.center)
            if let title = model.currentMission?.title {
                Text("Mission complete: \(title)")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(BugColor.ink.opacity(0.62))
                    .multilineTextAlignment(.center)
            }
            Label("Saved to My Bug Book", systemImage: "checkmark.circle.fill")
                .font(.subheadline.bold())
                .foregroundStyle(BugColor.green)
            Text(stickerTotalText)
                .font(.headline)
                .foregroundStyle(BugColor.ink.opacity(0.68))
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .background(.white.opacity(0.94), in: RoundedRectangle(cornerRadius: 26))
        .padding(.vertical, 6)
        .accessibilityElement(children: .combine)
    }

    private var celebrationMessage: String {
        guard let category = model.currentMission?.category.lowercased() else {
            return "Amazing exploring!"
        }
        if category.contains("rainbow") { return "You found it!" }
        if category.contains("count") { return "Count-tastic!" }
        if category.contains("alphabet") { return "Letter legend!" }
        return "Amazing exploring!"
    }

    private var stickerTotalText: String {
        model.stickers == 1 ? "Your first bug—hooray!" : "\(model.stickers) stickers collected"
    }

    private func startCelebration() {
        withAnimation(reduceMotion ? nil : .bouncy(duration: 0.55)) {
            appeared = true
        }
        withAnimation((reduceMotion ? Animation.linear(duration: 0) : .bouncy(duration: 0.65)).delay(0.2)) {
            stickerRevealed = true
        }
        withAnimation((reduceMotion ? Animation.linear(duration: 0) : .easeInOut(duration: 0.55)).delay(1.0)) {
            stickerFlying = true
        }
    }
}

#Preview("Completion") {
    let model = AppViewModel.completionPreview()
    CompletionView(model: model)
}
