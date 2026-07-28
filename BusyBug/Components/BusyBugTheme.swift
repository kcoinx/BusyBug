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
