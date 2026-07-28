import SwiftUI

struct ConfettiView: View {
    private let colors = [BugColor.orange, BugColor.blue, BugColor.green, BugColor.yellow, BugColor.purple, BugColor.red]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var falling = false

    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<42, id: \.self) { index in
                RoundedRectangle(cornerRadius: 2)
                    .fill(colors[index % colors.count])
                    .frame(width: index.isMultiple(of: 3) ? 12 : 8, height: 16)
                    .rotationEffect(.degrees(falling ? Double(index * 91) : 0))
                    .position(
                        x: CGFloat((index * 47) % 100) / 100 * proxy.size.width,
                        y: falling ? proxy.size.height + 30 : -30
                    )
                    .animation(reduceMotion ? nil :
                        .linear(duration: 2.1 + Double(index % 5) * 0.25)
                            .delay(Double(index % 12) * 0.07),
                        value: falling)
            }
        }
        .allowsHitTesting(false)
        .onAppear { falling = true }
        .accessibilityHidden(true)
    }
}
