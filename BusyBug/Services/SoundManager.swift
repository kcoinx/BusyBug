import AVFoundation
import Combine
import Foundation

@MainActor
final class SoundManager: ObservableObject {
    enum Sound: String {
        case buttonTap = "button_tap"
        case missionComplete = "mission_complete"
        case bugDiscovered = "bug_discovered"
        case stickerEarned = "sticker_earned"
        case celebration
    }

    static let shared = SoundManager()

    @Published private(set) var soundsEnabled: Bool

    private let preferenceKey = "soundsEnabled"
    private var player: AVAudioPlayer?
    private var rewardTask: Task<Void, Never>?
    private var lastPlayTime = Date.distantPast
    private var audioSessionConfigured = false
    private(set) var isRewardSequenceRunning = false

    private init() {
        if UserDefaults.standard.object(forKey: preferenceKey) == nil {
            soundsEnabled = true
        } else {
            soundsEnabled = UserDefaults.standard.bool(forKey: preferenceKey)
        }
    }

    func setSoundsEnabled(_ enabled: Bool) {
        soundsEnabled = enabled
        UserDefaults.standard.set(enabled, forKey: preferenceKey)
        if !enabled { stopAll() }
    }

    func playButtonTap() {
        guard !isRewardSequenceRunning else { return }
        play(.buttonTap, minimumInterval: 0.16)
    }

    func playRewardSequence(discoveredNewBug: Bool) {
        guard soundsEnabled else { return }
        rewardTask?.cancel()
        player?.stop()
        lastPlayTime = .distantPast
        isRewardSequenceRunning = true

        rewardTask = Task { [weak self] in
            guard let self else { return }
            play(.missionComplete)
            await pause(milliseconds: 380)

            if discoveredNewBug {
                guard !Task.isCancelled else { return }
                play(.bugDiscovered)
                await pause(milliseconds: 420)
            }

            guard !Task.isCancelled else { return }
            play(.stickerEarned)
            await pause(milliseconds: 360)

            guard !Task.isCancelled else { return }
            play(.celebration)
            await pause(milliseconds: 420)
            isRewardSequenceRunning = false
        }
    }

    func stopAll() {
        rewardTask?.cancel()
        rewardTask = nil
        player?.stop()
        player = nil
        isRewardSequenceRunning = false
    }

    private func play(_ sound: Sound, minimumInterval: TimeInterval = 0.08) {
        guard soundsEnabled else { return }
        let now = Date()
        guard now.timeIntervalSince(lastPlayTime) >= minimumInterval else { return }
        guard let url = Bundle.main.url(forResource: sound.rawValue, withExtension: "wav") else {
            return
        }

        configureAudioSessionIfNeeded()

        do {
            player?.stop()
            player = try AVAudioPlayer(contentsOf: url)
            player?.volume = sound == .buttonTap ? 0.12 : 0.22
            player?.prepareToPlay()
            player?.play()
            lastPlayTime = now
        } catch {
            player = nil
        }
    }

    private func configureAudioSessionIfNeeded() {
        guard !audioSessionConfigured else { return }
        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.ambient, mode: .default, options: [.mixWithOthers])
            try session.setActive(true)
            audioSessionConfigured = true
        } catch {
            audioSessionConfigured = false
        }
    }

    private func pause(milliseconds: UInt64) async {
        try? await Task.sleep(for: .milliseconds(milliseconds))
    }
}
