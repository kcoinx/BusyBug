import Foundation

enum AdventureLocation: String, Codable, CaseIterable, Identifiable {
    case restaurant
    case roadTrip = "road_trip"
    case groceryStore = "grocery_store"

    var id: Self { self }
    var title: String {
        switch self {
        case .restaurant: "Restaurant"
        case .roadTrip: "Road Trip"
        case .groceryStore: "Grocery Store"
        }
    }
    var icon: String {
        switch self {
        case .restaurant: "fork.knife"
        case .roadTrip: "car.fill"
        case .groceryStore: "cart.fill"
        }
    }
}

enum AgeBand: String, Codable, CaseIterable, Identifiable {
    case younger = "3_4"
    case middle = "5_6"
    case older = "7_8"

    var id: Self { self }
    var title: String {
        switch self {
        case .younger: return "Ages 3–4"
        case .middle: return "Ages 5–6"
        case .older: return "Ages 7–8"
        }
    }
}

enum MissionInteraction: String, Codable, CaseIterable {
    case find
    case count
    case choose
    case remember
    case observe
    case imagine
}

enum MissionDifficulty: String, Codable, CaseIterable {
    case easy
    case medium
    case challenge
}

struct Mission: Codable, Identifiable, Equatable {
    let id: String
    let location: AdventureLocation
    let ageBand: AgeBand
    let category: String
    let title: String
    let instruction: String
    let choices: [String]?
    let durationMinutes: Int
    let interactionType: MissionInteraction
    let difficulty: MissionDifficulty
    let spokenText: String?

    var narrationText: String { spokenText ?? instruction }
    var requiresChoice: Bool { choices?.isEmpty == false }

    var completionLabel: String {
        switch interactionType {
        case .find, .choose, .observe:
            return "I Found It!"
        case .count:
            return "I Counted It!"
        case .remember, .imagine:
            return "I Did It!"
        }
    }
}
