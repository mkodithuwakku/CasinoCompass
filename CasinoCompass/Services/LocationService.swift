import Combine
import CoreLocation
import Foundation

@MainActor
final class LocationService: NSObject, ObservableObject {
    enum Mode { case demo, live }

    @Published private(set) var mode: Mode = .demo
    @Published private(set) var location: CLLocationCoordinate2D? = CasinoData.demoCoordinate
    @Published private(set) var locationUpdateID = 0
    @Published private(set) var heading: Double = 42
    @Published private(set) var hasUsableHeading = false
    @Published private(set) var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published private(set) var statusMessage = "Demo mode: downtown Vancouver."

    var isUsingDemoLocation: Bool { mode == .demo }
    var canPoint: Bool { isUsingDemoLocation || hasUsableHeading }

    private let manager: CLLocationManager
    private var demoTimer: Timer?
    private var hasStarted = false
    private var isActive = true
    private var liveSessionStartedAt: Date?
    private var movementAnchor: CLLocation?
    private let maximumCachedLocationAge: TimeInterval = 60
    private let meaningfulLocationChangeMeters: CLLocationDistance = 100

    init(manager: CLLocationManager = CLLocationManager()) {
        self.manager = manager
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 25
        authorizationStatus = manager.authorizationStatus
    }

    func startIfNeeded() {
        guard !hasStarted else { return }
        hasStarted = true
        refreshCurrentLocation()
    }

    func resume() {
        isActive = true
        guard hasStarted else { return }
        if isUsingDemoLocation {
            startDemoMotion()
        } else {
            startLiveUpdatesIfAuthorized()
        }
    }

    func suspend() {
        isActive = false
        stopSensors()
    }

    /// Only an explicit user action (or first launch) selects live mode.
    func refreshCurrentLocation() {
        stopSensors()
        mode = .live
        location = nil
        hasUsableHeading = false
        movementAnchor = nil
        startLiveUpdatesIfAuthorized()
    }

    func useDemoLocation() {
        mode = .demo
        stopSensors()
        movementAnchor = nil
        location = CasinoData.demoCoordinate
        locationUpdateID += 1
        hasUsableHeading = false
        statusMessage = "Demo mode: downtown Vancouver."
        if isActive { startDemoMotion() }
    }

    private func stopSensors() {
        liveSessionStartedAt = nil
        manager.stopUpdatingLocation()
        manager.stopUpdatingHeading()
        demoTimer?.invalidate()
        demoTimer = nil
    }

    private func startLiveUpdatesIfAuthorized() {
        guard mode == .live, isActive else { return }
        // Initial authorization notifications and scene activation can overlap.
        guard liveSessionStartedAt == nil || authorizationStatus != manager.authorizationStatus else { return }
        stopSensors()
        hasUsableHeading = false
        location = nil
        authorizationStatus = manager.authorizationStatus
        switch authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            liveSessionStartedAt = Date()
            statusMessage = "Finding your current location…"
            manager.startUpdatingLocation()
            if CLLocationManager.headingAvailable() {
                manager.headingFilter = 1
                manager.startUpdatingHeading()
            }
        case .notDetermined:
            statusMessage = "Allow location access, or select demo mode."
            manager.requestWhenInUseAuthorization()
        case .denied, .restricted:
            useDemoLocation()
        @unknown default:
            useDemoLocation()
        }
    }

    private func acceptsLiveEvent(timestamp: Date) -> Bool {
        guard mode == .live, isActive, let start = liveSessionStartedAt else { return false }
        return timestamp >= start && abs(timestamp.timeIntervalSinceNow) <= maximumCachedLocationAge
    }

    private func acceptLocation(_ fix: CLLocation) {
        location = fix.coordinate
        statusMessage = hasUsableHeading ? "Using live location." : "Live location • compass heading unavailable."
        if movementAnchor.map({ fix.distance(from: $0) >= meaningfulLocationChangeMeters }) ?? true {
            movementAnchor = fix
            locationUpdateID += 1
        }
    }

    private func startDemoMotion() {
        guard demoTimer == nil, isUsingDemoLocation, isActive else { return }
        demoTimer = Timer.scheduledTimer(withTimeInterval: 0.035, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self, self.isUsingDemoLocation, self.isActive else { return }
                self.heading = (self.heading + 0.22).truncatingRemainder(dividingBy: 360)
            }
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        Task { @MainActor in
            // Authorization changes must never override an explicit demo selection.
            guard self.mode == .live, self.hasStarted else {
                self.authorizationStatus = self.manager.authorizationStatus
                return
            }
            self.startLiveUpdatesIfAuthorized()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        Task { @MainActor in
            guard let fix = locations.last(where: {
                $0.horizontalAccuracy >= 0 && self.acceptsLiveEvent(timestamp: $0.timestamp)
            }) else { return }
            self.acceptLocation(fix)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let value = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
        let timestamp = newHeading.timestamp
        let accuracy = newHeading.headingAccuracy
        Task { @MainActor in
            guard self.acceptsLiveEvent(timestamp: timestamp), accuracy >= 0, value >= 0 else { return }
            self.heading = value
            self.hasUsableHeading = true
            if self.location != nil { self.statusMessage = "Using live location." }
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            guard self.mode == .live, self.isActive, self.liveSessionStartedAt != nil else { return }
            self.statusMessage = self.location == nil
                ? "Location unavailable. Try again or select demo mode."
                : "Location refresh failed. Showing last known position."
        }
    }
}
