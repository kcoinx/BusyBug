import SwiftUI

struct MissionView: View {
    @ObservedObject var model: AppViewModel
    @State private var choiceFeedback = 0

    var body: some View {
        ScrollView {
            VStack(spacing: BugLayout.cardSpacing) {
                header
                parentBanner
                if let mission = model.currentMission {
                    contextRow
                    missionCard(mission)
                    if let choices = mission.choices {
                        choiceGrid(choices)
                    }
                }
                ViewThatFits {
                    HStack(spacing: 14) {
                        actionButtons
                    }
                    VStack(spacing: 12) {
                        actionButtons
                    }
                }
            }
            .padding(BugLayout.screenPadding)
            .frame(maxWidth: 650)
            .frame(maxWidth: .infinity)
        }
    }

    private var header: some View {
        HStack {
            BackCircleButton { model.goBack() }
            Spacer()
            Button { model.toggleTimer() } label: {
                HStack(spacing: 7) {
                    Image(systemName: model.timerIsRunning ? "pause.fill" : "timer")
                    Text(model.timerHasStarted ? timeText : "Start 15 min")
                        .monospacedDigit()
                }
                .font(.system(.headline, design: .rounded, weight: .bold))
                .foregroundStyle(model.timerIsRunning ? .white : BugColor.purple)
                .padding(.horizontal, 14)
                .frame(minHeight: 48)
                .background(model.timerIsRunning ? BugColor.purple : .white, in: Capsule())
                .overlay(Capsule().stroke(BugColor.purple.opacity(0.9), lineWidth: 1.5))
                .contentTransition(.numericText())
            }
            .buttonStyle(BugPressButtonStyle())
            .accessibilityLabel(timerAccessibilityLabel)
        }
    }

    private var contextRow: some View {
        HStack(spacing: 8) {
            if let location = model.location {
                Label(location.title, systemImage: location.icon)
            }
            Spacer()
            if model.timerHasStarted {
                Button { model.resetTimer() } label: {
                    Label("Reset", systemImage: "arrow.counterclockwise")
                }
                .font(.system(.subheadline, design: .rounded, weight: .bold))
                .foregroundStyle(BugColor.purple)
                .frame(minHeight: 44)
                .buttonStyle(BugPressButtonStyle())
            }
        }
        .font(.system(.subheadline, design: .rounded, weight: .bold))
        .foregroundStyle(BugColor.ink.opacity(0.62))
    }

    private var parentBanner: some View {
        Label("Parent: Read this to your child", systemImage: "person.crop.circle.fill")
            .font(.system(.subheadline, design: .rounded, weight: .bold))
            .foregroundStyle(BugColor.ink)
            .frame(maxWidth: .infinity)
            .padding(13)
            .background(BugColor.yellow.opacity(0.7), in: RoundedRectangle(cornerRadius: 16))
            .overlay(RoundedRectangle(cornerRadius: 16).stroke(.white.opacity(0.6), lineWidth: 1))
    }

    private func missionCard(_ mission: Mission) -> some View {
        VStack(spacing: 16) {
            Text(mission.category.uppercased())
                .font(.caption.bold())
                .tracking(1.4)
                .foregroundStyle(BugColor.purple)
                .padding(.horizontal, 13)
                .padding(.vertical, 7)
                .background(BugColor.purple.opacity(0.12), in: Capsule())
            Text(mission.title)
                .font(.system(.title, design: .rounded, weight: .black))
                .multilineTextAlignment(.center)
                .fixedSize(horizontal: false, vertical: true)
            HStack(spacing: 14) {
                Image(systemName: categoryIcon(mission.category))
                    .font(.system(size: 48, weight: .bold))
                    .foregroundStyle(BugColor.blue)
                    .symbolEffect(.bounce, value: mission.id)
                LadybugView(state: .thinking, size: 66)
            }
            Text(mission.instruction)
                .font(.system(.title2, design: .rounded, weight: .semibold))
                .multilineTextAlignment(.center)
                .lineSpacing(5)
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(24)
        .frame(maxWidth: .infinity, minHeight: 300)
        .bugCard(tint: BugColor.blue)
        .id(mission.id)
    }

    private func choiceGrid(_ choices: [String]) -> some View {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 90), spacing: 10)], spacing: 10) {
            ForEach(choices, id: \.self) { choice in
                Button {
                    withAnimation(.bouncy) {
                        model.selectedChoice = choice
                        choiceFeedback += 1
                    }
                } label: {
                    Text(choice)
                        .font(.system(.headline, design: .rounded, weight: .bold))
                        .minimumScaleFactor(0.8)
                        .foregroundStyle(model.selectedChoice == choice ? .white : color(for: choice))
                        .frame(maxWidth: .infinity, minHeight: 58)
                        .background(
                            model.selectedChoice == choice ? color(for: choice) : color(for: choice).opacity(0.13),
                            in: RoundedRectangle(cornerRadius: 18)
                        )
                        .overlay(RoundedRectangle(cornerRadius: 18).stroke(color(for: choice).opacity(0.9), lineWidth: 2))
                }
                .buttonStyle(BugPressButtonStyle())
                .accessibilityAddTraits(model.selectedChoice == choice ? .isSelected : AccessibilityTraits())
            }
        }
        .sensoryFeedback(.selection, trigger: choiceFeedback)
    }

    @ViewBuilder
    private var actionButtons: some View {
        SecondaryButton(title: "New One", icon: "arrow.triangle.2.circlepath") {
            model.showNewMission()
        }
        PrimaryButton(
            title: "We Did It!",
            icon: "checkmark",
            playsTapSound: false,
            playsHaptic: false
        ) {
            model.completeMission()
        }
    }

    private var timeText: String {
        String(format: "%02d:%02d", model.secondsRemaining / 60, model.secondsRemaining % 60)
    }

    private var timerAccessibilityLabel: String {
        if model.timerIsRunning { return "Pause timer, \(timeText) remaining" }
        if model.timerHasStarted { return "Resume timer, \(timeText) remaining" }
        return "Start 15 minute timer"
    }

    private func categoryIcon(_ category: String) -> String {
        let lower = category.lowercased()
        if lower.contains("color") { return "paintpalette.fill" }
        if lower.contains("rainbow") { return "rainbow" }
        if lower.contains("count") { return "number.circle.fill" }
        if lower.contains("letter") { return "textformat.abc" }
        if lower.contains("alphabet") { return "textformat.abc" }
        if lower.contains("memory") { return "brain.head.profile" }
        if lower.contains("shape") { return "square.on.circle.fill" }
        if lower.contains("treasure") { return "shippingbox.fill" }
        if lower.contains("safari") { return "binoculars.fill" }
        return "eye.fill"
    }

    private func color(for choice: String) -> Color {
        switch choice.lowercased() {
        case "red": BugColor.red
        case "blue": BugColor.blue
        case "green": BugColor.green
        case "yellow": Color(red: 0.83, green: 0.62, blue: 0.0)
        default: BugColor.purple
        }
    }
}

#Preview {
    let model = AppViewModel.missionPreview()
    MissionView(model: model)
}

#Preview("Mission – Larger Text") {
    MissionView(model: AppViewModel.missionPreview())
        .environment(\.dynamicTypeSize, .accessibility1)
}
