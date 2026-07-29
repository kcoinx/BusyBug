import SwiftUI

struct ParentSettingsView: View {
    @ObservedObject var soundManager: SoundManager
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            VStack(spacing: BugLayout.sectionSpacing) {
                LadybugView(state: .encouraging, size: 92)

                ScreenTitle(
                    eyebrow: "For Grown-Ups",
                    title: "Parent Settings",
                    message: "Keep adventures comfortable wherever you are."
                )
                .frame(maxWidth: .infinity, alignment: .leading)

                Toggle(isOn: soundsBinding) {
                    Label {
                        VStack(alignment: .leading, spacing: 3) {
                            Text(soundManager.soundsEnabled ? "Sounds On" : "Sounds Off")
                                .font(.system(.headline, design: .rounded, weight: .bold))
                            Text("Short, gentle sounds only")
                                .font(.subheadline)
                                .foregroundStyle(BugColor.ink.opacity(0.62))
                        }
                    } icon: {
                        Image(systemName: soundManager.soundsEnabled ? "speaker.wave.2.fill" : "speaker.slash.fill")
                            .foregroundStyle(BugColor.purple)
                            .frame(width: 44, height: 44)
                            .background(BugColor.purple.opacity(0.12), in: Circle())
                    }
                }
                .tint(BugColor.green)
                .padding(18)
                .frame(minHeight: 80)
                .bugCard(tint: BugColor.purple)
                .accessibilityHint("Turns all BusyBug sound effects on or off")

                Label("BusyBug never uses background music or spoken narration.", systemImage: "ear")
                    .font(.system(.subheadline, design: .rounded, weight: .medium))
                    .foregroundStyle(BugColor.ink.opacity(0.68))
                    .frame(maxWidth: .infinity, alignment: .leading)

                Spacer()
            }
            .padding(BugLayout.screenPadding)
            .background(PlayfulBackground())
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") { dismiss() }
                        .fontWeight(.bold)
                }
            }
        }
    }

    private var soundsBinding: Binding<Bool> {
        Binding(
            get: { soundManager.soundsEnabled },
            set: { enabled in
                soundManager.setSoundsEnabled(enabled)
                if enabled { soundManager.playButtonTap() }
                HapticsManager.shared.importantTap()
            }
        )
    }
}

#Preview("Parent Settings") {
    ParentSettingsView(soundManager: .shared)
}
