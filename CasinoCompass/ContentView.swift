import CoreLocation
import SwiftUI
import UIKit

private enum AppLinks {
    static let website = URL(string: "https://casinocompass.app")!
    static let privacyPolicy = URL(string: "https://casinocompass.app/privacy")!
    static let support = URL(string: "https://casinocompass.app/support")!
    static let responsibleGamblingCouncil = URL(string: "https://responsiblegambling.org/for-the-public/help-for-problem-gambling/help-for-canadians/")!
}

struct ContentView: View {
    @Environment(\.scenePhase) private var scenePhase

    @AppStorage("hasAcceptedAgeGate") private var hasAcceptedAgeGate = false
    @AppStorage("showVenueName") private var showVenueName = true

    @StateObject private var locationService = LocationService()
    @State private var selectedVenueIndex = 0
    @State private var shareItems: [Any] = []
    @State private var isShowingShareSheet = false
    @State private var isShowingDetails = false
    @State private var isShowingSettings = false
    @State private var isShowingNoOtherVenueAlert = false
    @State private var wasFacingCorrectDirection = false
    @State private var headerTagline = Self.headerTaglines.randomElement() ?? Self.defaultHeaderTagline

    private let appLink = AppLinks.website.absoluteString
    private let newVenueRadiusMeters: CLLocationDistance = 50_000
    private let correctDirectionThreshold = 8.0
    private let correctPathFadeStart = 45.0

    private static let defaultHeaderTagline = "Subtle guidance. Questionable destiny."
    private static let headerTaglines = [
        defaultHeaderTagline,
        "Get to where you NEED to go.",
        "You miss 100% of the shots you don't take.",
        "The odds are in favour.",
        "Follow your heart. And the blinking arrow.",
        "A little luck. A lot of questionable navigation.",
        "Responsible choices. Irresponsibly stylish compass.",
        "Destiny has a table minimum.",
        "Pointing you toward statistically complicated decisions.",
        "For entertainment purposes, obviously.",
        "Your future called. It wants directions.",
        "The house always has an address.",
        "Go forth. Tip responsibly.",
        "Not financial advice. Definitely directional advice."
    ]

    var body: some View {
        ZStack {
            AppBackground(correctPathProgress: correctPathProgress)

            if hasAcceptedAgeGate {
                mainExperience
                    .task {
                        locationService.refreshCurrentLocation()
                    }
            } else {
                AgeGateView {
                    hasAcceptedAgeGate = true
                    locationService.refreshCurrentLocation()
                }
            }
        }
        .onChange(of: scenePhase) { _, scenePhase in
            guard scenePhase == .active, hasAcceptedAgeGate else { return }
            locationService.refreshCurrentLocation()
        }
        .onChange(of: locationService.locationUpdateID) { _, _ in
            selectedVenueIndex = 0
            wasFacingCorrectDirection = false
        }
        .onChange(of: isFacingCorrectDirection) { _, isFacingCorrectDirection in
            guard hasAcceptedAgeGate else { return }
            if isFacingCorrectDirection && !wasFacingCorrectDirection {
                playCorrectDirectionFeedback()
            }
            wasFacingCorrectDirection = isFacingCorrectDirection
        }
        .sheet(isPresented: $isShowingShareSheet) {
            ShareSheet(items: shareItems)
                .presentationDetents([.medium, .large])
        }
        .sheet(isPresented: $isShowingDetails) {
            VenueDetailsView(
                venue: selectedVenue,
                distance: formattedDistance,
                isUsingDemo: locationService.isUsingDemoLocation
            )
            .presentationDetents([.medium])
        }
        .sheet(isPresented: $isShowingSettings) {
            SettingsView()
                .presentationDetents([.large])
        }
        .alert("No Other Venue In Dataset", isPresented: $isShowingNoOtherVenueAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text("CasinoCompass does not have another qualifying casino within \(CompassMath.formattedDistance(newVenueRadiusMeters)) in its current venue dataset.")
        }
    }

    private var mainExperience: some View {
        VStack(spacing: 0) {
            header

            Spacer(minLength: 4)

            CompassView(
                relativeAngle: relativeAngle,
                distance: formattedDistance,
                venueName: showVenueName ? selectedVenue.name : nil,
                venueNote: venueNote,
                status: locationService.statusMessage,
                isUsingDemo: locationService.isUsingDemoLocation
            )

            controls
                .padding(.horizontal, 20)
                .padding(.bottom, 18)
        }
    }

