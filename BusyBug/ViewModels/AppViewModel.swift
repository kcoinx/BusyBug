import Foundation
import Combine

@MainActor
final class AppViewModel: ObservableObject {
    enum Route: Equatable {
        case welcome, bugBook, location, age, mission, completion
    }

    @Published var route: Route = .welcome
    @Published var location: AdventureLocation?
    @Published var ageGroup: AgeGroup?
    @Published var currentMission: Mission?
    @Published var selectedChoice: String?
    @Published var stickers: Int {
        didSet {
            guard persistenceEnabled else { return }
            UserDefaults.standard.set(stickers, forKey: "bugStickerCount")
        }
    }
    @Published private(set) var earnedStickerIDs: Set<String> {
        didSet {
            guard persistenceEnabled else { return }
            UserDefaults.standard.set(Array(earnedStickerIDs), forKey: "earnedBugStickerIDs")
        }
    }
    @Published private(set) var awardedSticker: BugSticker?
    @Published var timerIsRunning = false
    @Published var timerHasStarted = false
    @Published var secondsRemaining = 15 * 60

    private(set) var missions: [Mission] = []
    private var recentMissionIDs: [String] = []
    private var timerTask: Task<Void, Never>?
    private var currentMissionAwarded = false
    private let persistenceEnabled: Bool
    private var bugBookReturnRoute: Route = .welcome
    private let soundManager: SoundManager
    private let hapticsManager: HapticsManager
    private let feedbackEnabled: Bool

    init(
        persistenceEnabled: Bool = true,
        stickerCount: Int? = nil,
        soundManager: SoundManager = .shared,
        hapticsManager: HapticsManager = .shared,
        feedbackEnabled: Bool = true
    ) {
        self.persistenceEnabled = persistenceEnabled
        self.soundManager = soundManager
        self.hapticsManager = hapticsManager
        self.feedbackEnabled = feedbackEnabled
        let savedCount = stickerCount ?? UserDefaults.standard.integer(forKey: "bugStickerCount")
        let savedIDs = persistenceEnabled
            ? Set(UserDefaults.standard.stringArray(forKey: "earnedBugStickerIDs") ?? [])
            : []
        stickers = savedCount
        earnedStickerIDs = savedIDs.isEmpty && savedCount > 0
            ? Set(BugSticker.collection.prefix(min(savedCount, BugSticker.collection.count)).map(\.id))
            : savedIDs
        awardedSticker = nil
        loadMissions()
    }

    deinit { timerTask?.cancel() }

    func begin() { route = .location }
    func showBugBook() {
        guard route != .bugBook else { return }
        if feedbackEnabled {
            if route == .completion { soundManager.stopAll() }
            soundManager.playButtonTap()
            hapticsManager.importantTap()
        }
        bugBookReturnRoute = route
        route = .bugBook
    }

    func choose(_ newLocation: AdventureLocation) {
        if feedbackEnabled { soundManager.playButtonTap() }
        location = newLocation
        route = .age
    }

    func choose(_ newAgeGroup: AgeGroup) {
        if feedbackEnabled {
            soundManager.playButtonTap()
            hapticsManager.importantTap()
        }
        ageGroup = newAgeGroup
        resetTimerState()
        showNewMission()
        route = .mission
    }

    func showNewMission() {
        guard let location, let ageGroup else { return }
        let matching = missions.filter { $0.location == location && $0.ageGroup == ageGroup }
        var available = matching.filter { !recentMissionIDs.contains($0.id) }
        if available.isEmpty {
            recentMissionIDs.removeAll()
            available = matching
        }
        currentMission = available.randomElement()
        selectedChoice = nil
        awardedSticker = nil
        currentMissionAwarded = false
        if let id = currentMission?.id {
            recentMissionIDs.append(id)
            recentMissionIDs = Array(recentMissionIDs.suffix(max(1, matching.count - 1)))
        }
    }

    func completeMission() {
        guard !currentMissionAwarded else { return }
        currentMissionAwarded = true
        let discoveredNewBug = awardSticker()
        stickers += 1
        stopTimer()
        if feedbackEnabled {
            soundManager.playRewardSequence(discoveredNewBug: discoveredNewBug)
            hapticsManager.playRewardSequence(discoveredNewBug: discoveredNewBug)
        }
        route = .completion
    }

    func nextMission() {
        if feedbackEnabled { soundManager.stopAll() }
        showNewMission()
        resetTimer()
        route = .mission
    }

    func done() {
        if feedbackEnabled { soundManager.stopAll() }
        stopTimer()
        resetTimerState()
        route = .location
        location = nil
        ageGroup = nil
    }

    func goBack() {
        switch route {
        case .bugBook:
            route = bugBookReturnRoute
        case .age:
            route = .location
        case .mission:
            stopTimer()
            resetTimerState()
            route = .age
        case .completion:
            route = .mission
        default:
            route = .welcome
        }
    }

    func toggleTimer() {
        if timerIsRunning {
            stopTimer()
        } else {
            if secondsRemaining == 0 { secondsRemaining = 15 * 60 }
            timerHasStarted = true
            startTimer()
        }
    }

    func resetTimer() {
        stopTimer()
        secondsRemaining = 15 * 60
        timerHasStarted = false
    }

    private func startTimer() {
        timerTask?.cancel()
        timerIsRunning = true
        timerTask = Task {
            while !Task.isCancelled && secondsRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                secondsRemaining -= 1
            }
            timerIsRunning = false
        }
    }

    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
        timerIsRunning = false
    }

    private func resetTimerState() {
        secondsRemaining = 15 * 60
        timerHasStarted = false
    }

    private func loadMissions() {
        guard let url = Bundle.main.url(forResource: "missions", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Mission].self, from: data) else {
            assertionFailure("missions.json could not be loaded")
            return
        }
        missions = decoded
    }

    private func awardSticker() -> Bool {
        if let next = BugSticker.collection.first(where: { !earnedStickerIDs.contains($0.id) }) {
            awardedSticker = next
            earnedStickerIDs.insert(next.id)
            return true
        } else if !BugSticker.collection.isEmpty {
            awardedSticker = BugSticker.collection[stickers % BugSticker.collection.count]
        }
        return false
    }

    static func preview(stickerCount: Int = 0) -> AppViewModel {
        AppViewModel(
            persistenceEnabled: false,
            stickerCount: stickerCount,
            feedbackEnabled: false
        )
    }

    static func missionPreview() -> AppViewModel {
        let model = preview(stickerCount: 4)
        model.choose(.restaurant)
        model.choose(.younger)
        return model
    }

    static func completionPreview() -> AppViewModel {
        let model = missionPreview()
        model.completeMission()
        return model
    }
}
