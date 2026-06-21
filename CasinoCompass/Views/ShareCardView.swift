import SwiftUI

struct ShareCardView: View {
    let distance: String
    let appLink: String

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.05, green: 0.07, blue: 0.09),
                    Color(red: 0.08, green: 0.18, blue: 0.15),
                    Color(red: 0.62, green: 0.46, blue: 0.16)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            VStack(spacing: 32) {
                HStack {
                    Text("CasinoCompass")
                        .font(.system(size: 54, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                    Spacer()
                }

                Spacer()

                VStack(spacing: 18) {
                    Text("I am")
                        .font(.system(size: 44, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.72))

                    Text(distance)
                        .font(.system(size: 120, weight: .black, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.5)

                    Text("from the closest casino.")
                        .font(.system(size: 48, weight: .semibold, design: .rounded))
                        .foregroundStyle(.white.opacity(0.86))
                        .multilineTextAlignment(.center)
                }

                Spacer()

                VStack(spacing: 16) {
                    Text("Download CasinoCompass to find the closest casino to you.")
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4)

                    Text(appLink)
                        .font(.system(size: 30, weight: .medium, design: .rounded))
                        .foregroundStyle(.mint.opacity(0.92))
                }
            }
            .padding(72)
        }
        .frame(width: 1080, height: 1350)
    }
}