    private var header: some View {
        HStack(alignment: .top) {
            VStack(alignment: .leading, spacing: 6) {
                Text("CasinoCompass")
                    .font(.system(size: 31, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text(headerTagline)
                    .font(.subheadline.weight(.medium))
                    .foregroundStyle(.white.opacity(0.64))
                    .lineLimit(2)
                    .minimumScaleFactor(0.82)
            }

            Spacer()

            HStack(spacing: 10) {
                Button {
                    isShowingSettings = true
                } label: {
                    Image(systemName: "gearshape.fill")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(.white.opacity(0.12), in: Circle())
                }
                .accessibilityLabel("Settings")

                Button {
                    if locationService.isUsingDemoLocation {
                        locationService.refreshCurrentLocation()
                    } else {
                        locationService.useDemoLocation()
                    }
                } label: {
                    Image(systemName: locationService.isUsingDemoLocation ? "location.fill" : "sparkles")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(.white.opacity(0.12), in: Circle())
                }
                .accessibilityLabel(locationService.isUsingDemoLocation ? "Use live location" : "Use demo location")
            }
        }
        .padding(.horizontal, 22)
        .padding(.top, 22)
    }

    private var controls: some View {
        VStack(spacing: 14) {
            HStack(spacing: 12) {
                ActionButton(title: "Details", systemImage: "info.circle") {
                    isShowingDetails = true
                }

                ActionButton(title: "New Venue", systemImage: "arrow.triangle.2.circlepath") {
                    selectNextVenue()
                }
            }

            HStack(spacing: 12) {
                ActionButton(title: showVenueName ? "Hide Name" : "Show Name", systemImage: showVenueName ? "eye.slash" : "eye") {
                    showVenueName.toggle()
                }

                ActionButton(title: "Share", systemImage: "square.and.arrow.up") {
                    createShareCard()
                }
            }
        }
    }

    private var currentCoordinate: CLLocationCoordinate2D {
        locationService.location ?? CasinoData.demoCoordinate
    }

    private var sortedVenues: [CasinoVenue] {
        CasinoData.venues
            .filter(\.hasTableGames)
            .sorted { $0.distance(from: currentCoordinate) < $1.distance(from: currentCoordinate) }
    }

    private var candidateVenues: [CasinoVenue] {
        let nearby = sortedVenues.filter { $0.distance(from: currentCoordinate) <= newVenueRadiusMeters }
        return nearby.isEmpty ? Array(sortedVenues.prefix(1)) : nearby
    }

    private var selectedVenue: CasinoVenue {
        let venues = candidateVenues
        guard !venues.isEmpty else { return CasinoData.venues[0] }
        let safeIndex = selectedVenueIndex % venues.count
        return venues[safeIndex]
    }

    private var selectedVenuePosition: Int {
        guard !candidateVenues.isEmpty else { return 1 }
        return selectedVenueIndex % candidateVenues.count + 1
    }

    private var venueNote: String? {
        guard candidateVenues.count > 1, selectedVenuePosition > 1 else { return nil }
        return "Alternate venue \(selectedVenuePosition) of \(candidateVenues.count)"
    }

    private var targetBearing: Double {
        selectedVenue.bearing(from: currentCoordinate)
    }

    private var relativeAngle: Double {
        CompassMath.relativeAngle(targetBearing: targetBearing, heading: locationService.heading)
    }

    private var directionError: Double {
        min(relativeAngle, 360 - relativeAngle)
    }

    private var isFacingCorrectDirection: Bool {
        directionError <= correctDirectionThreshold
    }

    private var correctPathProgress: Double {
        let progress = (correctPathFadeStart - directionError) / (correctPathFadeStart - correctDirectionThreshold)
        return min(max(progress, 0), 1)
    }

    private var selectedDistance: CLLocationDistance {
        selectedVenue.distance(from: currentCoordinate)
    }

    private var formattedDistance: String {
        CompassMath.formattedDistance(selectedDistance)
    }

    private func selectNextVenue() {
        guard candidateVenues.count > 1 else {
            isShowingNoOtherVenueAlert = true
            return
        }
        selectedVenueIndex = (selectedVenueIndex + 1) % candidateVenues.count
        wasFacingCorrectDirection = false
    }

    private func createShareCard() {
        let card = ShareCardView(distance: formattedDistance, appLink: appLink)
        let renderer = ImageRenderer(content: card)
        renderer.proposedSize = ProposedViewSize(width: 1080, height: 1350)
        renderer.scale = 1

        guard let image = renderer.uiImage else {
            shareItems = ["Download CasinoCompass to find the closest casino to you. \(appLink)"]
            isShowingShareSheet = true
            return
        }

        shareItems = [
            image,
            "Download CasinoCompass to find the closest casino to you. \(appLink)"
        ]
        isShowingShareSheet = true
    }

    private func playCorrectDirectionFeedback() {
        let notificationFeedback = UINotificationFeedbackGenerator()
        notificationFeedback.prepare()
        notificationFeedback.notificationOccurred(.success)

        Task { @MainActor in
            for delay in [0, 90_000_000, 180_000_000] {
                if delay > 0 {
                    try? await Task.sleep(nanoseconds: UInt64(delay))
                }
                UIImpactFeedbackGenerator(style: .heavy).impactOccurred(intensity: 0.9)
            }
        }
    }
}

private struct AgeGateView: View {
    let onAccept: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Spacer()

            VStack(alignment: .leading, spacing: 14) {
                Text("CasinoCompass")
                    .font(.system(size: 44, weight: .black, design: .rounded))
                    .foregroundStyle(.white)

                Text("A novelty compass for adults who want to know where the nearest full casino is. For science, satire, and maybe a deeply unnecessary walk.")
                    .font(.title3.weight(.medium))
                    .foregroundStyle(.white.opacity(0.72))
                    .lineSpacing(3)
            }

            VStack(alignment: .leading, spacing: 12) {
                Label("Legal age only", systemImage: "checkmark.seal.fill")
                Label("Uses location while the app is open", systemImage: "location.fill")
                Label("No betting, accounts, or casino promos", systemImage: "checkmark.shield.fill")
                Label("Use local laws and safer-play limits", systemImage: "hand.raised.fill")
            }
            .font(.headline)
            .foregroundStyle(.white.opacity(0.86))

            Button(action: onAccept) {
                HStack {
                    Text("I meet the legal age in my location")
                        .fontWeight(.bold)
                        .lineLimit(1)
                        .minimumScaleFactor(0.78)
                    Spacer()
                    Image(systemName: "arrow.right")
                }
                .foregroundStyle(.black)
                .padding(.horizontal, 20)
                .frame(height: 58)
                .background(.mint, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            }

            HStack(spacing: 14) {
                Link("Privacy", destination: AppLinks.privacyPolicy)
                Link("Support", destination: AppLinks.support)
                Link("Safer Play", destination: AppLinks.responsibleGamblingCouncil)
            }
            .font(.footnote.weight(.semibold))
            .foregroundStyle(.mint)

            Spacer()
        }
        .padding(28)
    }
}

private struct SettingsView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 24) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Release Info")
                            .font(.largeTitle.bold())
                        Text("CasinoCompass is a novelty location utility. It does not enable betting, deposits, accounts, casino promotions, or gambling transactions.")
                            .font(.body)
                            .foregroundStyle(.secondary)
                    }

                    SettingsSection(title: "Privacy") {
                        ResourceLinkRow(
                            icon: "location.fill",
                            title: "Location use",
                            detail: "Used on device while the app is open to calculate distance and direction. CasinoCompass does not store location history or run analytics.",
                            url: AppLinks.privacyPolicy
                        )
                        ResourceLinkRow(
                            icon: "hand.raised.fill",
                            title: "Privacy policy",
                            detail: "Read the release privacy policy before installing or reviewing the app.",
                            url: AppLinks.privacyPolicy
                        )
                    }

                    SettingsSection(title: "Safer Play") {
                        ResourceLinkRow(
                            icon: "heart.text.square.fill",
                            title: "Responsible Gambling Council",
                            detail: "Canadian safer-gambling education and help resources.",
                            url: AppLinks.responsibleGamblingCouncil
                        )
                        ResourceLinkRow(
                            icon: "exclamationmark.triangle.fill",
                            title: "Important reminder",
                            detail: "Only visit venues where legal for your age and region. If gambling stops feeling recreational, pause and use local support resources.",
                            url: AppLinks.responsibleGamblingCouncil
                        )
                    }

                    SettingsSection(title: "Support") {
                        ResourceLinkRow(
                            icon: "envelope.fill",
                            title: "Support",
                            detail: "Contact support or find app information.",
                            url: AppLinks.support
                        )
                    }
                }
                .padding(24)
            }
            .navigationTitle("Settings")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

