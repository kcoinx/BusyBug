import SwiftUI

enum BugColor {
    static let cream = Color(red: 1.0, green: 0.97, blue: 0.89)
    static let orange = Color(red: 1.0, green: 0.42, blue: 0.16)
    static let blue = Color(red: 0.20, green: 0.65, blue: 0.95)
    static let green = Color(red: 0.31, green: 0.75, blue: 0.38)
    static let yellow = Color(red: 1.0, green: 0.80, blue: 0.18)
    static let red = Color(red: 0.94, green: 0.27, blue: 0.25)
    static let purple = Color(red: 0.55, green: 0.38, blue: 0.86)
    static let ink = Color(red: 0.16, green: 0.14, blue: 0.18)
    static let surface = Color.white.opacity(0.88)
}

enum BugLayout {
    static let screenPadding: CGFloat = 24
    static let sectionSpacing: CGFloat = 24
    static let cardSpacing: CGFloat = 16
    static let cardRadius: CGFloat = 28
    static let controlRadius: CGFloat = 20
    static let minimumTapHeight: CGFloat = 52
}

struct BugPressButtonStyle: ButtonStyle {
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed && !reduceMotion ? 0.975 : 1)
            .opacity(configuration.isPressed ? 0.88 : 1)
            .animation(reduceMotion ? nil : .snappy(duration: 0.16), value: configuration.isPressed)
    }
}

struct BugCardSurface: ViewModifier {
    var tint: Color = BugColor.blue

    func body(content: Content) -> some View {
        content
            .background(BugColor.surface, in: RoundedRectangle(cornerRadius: BugLayout.cardRadius))
            .overlay {
                RoundedRectangle(cornerRadius: BugLayout.cardRadius)
                    .stroke(.white.opacity(0.72), lineWidth: 1)
            }
            .shadow(color: tint.opacity(0.13), radius: 12, y: 6)
    }
}

extension View {
    func bugCard(tint: Color = BugColor.blue) -> some View {
        modifier(BugCardSurface(tint: tint))
    }
}

struct PlayfulBackground: View {
    var body: some View {
        GeometryReader { proxy in
            ZStack {
                BugColor.cream
                Circle()
                    .fill(BugColor.yellow.opacity(0.18))
                    .frame(width: 240, height: 240)
                    .position(x: proxy.size.width - 30, y: 60)
                Circle()
                    .fill(BugColor.blue.opacity(0.10))
                    .frame(width: 180, height: 180)
                    .position(x: 10, y: proxy.size.height * 0.62)
                Circle()
                    .fill(BugColor.orange.opacity(0.08))
                    .frame(width: 120, height: 120)
                    .position(x: proxy.size.width * 0.78, y: proxy.size.height * 0.88)
            }
        }
        .ignoresSafeArea()
        .accessibilityHidden(true)
    }
}

struct ScreenTitle: View {
    let eyebrow: String
    let title: String
    var message: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(eyebrow.uppercased())
                .font(.caption.bold())
                .tracking(1.5)
                .foregroundStyle(BugColor.orange)
            Text(title)
                .font(.system(.largeTitle, design: .rounded, weight: .black))
                .fixedSize(horizontal: false, vertical: true)
            if let message {
                Text(message)
                    .font(.system(.title3, design: .rounded, weight: .medium))
                    .foregroundStyle(BugColor.ink.opacity(0.68))
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

struct PrimaryButton: View {
    let title: String
    var icon: String?
    var playsTapSound = true
    var playsHaptic = true
    let action: () -> Void

    var body: some View {
        Button {
            if playsTapSound { SoundManager.shared.playButtonTap() }
            if playsHaptic { HapticsManager.shared.importantTap() }
            action()
        } label: {
            HStack(spacing: 10) {
                Text(title)
                if let icon { Image(systemName: icon) }
            }
            .font(.system(.title3, design: .rounded, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(minHeight: 58)
            .foregroundStyle(.white)
            .background(BugColor.orange.gradient, in: RoundedRectangle(cornerRadius: BugLayout.controlRadius))
            .shadow(color: BugColor.orange.opacity(0.24), radius: 10, y: 5)
        }
        .buttonStyle(BugPressButtonStyle())
        .accessibilityAddTraits(.isButton)
    }
}

struct SecondaryButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button {
            SoundManager.shared.playButtonTap()
            action()
        } label: {
            HStack {
                if let icon { Image(systemName: icon) }
                Text(title)
            }
            .font(.system(.headline, design: .rounded, weight: .bold))
            .frame(maxWidth: .infinity)
            .frame(minHeight: BugLayout.minimumTapHeight)
            .foregroundStyle(BugColor.orange)
            .background(BugColor.surface, in: RoundedRectangle(cornerRadius: BugLayout.controlRadius))
            .overlay(RoundedRectangle(cornerRadius: BugLayout.controlRadius).stroke(BugColor.orange.opacity(0.85), lineWidth: 2))
        }
        .buttonStyle(BugPressButtonStyle())
    }
}

struct BackCircleButton: View {
    let action: () -> Void
    var body: some View {
        Button {
            SoundManager.shared.playButtonTap()
            HapticsManager.shared.importantTap()
            action()
        } label: {
            Image(systemName: "chevron.left")
                .font(.title3.bold())
                .foregroundStyle(BugColor.ink)
                .frame(width: 48, height: 48)
                .background(BugColor.surface, in: Circle())
                .overlay(Circle().stroke(.white.opacity(0.8), lineWidth: 1))
                .shadow(color: BugColor.ink.opacity(0.08), radius: 7, y: 3)
        }
        .buttonStyle(BugPressButtonStyle())
        .accessibilityLabel("Back")
    }
}
