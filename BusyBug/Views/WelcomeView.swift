import SwiftUI

struct WelcomeView: View {
    @ObservedObject var model: AppViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                Spacer(minLength: 24)
                LadybugView()
                VStack(spacing: 8) {
                    Text("BusyBug")
                        .font(.system(.largeTitle, design: .rounded, weight: .black))
                        .foregroundStyle(BugColor.orange)
                    Text("Little adventures,\nwherever you are.")
                        .font(.title2.weight(.semibold))
                        .multilineTextAlignment(.center)
                        .foregroundStyle(BugColor.ink.opacity(0.78))
                }
                HStack(spacing: 0) {
                    welcomeStep(icon: "mappin.and.ellipse", label: "Pick a place", color: BugColor.blue)
                    dottedArrow
                    welcomeStep(icon: "sparkles", label: "Play", color: BugColor.purple)
                    dottedArrow
                    welcomeStep(icon: "ladybug.fill", label: "Earn bugs", color: BugColor.red)
                }
                .padding(.vertical, 18)
                .padding(.horizontal, 12)
                .background(.white.opacity(0.82), in: RoundedRectangle(cornerRadius: 24))
                .accessibilityElement(children: .combine)
                .accessibilityLabel("Pick a place, play a mission, and earn bug stickers")
                PrimaryButton(title: "Start Exploring", icon: "arrow.right") {
                    model.begin()
                }
                Text("No setup, screens, or supplies needed.")
                    .font(.footnote.weight(.semibold))
                    .foregroundStyle(BugColor.ink.opacity(0.55))
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: 560)
            .frame(minHeight: 720)
            .frame(maxWidth: .infinity)
        }
    }

    private func welcomeStep(icon: String, label: String, color: Color) -> some View {
        VStack(spacing: 7) {
            Image(systemName: icon)
                .font(.title2.bold())
                .foregroundStyle(color)
                .frame(width: 46, height: 46)
                .background(color.opacity(0.12), in: Circle())
            Text(label)
                .font(.caption.bold())
                .lineLimit(1)
                .minimumScaleFactor(0.75)
        }
        .frame(maxWidth: .infinity)
    }

    private var dottedArrow: some View {
        Image(systemName: "chevron.right")
            .font(.caption.bold())
            .foregroundStyle(BugColor.ink.opacity(0.25))
    }
}

#Preview { WelcomeView(model: AppViewModel()) }
