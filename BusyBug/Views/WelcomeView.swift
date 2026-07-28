import SwiftUI

struct WelcomeView: View {
    @ObservedObject var model: AppViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: 22) {
                Spacer(minLength: 35)
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
                Spacer(minLength: 30)
                PrimaryButton(title: "Start Exploring", icon: "arrow.right") {
                    model.begin()
                }
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: 560)
            .frame(minHeight: 720)
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview { WelcomeView(model: AppViewModel()) }
