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
            if let message {
                Text(message)
                    .font(.title3.weight(.medium))
                    .foregroundStyle(BugColor.ink.opacity(0.68))
            }
        }
    }
}

struct PrimaryButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 10) {
                Text(title)
                if let icon { Image(systemName: icon) }
            }
            .font(.title3.bold())
            .frame(maxWidth: .infinity)
            .frame(minHeight: 58)
            .foregroundStyle(.white)
            .background(BugColor.orange.gradient, in: RoundedRectangle(cornerRadius: 22))
            .shadow(color: BugColor.orange.opacity(0.3), radius: 8, y: 5)
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(.isButton)
    }
}

struct SecondaryButton: View {
    let title: String
    var icon: String?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack {
                if let icon { Image(systemName: icon) }
                Text(title)
            }
            .font(.headline)
            .frame(maxWidth: .infinity)
            .frame(minHeight: 52)
            .foregroundStyle(BugColor.orange)
            .background(.white.opacity(0.8), in: RoundedRectangle(cornerRadius: 20))
            .overlay(RoundedRectangle(cornerRadius: 20).stroke(BugColor.orange, lineWidth: 2))
        }
        .buttonStyle(.plain)
    }
}

struct BackCircleButton: View {
    let action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: "chevron.left")
                .font(.title3.bold())
                .foregroundStyle(BugColor.ink)
                .frame(width: 48, height: 48)
                .background(.white.opacity(0.9), in: Circle())
        }
        .accessibilityLabel("Back")
    }
}
