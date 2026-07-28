import Foundation
import Combine

@MainActor
final class AppViewModel: ObservableObject {
    enum Route: Equatable {
        case welcome, location, age, mission, completion
    }

    @Published var route: Route = .welcome
    @Published var location: AdventureLocation?
    @Published var ageGroup: AgeGroup?
    @Published var currentMission: Mission?
    @Published var selectedChoice: String?
    @Published var stickers = 0
    @Published var timerEnabled = false
    @Published var secondsRemaining = 15 * 60

    private(set) var missions: [Mission] = []
    private var recentMissionIDs: [String] = []
    private var timerTask: Task<Void, Never>?

    init() {
        loadMissions()
    }

    deinit { timerTask?.cancel() }

    func begin() { route = .location }

    func choose(_ newLocation: AdventureLocation) {
        location = newLocation
        route = .age
    }

    func choose(_ newAgeGroup: AgeGroup) {
        ageGroup = newAgeGroup
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
        if let id = currentMission?.id {
            recentMissionIDs.append(id)
            recentMissionIDs = Array(recentMissionIDs.suffix(max(1, matching.count - 1)))
        }
    }

    func completeMission() {
        stickers += 1
        stopTimer()
        route = .completion
    }

    func nextMission() {
        showNewMission()
        resetTimer()
        route = .mission
    }

    func done() {
        stopTimer()
        route = .location
        location = nil
        ageGroup = nil
    }

    func goBack() {
        switch route {
        case .age:
            route = .location
        case .mission:
            stopTimer()
            route = .age
        case .completion:
            route = .mission
        default:
            route = .welcome
        }
    }

    func toggleTimer() {
        timerEnabled.toggle()
        timerEnabled ? startTimer() : stopTimer()
    }

    func resetTimer() {
        stopTimer()
        secondsRemaining = 15 * 60
        if timerEnabled { startTimer() }
    }

    private func startTimer() {
        timerTask?.cancel()
        timerTask = Task {
            while !Task.isCancelled && secondsRemaining > 0 {
                try? await Task.sleep(for: .seconds(1))
                guard !Task.isCancelled else { return }
                secondsRemaining -= 1
            }
        }
    }

    private func stopTimer() {
        timerTask?.cancel()
        timerTask = nil
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
}
