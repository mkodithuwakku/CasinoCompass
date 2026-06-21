import CoreLocation
import Foundation

@MainActor
final class LocationService: NSObject, ObservableObject {
    @Published var location: CLLocationCoordinate2D?
    @Published var locationUpdateID = 0
    @Published var heading: Double = 42
    @Published var isUsingDemoLocation = true
    @Published var authorizationStatus: CLAuthorizationStatus = .notDetermined
    @Published var statusMessage = "Demo mode is ready."

    private let manager = CLLocationManager()
    private var demoTimer: Timer?
    private var wantsLiveLocation = false
    private var lastAcceptedLocation: CLLocation?
    private let maximumCachedLocationAge: TimeInterval = 60
    private let meaningfulLocationChangeMeters: CLLocationDistance = 100

    override init() {
        super.init()
        manager.delegate = self
        manager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        manager.distanceFilter = 25
        authorizationStatus = manager.authorizationStatus
        startDemoMotion()
    }

    func requestPermission() {
        wantsLiveLocation = true
        manager.requestWhenInUseAuthorization()
        startUpdates()
    }

    func refreshCurrentLocation() {
        wantsLiveLocation = true

        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isUsingDemoLocation = false
            statusMessage = "Refreshing current location."
            startLiveUpdates()
            manager.requestLocation()
        case .notDetermined:
            manager.requestWhenInUseAuthorization()
            statusMessage = "Tap Locate to use live position."
        case .denied, .restricted:
            useDemoLocation()
        @unknown default:
            useDemoLocation()
        }
    }

    func startUpdates() {
        guard wantsLiveLocation else {
            useDemoLocation()
            return
        }

        switch manager.authorizationStatus {
        case .authorizedAlways, .authorizedWhenInUse:
            isUsingDemoLocation = false
            statusMessage = "Using live location."
            startLiveUpdates()
        case .notDetermined:
            statusMessage = "Tap Locate to use live position."
        case .denied, .restricted:
            useDemoLocation()
        @unknown default:
            useDemoLocation()
        }
    }

    func useDemoLocation() {
        wantsLiveLocation = false
        location = CasinoData.demoCoordinate
        locationUpdateID += 1
        isUsingDemoLocation = true
        statusMessage = "Demo mode: downtown Vancouver."
        startDemoMotion()
    }

    private func startLiveUpdates() {
        manager.startUpdatingLocation()
        if CLLocationManager.headingAvailable() {
            manager.headingFilter = 1
            manager.startUpdatingHeading()
        } else {
            statusMessage = "Live location on, demo heading active."
            startDemoMotion()
        }
    }

    private func acceptLocation(_ newLocation: CLLocation) {
        let movedMeaningfully = lastAcceptedLocation.map {
            newLocation.distance(from: $0) >= meaningfulLocationChangeMeters
        } ?? true

        location = newLocation.coordinate
        lastAcceptedLocation = newLocation
        isUsingDemoLocation = false
        statusMessage = "Using live location."

        if movedMeaningfully {
            locationUpdateID += 1
        }
    }

    private func isFreshLocation(_ location: CLLocation) -> Bool {
        location.horizontalAccuracy >= 0 &&
        abs(location.timestamp.timeIntervalSinceNow) <= maximumCachedLocationAge
    }

    private func startDemoMotion() {
        guard demoTimer == nil else { return }
        demoTimer = Timer.scheduledTimer(withTimeInterval: 0.035, repeats: true) { [weak self] _ in
            Task { @MainActor in
                guard let self else { return }
                guard self.isUsingDemoLocation || !CLLocationManager.headingAvailable() else { return }
                self.heading = (self.heading + 0.22).truncatingRemainder(dividingBy: 360)
            }
        }
    }
}

extension LocationService: CLLocationManagerDelegate {
    nonisolated func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        let status = manager.authorizationStatus
        Task { @MainActor in
            authorizationStatus = status
            startUpdates()
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let freshLocation = locations.last(where: { location in
            location.horizontalAccuracy >= 0 &&
            abs(location.timestamp.timeIntervalSinceNow) <= 60
        }) else {
            Task { @MainActor in
                statusMessage = "Refreshing current location."
            }
            return
        }

        Task { @MainActor in
            guard isFreshLocation(freshLocation) else {
                statusMessage = "Refreshing current location."
                return
            }
            acceptLocation(freshLocation)
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let value = newHeading.trueHeading >= 0 ? newHeading.trueHeading : newHeading.magneticHeading
        Task { @MainActor in
            heading = value
            isUsingDemoLocation = false
        }
    }

    nonisolated func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        Task { @MainActor in
            if location == nil {
                statusMessage = "Live location unavailable. Demo mode is on."
                useDemoLocation()
            } else {
                statusMessage = "Location refresh failed. Using last known location."
            }
        }
    }
}
