import SwiftUI

struct ConfettiView: View {
    private let colors = [BugColor.orange, BugColor.blue, BugColor.green, BugColor.yellow, BugColor.purple, BugColor.red]
    @Environment(\.accessibilityReduceMotion) private var reduceMotion
    @State private var falling = false

    var body: some View {
        GeometryReader { proxy in
            ForEach(0..<42, id: \.self) { index in
                Group {
                    if index.isMultiple(of: 4) {
                        Circle().fill(colors[index % colors.count].gradient)
                    } else {
                        RoundedRectangle(cornerRadius: 3)
                            .fill(colors[index % colors.count].gradient)
                    }
                }
                    .frame(
                        width: index.isMultiple(of: 3) ? 12 : 8,
                        height: index.isMultiple(of: 4) ? 12 : 16
                    )
                    .rotationEffect(.degrees(falling ? Double(index * 91) : 0))
                    .scaleEffect(falling ? 0.7 : 1)
                    .position(
                        x: CGFloat((index * 47) % 100) / 100 * proxy.size.width,
                        y: falling ? proxy.size.height + 30 : -30
                    )
                    .animation(reduceMotion ? nil :
                        .easeIn(duration: 1.4 + Double(index % 5) * 0.12)
                            .delay(Double(index % 10) * 0.04),
                        value: falling)
            }
        }
        .allowsHitTesting(false)
        .onAppear { falling = true }
        .accessibilityHidden(true)
    }
}
