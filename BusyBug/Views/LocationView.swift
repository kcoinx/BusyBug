import SwiftUI

struct LocationView: View {
    @ObservedObject var model: AppViewModel
    private let cardColors = [BugColor.red, BugColor.blue, BugColor.green]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                HStack {
                    BackCircleButton { model.goBack() }
                    Spacer()
                    StickerPill(count: model.stickers)
                }
                Text("Where are you?")
                    .font(.system(.largeTitle, design: .rounded, weight: .black))
                VStack(spacing: 16) {
                    ForEach(Array(AdventureLocation.allCases.enumerated()), id: \.element.id) { index, location in
                        Button {
                            model.choose(location)
                        } label: {
                            HStack(spacing: 22) {
                                Image(systemName: location.icon)
                                    .font(.system(size: 42, weight: .bold))
                                    .frame(width: 74, height: 74)
                                    .background(.white.opacity(0.25), in: Circle())
                                Text(location.title)
                                    .font(.system(.title2, design: .rounded, weight: .bold))
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.title2.bold())
                            }
                            .foregroundStyle(.white)
                            .padding(20)
                            .frame(maxWidth: .infinity, minHeight: 120)
                            .background(cardColors[index].gradient, in: RoundedRectangle(cornerRadius: 28))
                            .shadow(color: cardColors[index].opacity(0.25), radius: 7, y: 5)
                        }
                        .buttonStyle(.plain)
                    }
                }
            }
            .padding(24)
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
    }
}

struct StickerPill: View {
    let count: Int
    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: "ladybug.fill").foregroundStyle(BugColor.red)
            Text("\(count)").font(.headline)
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 44)
        .background(.white.opacity(0.9), in: Capsule())
        .accessibilityLabel("\(count) bug stickers")
    }
}

#Preview { LocationView(model: AppViewModel()) }
