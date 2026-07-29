import SwiftUI

struct RootView: View {
    @StateObject private var model = AppViewModel()
    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        ZStack {
            PlayfulBackground()
            Group {
                switch model.route {
                case .welcome: WelcomeView(model: model)
                case .bugBook: BugBookView(model: model)
                case .location: LocationView(model: model)
                case .roadTripSafety: RoadTripSafetyView(model: model)
                case .age: AgeSelectionView(model: model)
                case .mission: MissionView(model: model)
                case .completion: CompletionView(model: model)
                }
            }
            .transition(reduceMotion ? .opacity : .asymmetric(
                insertion: .move(edge: .trailing).combined(with: .opacity),
                removal: .move(edge: .leading).combined(with: .opacity)
            ))
        }
        .tint(BugColor.orange)
        .symbolRenderingMode(.hierarchical)
        .foregroundStyle(BugColor.ink)
        .animation(reduceMotion ? nil : .snappy(duration: 0.35), value: model.route)
        .sensoryFeedback(.success, trigger: model.stickers)
    }
}

#Preview {
    RootView()
}