private struct SettingsSection<Content: View>: View {
    let title: String
    @ViewBuilder let content: Content

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)
                .foregroundStyle(.secondary)
                .textCase(.uppercase)

            VStack(spacing: 0) {
                content
            }
            .background(.secondary.opacity(0.08), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.secondary.opacity(0.12), lineWidth: 1)
            )
        }
    }
}

private struct ResourceLinkRow: View {
    let icon: String
    let title: String
    let detail: String
    let url: URL

    var body: some View {
        Link(destination: url) {
            HStack(alignment: .top, spacing: 14) {
                Image(systemName: icon)
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.mint)
                    .frame(width: 28, height: 28)

                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.headline)
                        .foregroundStyle(.primary)
                    Text(detail)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.leading)
                }

                Spacer(minLength: 8)

                Image(systemName: "arrow.up.right")
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }
}

private struct ActionButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: systemImage)
                    .font(.system(size: 16, weight: .bold))
                Text(title)
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .lineLimit(1)
                    .minimumScaleFactor(0.75)
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .frame(height: 52)
            .background(.white.opacity(0.12), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(.white.opacity(0.11), lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }
}

private struct VenueDetailsView: View {
    let venue: CasinoVenue
    let distance: String
    let isUsingDemo: Bool

    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Capsule()
                .fill(.secondary.opacity(0.22))
                .frame(width: 42, height: 5)
                .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 8) {
                Text(venue.name)
                    .font(.title.bold())
                Text(venue.displayLocation)
                    .font(.headline)
                    .foregroundStyle(.secondary)
            }

            Divider()

            DetailRow(icon: "point.topleft.down.curvedto.point.bottomright.up", title: "Distance", value: distance)
            DetailRow(icon: "mappin.and.ellipse", title: "Address", value: venue.address)
            DetailRow(icon: "tablecells.fill", title: "Venue rule", value: "Full casino with table games")
            DetailRow(icon: isUsingDemo ? "sparkles" : "location.fill", title: "Location mode", value: isUsingDemo ? "Demo location" : "Live location")

            VStack(spacing: 10) {
                Button {
                    openInAppleMaps(venue)
                } label: {
                    Label("Open in Apple Maps", systemImage: "map")
                        .font(.headline)
                        .foregroundStyle(.black)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(.mint, in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }

                Button {
                    openInGoogleMaps(venue)
                } label: {
                    Label("Open in Google Maps", systemImage: "map.fill")
                        .font(.headline)
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(Color(red: 0.10, green: 0.42, blue: 0.92), in: RoundedRectangle(cornerRadius: 8, style: .continuous))
                }
            }
            .padding(.top, 6)

            Spacer()
        }
        .padding(24)
    }

    private func openInAppleMaps(_ venue: CasinoVenue) {
        let latitude = venue.coordinate.latitude
        let longitude = venue.coordinate.longitude

        var components = URLComponents(string: "http://maps.apple.com/")
        components?.queryItems = [
            URLQueryItem(name: "ll", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "q", value: venue.name)
        ]
        openURL(components?.url)
    }

    private func openInGoogleMaps(_ venue: CasinoVenue) {
        let latitude = venue.coordinate.latitude
        let longitude = venue.coordinate.longitude

        var components = URLComponents(string: "https://www.google.com/maps/dir/")
        components?.queryItems = [
            URLQueryItem(name: "api", value: "1"),
            URLQueryItem(name: "destination", value: "\(latitude),\(longitude)"),
            URLQueryItem(name: "travelmode", value: "driving")
        ]
        openURL(components?.url)
    }

    private func openURL(_ url: URL?) {
        guard let url else { return }
        UIApplication.shared.open(url)
    }
}

