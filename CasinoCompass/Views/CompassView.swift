import SwiftUI

struct CompassView: View {
    let relativeAngle: Double
    let distance: String
    let venueName: String?
    let venueNote: String?
    let status: String
    let isUsingDemo: Bool

    @State private var displayedAngle: Double?

    var body: some View {
        ZStack {
            ForEach(0..<4) { index in
                Circle()
                    .stroke(.white.opacity(0.07 + Double(index) * 0.025), lineWidth: 1)
                    .frame(width: CGFloat(150 + index * 72), height: CGFloat(150 + index * 72))
            }

            Circle()
                .fill(
                    RadialGradient(
                        colors: [.mint.opacity(0.36), .mint.opacity(0.06), .clear],
                        center: .center,
                        startRadius: 8,
                        endRadius: 170
                    )
                )
                .frame(width: 330, height: 330)
                .blur(radius: 1)

            VStack(spacing: 18) {
                ZStack {
                    Capsule()
                        .fill(.white.opacity(0.12))
                        .frame(width: 92, height: 210)
                        .offset(y: -46)

                    Image(systemName: "location.north.fill")
                        .font(.system(size: 108, weight: .black))
                        .foregroundStyle(
                            LinearGradient(
                                colors: [.white, .mint, .yellow],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .shadow(color: .mint.opacity(0.65), radius: 24, x: 0, y: 0)
                        .offset(y: -52)
                }
                .rotationEffect(.degrees(displayedAngle ?? relativeAngle))
                .animation(.spring(response: 0.55, dampingFraction: 0.78), value: displayedAngle)
                .frame(width: 260, height: 260)
                .accessibilityLabel("Direction pointer")

                VStack(spacing: 8) {
                    Text(distance)
                        .font(.system(size: 58, weight: .bold, design: .rounded))
                        .monospacedDigit()
                        .foregroundStyle(.white)
                        .minimumScaleFactor(0.65)

                    if let venueName {
                        Text(venueName)
                            .font(.system(size: 22, weight: .semibold, design: .rounded))
                            .foregroundStyle(.white.opacity(0.9))
                            .multilineTextAlignment(.center)
                            .lineLimit(2)
                            .minimumScaleFactor(0.8)
                    }

                    if let venueNote {
                        Text(venueNote)
                            .font(.caption.weight(.bold))
                            .foregroundStyle(.mint.opacity(0.9))
                            .multilineTextAlignment(.center)
                    }

                    Text(isUsingDemo ? "Demo location active" : status)
                        .font(.footnote.weight(.medium))
                        .foregroundStyle(.white.opacity(0.62))
                }
                .padding(.horizontal, 22)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: 520)
        .onAppear {
            displayedAngle = relativeAngle
        }
        .onChange(of: relativeAngle) { _, newAngle in
            displayedAngle = continuousAngle(from: displayedAngle, to: newAngle)
        }
    }

    private func continuousAngle(from currentAngle: Double?, to newAngle: Double) -> Double {
        guard let currentAngle else { return newAngle }

        let delta = shortestDelta(from: currentAngle, to: newAngle)
        return currentAngle + delta
    }

    private func shortestDelta(from currentAngle: Double, to newAngle: Double) -> Double {
        let rawDelta = newAngle - currentAngle
        let normalizedDelta = (rawDelta + 180).truncatingRemainder(dividingBy: 360) - 180
        return normalizedDelta < -180 ? normalizedDelta + 360 : normalizedDelta
    }
}
