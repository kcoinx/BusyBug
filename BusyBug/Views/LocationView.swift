import SwiftUI

struct LocationView: View {
    @ObservedObject var model: AppViewModel
    private let cardColors = [BugColor.red, BugColor.blue, BugColor.green]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BugLayout.sectionSpacing) {
                HStack {
                    BackCircleButton { model.goBack() }
                    Spacer()
                    StickerPill(count: model.stickers)
                }
                ScreenTitle(
                    eyebrow: "Step 1 of 2",
                    title: "Where are you?",
                    message: "Pick your setting and we’ll find the fun."
                )
                VStack(spacing: BugLayout.cardSpacing) {
                    ForEach(Array(AdventureLocation.allCases.enumerated()), id: \.element.id) { index, location in
                        Button {
                            model.choose(location)
                        } label: {
                            HStack(spacing: 22) {
                                ZStack {
                                    Circle().fill(.white.opacity(0.25))
                                    Image(systemName: location.icon)
                                        .font(.system(size: 38, weight: .bold))
                                    Image(systemName: accentIcon(for: location))
                                        .font(.caption.bold())
                                        .padding(7)
                                        .foregroundStyle(cardColors[index])
                                        .background(.white, in: Circle())
                                        .offset(x: 29, y: -29)
                                }
                                .frame(width: 76, height: 76)
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(location.title)
                                        .font(.system(.title2, design: .rounded, weight: .black))
                                    Text(locationSubtitle(for: location))
                                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                                        .foregroundStyle(.white.opacity(0.85))
                                        .fixedSize(horizontal: false, vertical: true)
                                }
                                Spacer()
                                Image(systemName: "chevron.right")
                                    .font(.title2.bold())
                            }
                            .foregroundStyle(.white)
                            .padding(20)
                            .frame(maxWidth: .infinity, minHeight: 120)
                            .background(cardColors[index].gradient, in: RoundedRectangle(cornerRadius: BugLayout.cardRadius))
                            .overlay {
                                RoundedRectangle(cornerRadius: BugLayout.cardRadius)
                                    .stroke(.white.opacity(0.28), lineWidth: 1)
                            }
                            .shadow(color: cardColors[index].opacity(0.2), radius: 12, y: 6)
                        }
                        .buttonStyle(BugPressButtonStyle())
                    }
                }
            }
            .padding(BugLayout.screenPadding)
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
    }

    private func locationSubtitle(for location: AdventureLocation) -> String {
        switch location {
        case .restaurant: "Table-time adventures"
        case .roadTrip: "Window-side discoveries"
        case .groceryStore: "Aisle-by-aisle fun"
        }
    }

    private func accentIcon(for location: AdventureLocation) -> String {
        switch location {
        case .restaurant: "cup.and.saucer.fill"
        case .roadTrip: "road.lanes"
        case .groceryStore: "carrot.fill"
        }
    }
}

struct StickerPill: View {
    let count: Int
    var body: some View {
        HStack(spacing: 7) {
            Image(systemName: "ladybug.fill").foregroundStyle(BugColor.red)
            Text("\(count)")
                .font(.system(.headline, design: .rounded, weight: .bold))
        }
        .padding(.horizontal, 14)
        .frame(minHeight: 44)
        .background(BugColor.surface, in: Capsule())
        .overlay(Capsule().stroke(.white.opacity(0.8), lineWidth: 1))
        .shadow(color: BugColor.ink.opacity(0.07), radius: 6, y: 3)
        .accessibilityLabel("\(count) bug stickers")
    }
}

#Preview { LocationView(model: AppViewModel()) }

#Preview("Location – Larger Text") {
    LocationView(model: AppViewModel.preview(stickerCount: 5))
        .environment(\.dynamicTypeSize, .accessibility1)
}