private struct DetailRow: View {
    let icon: String
    let title: String
    let value: String

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(.mint)
                .frame(width: 24)

            VStack(alignment: .leading, spacing: 3) {
                Text(title)
                    .font(.caption.weight(.bold))
                    .foregroundStyle(.secondary)
                    .textCase(.uppercase)
                Text(value)
                    .font(.body.weight(.medium))
            }
        }
    }
}

private struct AppBackground: View {
    let correctPathProgress: Double

    var body: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.035, green: 0.045, blue: 0.05),
                    Color(red: 0.05, green: 0.12, blue: 0.10),
                    Color(red: 0.18, green: 0.12, blue: 0.05)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .ignoresSafeArea()

            LinearGradient(
                colors: [
                    Color(red: 0.03, green: 0.34, blue: 0.13),
                    Color(red: 0.00, green: 0.58, blue: 0.28),
                    Color(red: 0.47, green: 0.88, blue: 0.32)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
            .opacity(0.18 + correctPathProgress * 0.82)
            .blendMode(.plusLighter)
            .ignoresSafeArea()
            .opacity(correctPathProgress)
            .animation(.easeInOut(duration: 0.24), value: correctPathProgress)

            VStack {
                Rectangle()
                    .fill(.white.opacity(0.06))
                    .frame(height: 1)
                Spacer()
            }
            .ignoresSafeArea()
        }
    }
}
