import Foundation

struct BugSticker: Identifiable, Equatable {
    let id: String
    let name: String
    let emoji: String
    let colorIndex: Int

    static let collection: [BugSticker] = [
        BugSticker(id: "ladybug", name: "Lulu Ladybug", emoji: "🐞", colorIndex: 0),
        BugSticker(id: "bee", name: "Buzzy Bee", emoji: "🐝", colorIndex: 1),
        BugSticker(id: "butterfly", name: "Bella Butterfly", emoji: "🦋", colorIndex: 2),
        BugSticker(id: "caterpillar", name: "Curly Caterpillar", emoji: "🐛", colorIndex: 3),
        BugSticker(id: "dragonfly", name: "Dizzy Dragonfly", emoji: "🪽", colorIndex: 4),
        BugSticker(id: "firefly", name: "Flash Firefly", emoji: "✨", colorIndex: 1),
        BugSticker(id: "beetle", name: "Benny Beetle", emoji: "🪲", colorIndex: 3),
        BugSticker(id: "grasshopper", name: "Hopper", emoji: "🦗", colorIndex: 2),
        BugSticker(id: "moth", name: "Moon Moth", emoji: "🌙", colorIndex: 4),
        BugSticker(id: "ant", name: "Annie Ant", emoji: "🐜", colorIndex: 0),
        BugSticker(id: "snail", name: "Sunny Snail", emoji: "🐌", colorIndex: 1),
        BugSticker(id: "spider", name: "Spots Spider", emoji: "🕷️", colorIndex: 4)
    ]
}
