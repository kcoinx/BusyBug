import SwiftUI

struct LadybugView: View {
    var celebrating = false
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var bounce = false

    var body: some View {
        ZStack {
            Capsule()
                .fill(BugColor.ink)
                .frame(width: 18, height: 88)
            Circle()
                .fill(BugColor.red.gradient)
                .frame(width: 126, height: 126)
                .overlay {
                    HStack(spacing: 34) {
                        spots
                        spots
                    }
                }
                .overlay {
                    Capsule().fill(BugColor.ink).frame(width: 8, height: 112)
                }
            Circle()
                .fill(BugColor.ink)
                .frame(width: 65, height: 65)
                .offset(y: -71)
                .overlay {
                    HStack(spacing: 18) {
                        Circle().fill(.white).frame(width: 14, height: 14)
                        Circle().fill(.white).frame(width: 14, height: 14)
                    }
                    .offset(y: -72)
                }
            antenna
        }
        .frame(width: 170, height: 205)
        .rotationEffect(.degrees(celebrating && bounce ? 7 : -4))
        .offset(y: bounce ? -8 : 4)
        .animation(
            reduceMotion ? nil : .easeInOut(duration: 0.7).repeatForever(autoreverses: true),
            value: bounce
        )
        .onAppear { bounce = !reduceMotion }
        .accessibilityHidden(true)
    }

    private var spots: some View {
        VStack(spacing: 24) {
            Circle().fill(BugColor.ink).frame(width: 21, height: 21)
            Circle().fill(BugColor.ink).frame(width: 17, height: 17)
        }
    }

    private var antenna: some View {
        HStack(spacing: 36) {
            Capsule().fill(BugColor.ink).frame(width: 5, height: 38).rotationEffect(.degrees(-28))
            Capsule().fill(BugColor.ink).frame(width: 5, height: 38).rotationEffect(.degrees(28))
        }
        .offset(y: -112)
    }
}
