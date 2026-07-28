import SwiftUI

struct RootView: View {
    @StateObject private var model = AppViewModel()

    var body: some View {
        ZStack {
            BugColor.cream.ignoresSafeArea()
            Group {
                switch model.route {
                case .welcome: WelcomeView(model: model)
                case .location: LocationView(model: model)
                case .age: AgeSelectionView(model: model)
                case .mission: MissionView(model: model)
                case .completion: CompletionView(model: model)
                }
            }
            .transition(.asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
        }
        .tint(BugColor.orange)
        .foregroundStyle(BugColor.ink)
        .animation(.snappy(duration: 0.35), value: model.route)
    }
}

#Preview {
    RootView()
}
