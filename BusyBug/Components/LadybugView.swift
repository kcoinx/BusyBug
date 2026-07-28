import SwiftUI

enum MascotState: Equatable {
    case welcome
    case thinking
    case celebrating
    case encouraging
}

struct LadybugView: View {
    var state: MascotState = .welcome
    var size: CGFloat = 170

    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var animated = false

    private var scale: CGFloat { size / 170 }

    var body: some View {
        ZStack {
            backpack
            legs
            arms
            wings
            face
            explorerHat
            if state == .celebrating { celebrationStars }
            if state == .thinking { thoughtBubble }
        }
        .frame(width: 170, height: 205)
        .scaleEffect(scale)
        .frame(width: size, height: size * 205 / 170)
        .rotationEffect(.degrees(rotation))
        .offset(y: animated && !reduceMotion ? -6 : 2)
        .animation(
            reduceMotion ? nil : .easeInOut(duration: 0.72).repeatForever(autoreverses: true),
            value: animated
        )
        .onAppear { animated = true }
        .accessibilityHidden(true)
    }

    private var backpack: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(BugColor.purple.gradient)
                .frame(width: 58, height: 85)
            RoundedRectangle(cornerRadius: 8)
                .fill(BugColor.yellow)
                .frame(width: 35, height: 21)
                .offset(y: 18)
            Capsule()
                .stroke(BugColor.ink.opacity(0.5), lineWidth: 5)
                .frame(width: 78, height: 92)
        }
        .offset(x: 53, y: 24)
    }

    private var wings: some View {
        ZStack {
            Circle()
                .fill(BugColor.red.gradient)
                .frame(width: 126, height: 126)
                .overlay {
                    HStack(spacing: 34) {
                        spots
                        spots
                    }
                }
            Capsule()
                .fill(BugColor.ink)
                .frame(width: 8, height: 112)
        }
        .offset(y: 18)
    }

    private var face: some View {
        ZStack {
            Circle()
                .fill(BugColor.ink.gradient)
                .frame(width: 76, height: 76)
            HStack(spacing: 10) {
                eye
                eye
            }
            .offset(y: -4)
            mouth
                .offset(y: 20)
        }
        .offset(y: -55)
    }

    private var eye: some View {
        ZStack {
            Circle().fill(.white).frame(width: 25, height: 29)
            Circle()
                .fill(BugColor.ink)
                .frame(width: 10, height: 12)
                .offset(x: state == .thinking ? 3 : 0, y: 2)
            Circle().fill(.white).frame(width: 4, height: 4).offset(x: -2, y: -2)
        }
    }

    @ViewBuilder
    private var mouth: some View {
        if state == .thinking {
            Circle()
                .fill(BugColor.orange)
                .frame(width: 10, height: 12)
                .offset(x: 6)
        } else {
            SmileShape()
                .stroke(.white, style: StrokeStyle(lineWidth: 4, lineCap: .round))
                .frame(width: 23, height: state == .celebrating ? 15 : 11)
        }
    }

    private var explorerHat: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 11)
                .fill(BugColor.yellow.gradient)
                .frame(width: 60, height: 35)
                .overlay(alignment: .bottom) {
                    Capsule().fill(BugColor.orange).frame(height: 7)
                }
            Capsule()
                .fill(BugColor.yellow)
                .frame(width: 86, height: 14)
                .offset(y: 17)
            Image(systemName: "sparkles")
                .font(.caption2.bold())
                .foregroundStyle(BugColor.orange)
                .offset(y: -3)
        }
        .rotationEffect(.degrees(-5))
        .offset(y: -105)
    }

    private var arms: some View {
        HStack(spacing: 112) {
            limb
                .rotationEffect(.degrees(leftArmRotation))
            limb
                .rotationEffect(.degrees(rightArmRotation))
        }
        .offset(y: state == .celebrating ? -6 : 23)
    }

    private var legs: some View {
        HStack(spacing: 58) {
            limb.rotationEffect(.degrees(18))
            limb.rotationEffect(.degrees(-18))
        }
        .offset(y: 83)
    }

    private var limb: some View {
        Capsule()
            .fill(BugColor.ink)
            .frame(width: 11, height: 52)
            .overlay(alignment: .bottom) {
                Capsule()
                    .fill(BugColor.ink)
                    .frame(width: 26, height: 13)
                    .offset(y: 4)
            }
    }

    private var spots: some View {
        VStack(spacing: 24) {
            Circle().fill(BugColor.ink).frame(width: 21, height: 21)
            Circle().fill(BugColor.ink).frame(width: 17, height: 17)
        }
    }

    private var celebrationStars: some View {
        HStack(spacing: 108) {
            Image(systemName: "sparkle")
            Image(systemName: "star.fill")
        }
        .font(.title2.bold())
        .foregroundStyle(BugColor.yellow)
        .offset(y: -56)
        .scaleEffect(animated && !reduceMotion ? 1.15 : 0.8)
    }

    private var thoughtBubble: some View {
        Image(systemName: "questionmark")
            .font(.headline.bold())
            .foregroundStyle(BugColor.purple)
            .frame(width: 36, height: 36)
            .background(.white, in: Circle())
            .shadow(color: BugColor.purple.opacity(0.2), radius: 5, y: 3)
            .offset(x: 66, y: -70)
    }

    private var rotation: Double {
        guard animated, !reduceMotion else { return 0 }
        switch state {
        case .celebrating: 5
        case .thinking: -3
        case .encouraging: 2
        case .welcome: -1
        }
    }

    private var leftArmRotation: Double {
        state == .celebrating ? 125 : state == .encouraging ? 70 : 105
    }

    private var rightArmRotation: Double {
        state == .celebrating ? -125 : state == .thinking ? -55 : -105
    }
}

private struct SmileShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.minY))
        path.addQuadCurve(
            to: CGPoint(x: rect.maxX, y: rect.minY),
            control: CGPoint(x: rect.midX, y: rect.maxY)
        )
        return path
    }
}

#Preview("Mascot States") {
    HStack {
        LadybugView(state: .welcome, size: 90)
        LadybugView(state: .thinking, size: 90)
        LadybugView(state: .celebrating, size: 90)
        LadybugView(state: .encouraging, size: 90)
    }
    .padding()
    .background(BugColor.cream)
}
