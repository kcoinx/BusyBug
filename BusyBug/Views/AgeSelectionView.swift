import SwiftUI

struct AgeSelectionView: View {
    @ObservedObject var model: AppViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: BugLayout.sectionSpacing) {
                BackCircleButton { model.goBack() }
                ScreenTitle(
                    eyebrow: "Step 2 of 2",
                    title: "How old is your\nlittle explorer?",
                    message: "We’ll choose missions that match their age."
                )
                VStack(spacing: BugLayout.cardSpacing) {
                    ageCard(.younger, color: BugColor.yellow)
                    ageCard(.older, color: BugColor.purple)
                }
                .padding(.top, 12)
            }
            .padding(BugLayout.screenPadding)
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
    }

    private func ageCard(_ age: AgeGroup, color: Color) -> some View {
        Button {
            model.choose(age)
        } label: {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 18) {
                    ageBadge(age)
                    ageCopy(age)
                    Spacer()
                    chevron
                }
                VStack(alignment: .leading, spacing: 12) {
                    HStack {
                        ageBadge(age)
                        Spacer()
                        chevron
                    }
                    ageCopy(age)
                }
            }
            .padding(22)
            .foregroundStyle(age == .younger ? BugColor.ink : .white)
            .frame(maxWidth: .infinity, minHeight: 150)
            .background(color.gradient, in: RoundedRectangle(cornerRadius: BugLayout.cardRadius))
            .overlay {
                RoundedRectangle(cornerRadius: BugLayout.cardRadius)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            }
            .shadow(color: color.opacity(0.2), radius: 12, y: 6)
        }
        .buttonStyle(BugPressButtonStyle())
    }

    private func ageBadge(_ age: AgeGroup) -> some View {
        Text(age == .younger ? "3–4" : "5–6")
            .font(.system(size: 38, weight: .black, design: .rounded))
            .frame(width: 94, height: 94)
            .background(.white.opacity(0.27), in: Circle())
    }

    private func ageCopy(_ age: AgeGroup) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(age.title)
                .font(.system(.title2, design: .rounded, weight: .black))
            Text(age == .younger ? "Look, match & count" : "Read, remember & discover")
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(age == .younger ? BugColor.ink.opacity(0.68) : .white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private var chevron: some View {
        Image(systemName: "chevron.right")
            .font(.title2.bold())
    }
}

#Preview { AgeSelectionView(model: AppViewModel()) }

#Preview("Age – Larger Text") {
    AgeSelectionView(model: AppViewModel.preview())
        .environment(\.dynamicTypeSize, .accessibility1)
}
