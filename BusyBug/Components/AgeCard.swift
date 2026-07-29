import SwiftUI

struct AgeCard: View {
    let ageRange: String
    let title: String
    let subtitle: String
    let color: Color
    let usesDarkText: Bool
    let action: () -> Void

    private let cardHeight: CGFloat = 104
    private let ageCircleSize: CGFloat = 64
    private let horizontalPadding: CGFloat = 16
    private let contentSpacing: CGFloat = 14

    var body: some View {
        Button(action: action) {
            HStack(spacing: contentSpacing) {
                Text(ageRange)
                    .font(.system(size: 28, weight: .black, design: .rounded))
                    .frame(width: ageCircleSize, height: ageCircleSize)
                    .background(.white.opacity(0.27), in: Circle())

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(.system(.title3, design: .rounded, weight: .black))
                        .lineLimit(1)
                    Text(subtitle)
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(secondaryTextColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.88)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "chevron.right")
                    .font(.title2.bold())
                    .frame(width: 24, alignment: .trailing)
            }
            .padding(.horizontal, horizontalPadding)
            .foregroundStyle(primaryTextColor)
            .frame(maxWidth: .infinity)
            .frame(height: cardHeight)
            .background(color.gradient, in: RoundedRectangle(cornerRadius: BugLayout.cardRadius))
            .overlay {
                RoundedRectangle(cornerRadius: BugLayout.cardRadius)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            }
            .shadow(color: color.opacity(0.2), radius: 12, y: 6)
        }
        .buttonStyle(BugPressButtonStyle())
        .accessibilityElement(children: .combine)
        .accessibilityAddTraits(.isButton)
    }

    private var primaryTextColor: Color {
        usesDarkText ? BugColor.ink : .white
    }

    private var secondaryTextColor: Color {
        usesDarkText ? BugColor.ink.opacity(0.68) : .white.opacity(0.85)
    }
}

#Preview("Age Card") {
    AgeCard(
        ageRange: "5–6",
        title: "Ages 5–6",
        subtitle: "Read, remember & discover",
        color: BugColor.purple,
        usesDarkText: false,
        action: {}
    )
    .padding()
    .background(BugColor.cream)
}
