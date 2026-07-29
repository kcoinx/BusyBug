import UIKit

@MainActor
final class HapticsManager {
    static let shared = HapticsManager()

    private var rewardTask: Task<Void, Never>?

    private init() {}

    func importantTap() {
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.prepare()
        generator.impactOccurred(intensity: 0.45)
    }

    func playRewardSequence(discoveredNewBug: Bool) {
        rewardTask?.cancel()
        rewardTask = Task {
            let completion = UINotificationFeedbackGenerator()
            completion.prepare()
            completion.notificationOccurred(.success)
            await pause(milliseconds: 380)

            if discoveredNewBug {
                guard !Task.isCancelled else { return }
                let discovery = UIImpactFeedbackGenerator(style: .rigid)
                discovery.prepare()
                discovery.impactOccurred(intensity: 0.55)
                await pause(milliseconds: 420)
            }

            guard !Task.isCancelled else { return }
            let sticker = UIImpactFeedbackGenerator(style: .soft)
            sticker.prepare()
            sticker.impactOccurred(intensity: 0.7)
        }
    }

    private func pause(milliseconds: UInt64) async {
        try? await Task.sleep(for: .milliseconds(milliseconds))
    }
}
