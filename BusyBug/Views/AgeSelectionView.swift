import SwiftUI

struct AgeSelectionView: View {
    @ObservedObject var model: AppViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 22) {
                BackCircleButton { model.goBack() }
                ScreenTitle(
                    eyebrow: "Step 2 of 2",
                    title: "How old is your\nlittle explorer?",
                    message: "We’ll choose missions that match their age."
                )
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
            HStack(spacing: 18) {
                Text(age == .younger ? "3–4" : "5–6")
                    .font(.system(size: 38, weight: .black, design: .rounded))
                    .frame(width: 94, height: 94)
                    .background(.white.opacity(0.27), in: Circle())
                VStack(alignment: .leading, spacing: 6) {
                    Text(age.title)
                        .font(.system(.title2, design: .rounded, weight: .bold))
                    Text(age == .younger ? "Look, match & count" : "Read, remember & discover")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(age == .younger ? BugColor.ink.opacity(0.68) : .white.opacity(0.85))
                }
                Spacer()
                Image(systemName: "chevron.right")
                    .font(.title2.bold())
            }
            .padding(22)
            .foregroundStyle(age == .younger ? BugColor.ink : .white)
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(color.gradient, in: RoundedRectangle(cornerRadius: 30))
            .shadow(color: color.opacity(0.25), radius: 8, y: 5)
        }
        .buttonStyle(.plain)
    }
}

#Preview { AgeSelectionView(model: AppViewModel()) }
