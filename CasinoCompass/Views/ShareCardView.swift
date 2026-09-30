import SwiftUI

struct ShareSummary {
    let distance: String
    let venueName: String?
    let isNearest: Bool
    let isDemo: Bool
    let tableGamesNotice: String?
    let appLink: String

    var introduction: String { isDemo ? "Vancouver demo" : "I am" }
    var destination: String {
        isNearest ? "from the nearest listed casino." : "from this selected casino."
    }
    var text: String {
        [isDemo ? "Demo location: Vancouver." : nil,
         "\(isDemo ? "Demo distance:" : "I am") \(distance) \(destination)",
         venueName, tableGamesNotice,
         "Straight-line distance. Explore CasinoCompass: \(appLink)"]
            .compactMap { $0 }.joined(separator: "\n")
    }
}

struct ShareCardView: View {
    let summary: ShareSummary

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [Color(red: 0.05, green: 0.07, blue: 0.09),
                         Color(red: 0.08, green: 0.18, blue: 0.15),
                         Color(red: 0.32, green: 0.27, blue: 0.10)],
                startPoint: .topLeading, endPoint: .bottomTrailing
            )
            VStack(spacing: 28) {
                Text("CasinoCompass")
                    .font(.system(size: 54, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity, alignment: .leading)
                Spacer()
                Text(summary.introduction)
                    .font(.system(size: 40, weight: .semibold, design: .rounded))
                Text(summary.distance)
                    .font(.system(size: 120, weight: .black, design: .rounded))
                    .monospacedDigit()
                    .minimumScaleFactor(0.5)
                Text(summary.destination)
                    .font(.system(size: 44, weight: .semibold, design: .rounded))
                if let name = summary.venueName {
                    Text(name)
                        .font(.system(size: 38, weight: .bold, design: .rounded))
                }
                if let notice = summary.tableGamesNotice {
                    Text(notice)
                        .font(.system(size: 34, weight: .semibold, design: .rounded))
                        .foregroundStyle(.yellow)
                }
                Text("Straight-line distance • bundled venue data")
                    .font(.system(size: 28, weight: .medium))
                    .foregroundStyle(.white.opacity(0.8))
                Spacer()
                Text("Explore nearby casinos with CasinoCompass.")
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Text(summary.appLink)
                    .font(.system(size: 26, weight: .medium, design: .rounded))
                    .foregroundStyle(.mint)
                    .lineLimit(2)
                    .minimumScaleFactor(0.75)
            }
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            .padding(72)
        }
        .frame(width: 1080, height: 1350)
    }
}
