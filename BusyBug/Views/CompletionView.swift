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
                VStack(spacing: BugLayout.cardSpacing) {
                    HStack {
                        Spacer()
                        Button {
                            model.showBugBook()
                        } label: {
                            Label("Bug Book", systemImage: "book.closed.fill")
                                .font(.system(.subheadline, design: .rounded, weight: .bold))
                                .foregroundStyle(BugColor.purple)
                                .padding(.horizontal, 12)
                                .frame(minHeight: 44)
                                .background(BugColor.surface, in: Capsule())
                                .overlay(Capsule().stroke(.white.opacity(0.8), lineWidth: 1))
                        }
                        .buttonStyle(BugPressButtonStyle())
                        .accessibilityHint("Opens your sticker collection")
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
                    SecondaryButton(title: "Home", icon: "house.fill") {
                        model.done()
                    }
                }
                .padding(BugLayout.screenPadding)
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
                .font(.system(.title3, design: .rounded, weight: .bold))
                .multilineTextAlignment(.center)
            Text(sticker.personality)
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(BugColor.purple)
            Text(sticker.fact)
                .font(.system(.subheadline, design: .rounded, weight: .medium))
                .foregroundStyle(BugColor.ink.opacity(0.68))
                .multilineTextAlignment(.center)
            if let title = model.currentMission?.title {
                Text("Mission complete: \(title)")
                    .font(.system(.subheadline, design: .rounded, weight: .semibold))
                    .foregroundStyle(BugColor.ink.opacity(0.62))
                    .multilineTextAlignment(.center)
            }
            Label("Saved to My Bug Book", systemImage: "checkmark.circle.fill")
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(BugColor.green)
            Text(stickerTotalText)
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(BugColor.ink.opacity(0.68))
        }
        .padding(18)
        .frame(maxWidth: .infinity)
        .bugCard(tint: BugColor.green)
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

#Preview("Completion – Larger Text") {
    CompletionView(model: AppViewModel.completionPreview())
        .environment(\.dynamicTypeSize, .accessibility1)
}
