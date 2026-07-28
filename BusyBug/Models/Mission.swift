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

enum AgeGroup: String, Codable, CaseIterable, Identifiable {
    case younger = "3_4"
    case older = "5_6"

    var id: Self { self }
    var title: String { self == .younger ? "Ages 3–4" : "Ages 5–6" }
    var icon: String { self == .younger ? "3.circle.fill" : "5.circle.fill" }
}

struct Mission: Codable, Identifiable, Equatable {
    let id: String
    let location: AdventureLocation
    let ageGroup: AgeGroup
    let category: String
    let title: String
    let instruction: String
    let choices: [String]?
}
