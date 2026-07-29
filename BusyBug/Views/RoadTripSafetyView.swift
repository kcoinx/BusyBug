import SwiftUI

struct RoadTripSafetyView: View {
    @ObservedObject var model: AppViewModel

    var body: some View {
        ScrollView {
            VStack(spacing: BugLayout.sectionSpacing) {
                HStack {
                    BackCircleButton { model.goBack() }
                    Spacer()
                }

                LadybugView(state: .encouraging, size: 130)

                ScreenTitle(
                    eyebrow: "Road Trip Safety",
                    title: "Ready before you roll",
                    message: "Start BusyBug before driving. Drivers should not use the app."
                )
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading, spacing: 14) {
                    safetyRow(icon: "parkingsign.circle.fill", text: "Set up the mission while safely parked.")
                    safetyRow(icon: "figure.child", text: "Hand the phone to a child passenger.")
                    safetyRow(icon: "eye.fill", text: "Children explore from their own seat.")
                }
                .padding(20)
                .bugCard(tint: BugColor.blue)

                PrimaryButton(title: "Choose My Age", icon: "arrow.right") {
                    model.continueFromRoadTripSafety()
                }
            }
            .padding(BugLayout.screenPadding)
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
        }
    }

    private func safetyRow(icon: String, text: String) -> some View {
        Label {
            Text(text)
                .font(.system(.headline, design: .rounded, weight: .semibold))
                .fixedSize(horizontal: false, vertical: true)
        } icon: {
            Image(systemName: icon)
                .font(.title2)
                .foregroundStyle(BugColor.blue)
                .frame(width: 38)
        }
    }
}

#Preview("Road Trip Safety") {
    RoadTripSafetyView(model: AppViewModel.preview())
}
