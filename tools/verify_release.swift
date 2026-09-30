// Runs against the production sources in an iOS Simulator; no XCTest target or physical-device validation implied.
import CoreLocation
import Foundation
import SwiftUI
import UIKit

final class TestLocationManager: CLLocationManager {
    var testAuthorization: CLAuthorizationStatus = .authorizedWhenInUse
    var locationStops = 0
    var headingStops = 0
    override var authorizationStatus: CLAuthorizationStatus { testAuthorization }
    override func startUpdatingLocation() {}
    override func stopUpdatingLocation() { locationStops += 1 }
    override func startUpdatingHeading() {}
    override func stopUpdatingHeading() { headingStops += 1 }
    override func requestWhenInUseAuthorization() {}
}

final class TestHeading: CLHeading {
    let date: Date
    init(date: Date = Date()) { self.date = date; super.init() }
    required init?(coder: NSCoder) { fatalError("Not used in verification") }
    override var timestamp: Date { date }
    override var headingAccuracy: CLLocationDirection { 1 }
    override var trueHeading: CLLocationDirection { 90 }
    override var magneticHeading: CLLocationDirection { 89 }
}

@main struct ReleaseVerification {
    @MainActor static func drain() async {
        // Yield to main-actor tasks scheduled by CLLocationManagerDelegate callbacks.
        try? await Task.sleep(for: .milliseconds(30))
    }
    static func fix(_ latitude: Double = 53.5461, _ longitude: Double = -113.4938, date: Date = Date()) -> CLLocation {
        CLLocation(coordinate: .init(latitude: latitude, longitude: longitude), altitude: 0,
                   horizontalAccuracy: 5, verticalAccuracy: 5, timestamp: date)
    }
    @MainActor static func main() async {
        let manager = TestLocationManager()
        let service = LocationService(manager: manager)
        await drain()
        service.startIfNeeded()
        await drain()
        service.locationManager(manager, didUpdateLocations: [fix()])
        await drain()
        precondition(service.location?.latitude == 53.5461 && !service.isUsingDemoLocation)
        service.locationManager(manager, didUpdateHeading: TestHeading())
        await drain()
        precondition(service.hasUsableHeading)
        service.useDemoLocation()
        let stops = manager.locationStops
        service.locationManager(manager, didUpdateLocations: [fix(53.503, -113.442)])
        service.locationManager(manager, didUpdateHeading: TestHeading())
        service.locationManager(manager, didFailWithError: NSError(domain: "test", code: 1))
        await drain()
        precondition(service.isUsingDemoLocation && service.location == CasinoData.demoCoordinate)
        precondition(!service.hasUsableHeading && manager.headingStops > 0 && stops > 0)
        service.suspend(); service.resume()
        service.locationManagerDidChangeAuthorization(manager)
        await drain()
        precondition(service.isUsingDemoLocation && service.location == CasinoData.demoCoordinate)
        print("PASS demo rejects location/heading/error callbacks and survives resume/authorization changes")

        service.refreshCurrentLocation()
        precondition(service.location == nil && !service.canPoint)
        service.locationManager(manager, didUpdateLocations: [fix(date: Date().addingTimeInterval(-120))])
        await drain()
        precondition(service.location == nil)
        service.locationManager(manager, didUpdateLocations: [fix()])
        await drain()
        precondition(service.location?.latitude == 53.5461)
        service.suspend()
        service.locationManager(manager, didUpdateLocations: [fix(53.503, -113.442)])
        await drain()
        precondition(service.location?.latitude == 53.5461)
        service.resume()
        manager.testAuthorization = .denied
        service.locationManagerDidChangeAuthorization(manager)
        await drain()
        precondition(service.isUsingDemoLocation)
        service.suspend()
        print("PASS explicit live selection waits for fresh fix; background callbacks rejected; denied permission falls back")

        let points: [(Double, Double, String)] = [
            (53.5461,-113.4938,"grand-villa-edmonton"), (53.523,-113.624,"starlight-edmonton"),
            (53.503,-113.442,"pure-casino-edmonton"), (53.579,-113.585,"pure-casino-yellowhead"),
            (53.591,-113.452,"century-casino-edmonton"), (53.509,-113.699,"river-cree-enoch"),
            (53.647,-113.623,"century-casino-st-albert"), (53.3097,-113.5847,"century-mile-leduc-county")]
        for (lat, lon, expected) in points {
            let origin = CLLocationCoordinate2D(latitude: lat, longitude: lon)
            let nearest = CasinoData.venues.min { $0.distance(from: origin) < $1.distance(from: origin) }!
            precondition(nearest.id == expected)
        }
        let mile = CasinoData.venues.first { $0.id == "century-mile-leduc-county" }!
        precondition(!mile.hasTableGames && mile.hasElectronicTableGames)
        precondition(mile.tableGamesNotice == "No live table games • electronic table games only")
        precondition(Set(CasinoData.venues.map(\.id)).count == CasinoData.venues.count)
        precondition(CompassMath.relativeAngle(targetBearing: 2, heading: 359) == 3)
        print("PASS eight Edmonton-area selections, Century Mile disclosure, stable IDs and north wrapping")

        for demo in [false, true] {
            for nearest in [false, true] {
                let summary = ShareSummary(distance: "5.7 km", venueName: nil, isNearest: nearest,
                    isDemo: demo, tableGamesNotice: mile.tableGamesNotice, appLink: "https://example.com")
                precondition(summary.text.contains("No live table games"))
                precondition(summary.text.contains("Demo location") == demo)
                precondition(summary.destination.contains("nearest") == nearest)
                precondition(!summary.text.contains("Century Mile"))
                precondition(!summary.text.contains("closest"))
            }
        }
        let card = ShareCardView(summary: ShareSummary(distance: "5.7 km", venueName: "Century Mile Racetrack and Casino",
            isNearest: false, isDemo: true, tableGamesNotice: mile.tableGamesNotice, appLink: "https://mkodithuwakku.github.io/CasinoCompass/"))
        let renderer = ImageRenderer(content: card)
        renderer.proposedSize = ProposedViewSize(width: 1080, height: 1350)
        renderer.scale = 1
        precondition(renderer.uiImage?.size == CGSize(width: 1080, height: 1350))
        if let png = renderer.uiImage?.pngData() {
            try! png.write(to: URL(fileURLWithPath: "/tmp/casinocompass-share-verification.png"))
        }
        print("PASS nearest/alternate/demo share copy, hidden venue name, notice, and 1080 × 1350 image rendering")
    }
}
