import SwiftUI

struct AgeSelectionView: View {
    @ObservedObject var model: AppViewModel

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 12) {
                BackCircleButton { model.goBack() }
                ScreenTitle(
                    eyebrow: "Step 2 of 2",
                    title: "How old is your explorer?",
                    message: "We’ll choose missions that match their age."
                )
                VStack(spacing: 10) {
                    ageCard(.younger, color: BugColor.yellow)
                    ageCard(.middle, color: BugColor.purple)
                    ageCard(.older, color: BugColor.blue)
                }
            }
            .padding(.horizontal, BugLayout.screenPadding)
            .padding(.vertical, 12)
            .frame(maxWidth: 600)
            .frame(maxWidth: .infinity)
        }
    }

    private func ageCard(_ age: AgeBand, color: Color) -> some View {
        Button {
            model.choose(age)
        } label: {
            ViewThatFits(in: .horizontal) {
                HStack(spacing: 14) {
                    ageBadge(age)
                    ageCopy(age)
                    Spacer()
                    chevron
                }
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        ageBadge(age)
                        Spacer()
                        chevron
                    }
                    ageCopy(age)
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
            .foregroundStyle(age == .younger ? BugColor.ink : .white)
            .frame(maxWidth: .infinity, minHeight: 104)
            .background(color.gradient, in: RoundedRectangle(cornerRadius: BugLayout.cardRadius))
            .overlay {
                RoundedRectangle(cornerRadius: BugLayout.cardRadius)
                    .stroke(.white.opacity(0.3), lineWidth: 1)
            }
            .shadow(color: color.opacity(0.2), radius: 12, y: 6)
        }
        .buttonStyle(BugPressButtonStyle())
    }

    private func ageBadge(_ age: AgeBand) -> some View {
        Text(ageRange(age))
            .font(.system(size: 28, weight: .black, design: .rounded))
            .frame(width: 64, height: 64)
            .background(.white.opacity(0.27), in: Circle())
    }

    private func ageCopy(_ age: AgeBand) -> some View {
        VStack(alignment: .leading, spacing: 3) {
            Text(age.title)
                .font(.system(.title3, design: .rounded, weight: .black))
            Text(ageDescription(age))
                .font(.system(.subheadline, design: .rounded, weight: .semibold))
                .foregroundStyle(age == .younger ? BugColor.ink.opacity(0.68) : .white.opacity(0.85))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func ageRange(_ age: AgeBand) -> String {
        switch age {
        case .younger: return "3–4"
        case .middle: return "5–6"
        case .older: return "7–8"
        }
    }

    private func ageDescription(_ age: AgeBand) -> String {
        switch age {
        case .younger: return "Look, match & count"
        case .middle: return "Read, remember & discover"
        case .older: return "Solve, imagine & explore"
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

#Preview("Age – Compact Height") {
    AgeSelectionView(model: AppViewModel.preview())
        .frame(width: 375, height: 667)
}

#Preview("Age – Pro Height") {
    AgeSelectionView(model: AppViewModel.preview())
        .frame(width: 402, height: 874)
}
