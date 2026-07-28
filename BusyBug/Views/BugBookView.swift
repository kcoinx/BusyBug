import SwiftUI

struct BugBookView: View {
    @ObservedObject var model: AppViewModel
    private let columns = [
        GridItem(.adaptive(minimum: 120), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BugLayout.sectionSpacing) {
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

                GeometryReader { proxy in
                    ZStack(alignment: .leading) {
                        Capsule().fill(BugColor.green.opacity(0.14))
                        Capsule()
                            .fill(BugColor.green.gradient)
                            .frame(width: proxy.size.width * collectionProgress)
                    }
                }
                    .frame(height: 12)
                    .accessibilityLabel("\(model.earnedStickerIDs.count) of \(BugSticker.collection.count) unique bugs found")
                    .accessibilityValue("\(Int(collectionProgress * 100)) percent")

                LazyVGrid(columns: columns, spacing: 20) {
                    ForEach(BugSticker.collection) { sticker in
                        BugStickerView(
                            sticker: sticker,
                            isEarned: model.earnedStickerIDs.contains(sticker.id)
                        )
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(BugColor.surface, in: RoundedRectangle(cornerRadius: 22))
                        .overlay {
                            RoundedRectangle(cornerRadius: 22)
                                .stroke(.white.opacity(0.7), lineWidth: 1)
                        }
                    }
                }
            }
            .padding(BugLayout.screenPadding)
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

    private var collectionProgress: CGFloat {
        CGFloat(model.earnedStickerIDs.count) / CGFloat(BugSticker.collection.count)
    }
}

#Preview("Bug Book") {
    BugBookView(model: AppViewModel.preview(stickerCount: 5))
}

#Preview("Bug Book – Larger Text") {
    BugBookView(model: AppViewModel.preview(stickerCount: 5))
        .environment(\.dynamicTypeSize, .accessibility1)
}
