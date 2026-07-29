import SwiftUI

struct BugStickerView: View {
    let sticker: BugSticker
    let isEarned: Bool
    var size: CGFloat = 92
    var showName = true

    private let colors = [
        BugColor.red, BugColor.yellow, BugColor.blue,
        BugColor.green, BugColor.purple
    ]

    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(isEarned ? colors[sticker.colorIndex].gradient : Color.gray.opacity(0.18).gradient)
                Circle()
                    .strokeBorder(.white.opacity(isEarned ? 0.75 : 0.3), lineWidth: 4)
                    .padding(5)
                Text(sticker.emoji)
                    .font(.system(size: size * 0.45))
                    .grayscale(isEarned ? 0 : 1)
                    .opacity(isEarned ? 1 : 0.28)
                if !isEarned {
                    Image(systemName: "lock.fill")
                        .font(.system(size: size * 0.22, weight: .bold))
                        .foregroundStyle(BugColor.ink.opacity(0.55))
                        .padding(8)
                        .background(.white.opacity(0.85), in: Circle())
                }
            }
            .frame(width: size, height: size)
            .shadow(color: isEarned ? colors[sticker.colorIndex].opacity(0.22) : .clear, radius: 7, y: 4)

            if showName {
                VStack(spacing: 2) {
                    Text(isEarned ? sticker.name : "Mystery Bug")
                        .font(.system(.caption, design: .rounded, weight: .bold))
                    if isEarned {
                        Text(sticker.personality)
                            .font(.caption2)
                            .foregroundStyle(BugColor.ink.opacity(0.6))
                    }
                }
                .multilineTextAlignment(.center)
                .foregroundStyle(isEarned ? BugColor.ink : BugColor.ink.opacity(0.45))
                .lineLimit(2)
                .minimumScaleFactor(0.8)
                .fixedSize(horizontal: false, vertical: true)
            }
        }
        .accessibilityElement(children: .ignore)
        .accessibilityLabel(
            isEarned
                ? "\(sticker.name), \(sticker.personality). \(sticker.fact). \(sticker.habitatGroup)."
                : "Locked mystery bug"
        )
    }
}
