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
            GeometryReader { proxy in
                let compact = proxy.size.height < 760

                ScrollView {
                    VStack(spacing: compact ? 8 : 14) {
                        bugBookButton

                        LadybugView(state: .celebrating, size: compact ? 96 : 132)
                            .scaleEffect(appeared ? 1 : 0.55)

                        Text(celebrationMessage)
                            .font(.system(compact ? .title : .largeTitle, design: .rounded, weight: .black))
                            .foregroundStyle(BugColor.orange)
                            .multilineTextAlignment(.center)

                        if let sticker = model.awardedSticker {
                            stickerReveal(sticker, compact: compact)
                        }

                        PrimaryButton(title: "Next Mission", icon: "arrow.right") {
                            model.nextMission()
                        }
                        SecondaryButton(title: "Home", icon: "house.fill") {
                            model.done()
                        }
                    }
                    .padding(.horizontal, compact ? 20 : BugLayout.screenPadding)
                    .padding(.vertical, compact ? 8 : 16)
                    .frame(maxWidth: 560)
                    .frame(maxWidth: .infinity, minHeight: proxy.size.height, alignment: .top)
                }
                .scrollBounceBehavior(.basedOnSize)
            }
        }
        .onAppear { startCelebration() }
    }

    private var bugBookButton: some View {
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
    }

    private func stickerReveal(_ sticker: BugSticker, compact: Bool) -> some View {
        VStack(spacing: compact ? 4 : 7) {
            ZStack {
                BugStickerView(sticker: sticker, isEarned: true, size: compact ? 64 : 84, showName: false)
                    .scaleEffect(stickerRevealed ? 1 : 0.2)
                    .opacity(stickerRevealed ? 1 : 0)
                BugStickerView(sticker: sticker, isEarned: true, size: compact ? 64 : 84, showName: false)
                    .scaleEffect(stickerFlying ? 0.2 : 1)
                    .offset(
                        x: stickerFlying ? (compact ? 90 : 108) : 0,
                        y: stickerFlying ? (compact ? -122 : -158) : 0
                    )
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
            if !compact, let title = model.currentMission?.title {
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
        .padding(compact ? 10 : 14)
        .frame(maxWidth: .infinity)
        .bugCard(tint: BugColor.green)
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

#Preview("Completion – Compact Height") {
    CompletionView(model: AppViewModel.completionPreview())
        .frame(width: 375, height: 667)
}

#Preview("Completion – Pro Height") {
    CompletionView(model: AppViewModel.completionPreview())
        .frame(width: 402, height: 874)
}
