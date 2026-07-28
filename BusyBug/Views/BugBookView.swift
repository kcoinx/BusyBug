import SwiftUI

struct BugBookView: View {
    @ObservedObject var model: AppViewModel
    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    BackCircleButton { model.goBack() }
                    Spacer()
                    StickerPill(count: model.stickers)
                }

                ViewThatFits(in: .horizontal) {
                    HStack(alignment: .bottom, spacing: 12) {
                        title
                        Spacer(minLength: 0)
                        LadybugView(state: .encouraging, size: 82)
                    }
                    title
                }

                ProgressView(value: Double(model.earnedStickerIDs.count), total: Double(BugSticker.collection.count))
                    .tint(BugColor.green)
                    .scaleEffect(x: 1, y: 2, anchor: .center)
                    .accessibilityLabel("\(model.earnedStickerIDs.count) of \(BugSticker.collection.count) unique bugs found")

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(BugSticker.collection) { sticker in
                        BugStickerView(
                            sticker: sticker,
                            isEarned: model.earnedStickerIDs.contains(sticker.id)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(.white.opacity(0.78), in: RoundedRectangle(cornerRadius: 22))
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: 650)
            .frame(maxWidth: .infinity)
        }
    }

    private var title: some View {
        ScreenTitle(
            eyebrow: "Your Collection",
            title: "My Bug Book",
            message: collectionMessage
        )
    }

    private var collectionMessage: String {
        let remaining = BugSticker.collection.count - model.earnedStickerIDs.count
        if remaining == 0 { return "You found every bug. Amazing exploring!" }
        return "Complete missions to discover \(remaining) more."
    }
}

#Preview("Bug Book") {
    BugBookView(model: AppViewModel.preview(stickerCount: 5))
}
