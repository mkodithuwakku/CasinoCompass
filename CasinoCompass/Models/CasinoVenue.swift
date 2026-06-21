import CoreLocation
import Foundation

struct CasinoVenue: Identifiable, Hashable {
    let id: String
    let name: String
    let city: String
    let province: String
    let address: String
    let coordinate: CLLocationCoordinate2D
    let hasTableGames: Bool

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
