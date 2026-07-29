import Foundation

struct BugSticker: Identifiable, Equatable {
    let id: String
    let name: String
    let emoji: String
    let colorIndex: Int
    let personality: String
    let fact: String
    let habitatGroup: String

    static let collection: [BugSticker] = [
        BugSticker(id: "ladybug", name: "Lulu Ladybug", emoji: "🐞", colorIndex: 0, personality: "Brave explorer", fact: "Ladybugs can tuck their wings under their spotted shells.", habitatGroup: "Garden Friends"),
        BugSticker(id: "bee", name: "Buzzy Bee", emoji: "🐝", colorIndex: 1, personality: "Busy helper", fact: "Bees share flower directions with a little dance.", habitatGroup: "Garden Friends"),
        BugSticker(id: "butterfly", name: "Bella Butterfly", emoji: "🦋", colorIndex: 2, personality: "Gentle dreamer", fact: "Butterflies taste with their feet.", habitatGroup: "Sky Explorers"),
        BugSticker(id: "caterpillar", name: "Curly Caterpillar", emoji: "🐛", colorIndex: 3, personality: "Curious muncher", fact: "A caterpillar grows by shedding its skin.", habitatGroup: "Leafy Friends"),
        BugSticker(id: "dragonfly", name: "Dizzy Dragonfly", emoji: "🪽", colorIndex: 4, personality: "Speedy flyer", fact: "Dragonflies can fly forward, backward, and sideways.", habitatGroup: "Pond Pals"),
        BugSticker(id: "firefly", name: "Flash Firefly", emoji: "✨", colorIndex: 1, personality: "Nighttime spark", fact: "Fireflies make their own gentle light.", habitatGroup: "Night Explorers"),
        BugSticker(id: "beetle", name: "Benny Beetle", emoji: "🪲", colorIndex: 3, personality: "Strong adventurer", fact: "Beetles have tough wing covers like tiny shields.", habitatGroup: "Forest Friends"),
        BugSticker(id: "grasshopper", name: "Hopper", emoji: "🦗", colorIndex: 2, personality: "Bouncy buddy", fact: "Grasshoppers hear with special spots on their bodies.", habitatGroup: "Meadow Mates"),
        BugSticker(id: "moth", name: "Moon Moth", emoji: "🌙", colorIndex: 4, personality: "Cozy night owl", fact: "Many moths use moonlight to help them travel.", habitatGroup: "Night Explorers"),
        BugSticker(id: "ant", name: "Annie Ant", emoji: "🐜", colorIndex: 0, personality: "Team captain", fact: "Ants use scent trails to guide their friends.", habitatGroup: "Ground Crew"),
        BugSticker(id: "snail", name: "Sunny Snail", emoji: "🐌", colorIndex: 1, personality: "Patient traveler", fact: "A snail carries its home wherever it goes.", habitatGroup: "Garden Friends"),
        BugSticker(id: "spider", name: "Spots Spider", emoji: "🕷️", colorIndex: 4, personality: "Clever builder", fact: "Spiders make silk that is thin and strong.", habitatGroup: "Web Weavers")
    ]
}
