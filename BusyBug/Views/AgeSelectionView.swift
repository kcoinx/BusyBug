import SwiftUI

struct AgeSelectionView: View {
    @ObservedObject var model: AppViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                BackCircleButton { model.goBack() }
                Text("How old is your\nlittle explorer?")
                    .font(.system(.largeTitle, design: .rounded, weight: .black))
                Text("We’ll choose missions that match their age.")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(BugColor.ink.opacity(0.7))
                VStack(spacing: 18) {
                    ageCard(.younger, color: BugColor.yellow)
                    ageCard(.older, color: BugColor.purple)
                }
                .padding(.top, 12)
            }
            .padding(24)
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
    }

    private func ageCard(_ age: AgeGroup, color: Color) -> some View {
        Button {
            model.choose(age)
        } label: {
            VStack(spacing: 14) {
                Image(systemName: age.icon)
                    .font(.system(size: 64, weight: .bold))
                Text(age.title)
                    .font(.system(.title, design: .rounded, weight: .bold))
            }
            .foregroundStyle(age == .younger ? BugColor.ink : .white)
            .frame(maxWidth: .infinity, minHeight: 190)
            .background(color.gradient, in: RoundedRectangle(cornerRadius: 30))
            .shadow(color: color.opacity(0.25), radius: 8, y: 5)
        }
        .buttonStyle(.plain)
    }
}

#Preview { AgeSelectionView(model: AppViewModel()) }
