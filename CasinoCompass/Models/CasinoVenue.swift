import CoreLocation
import Foundation

struct CasinoVenue: Identifiable, Hashable {
    let id: String
    let name: String
    let city: String
    let province: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    /// Live, dealer-operated table games. Electronic-only venues are false.
    let hasTableGames: Bool
    var hasElectronicTableGames: Bool = false

    var tableGamesDescription: String {
        if hasTableGames { return "Live table games listed • confirm availability with venue" }
        return hasElectronicTableGames
            ? "No live table games • electronic table games only"
            : "No live table games listed"
    }

    var tableGamesNotice: String? {
        hasTableGames ? nil : tableGamesDescription
    }

    var displayLocation: String {
        "\(city), \(province)"
    }

    func distance(from coordinate: CLLocationCoordinate2D) -> CLLocationDistance {
        CLLocation(latitude: coordinate.latitude, longitude: coordinate.longitude)
            .distance(from: CLLocation(latitude: self.coordinate.latitude, longitude: self.coordinate.longitude))
    }

    func bearing(from coordinate: CLLocationCoordinate2D) -> Double {
        CompassMath.bearing(from: coordinate, to: self.coordinate)
    }
}

extension CLLocationCoordinate2D: @retroactive Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(latitude)
        hasher.combine(longitude)
    }

    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}
