import CoreLocation
import Foundation

enum CompassMath {
    static func bearing(from start: CLLocationCoordinate2D, to end: CLLocationCoordinate2D) -> Double {
        let startLatitude = degreesToRadians(start.latitude)
        let startLongitude = degreesToRadians(start.longitude)
        let endLatitude = degreesToRadians(end.latitude)
        let endLongitude = degreesToRadians(end.longitude)
        let deltaLongitude = endLongitude - startLongitude

        let y = sin(deltaLongitude) * cos(endLatitude)
        let x = cos(startLatitude) * sin(endLatitude) - sin(startLatitude) * cos(endLatitude) * cos(deltaLongitude)
        return normalizedDegrees(radiansToDegrees(atan2(y, x)))
    }

    static func relativeAngle(targetBearing: Double, heading: Double) -> Double {
        normalizedDegrees(targetBearing - heading)
    }

    static func formattedDistance(_ meters: CLLocationDistance) -> String {
        if meters < 1000 {
            return "\(Int(meters.rounded())) m"
        }

        let kilometers = meters / 1000
        if kilometers < 10 {
            return String(format: "%.1f km", kilometers)
        }

        return "\(Int(kilometers.rounded())) km"
    }

    private static func degreesToRadians(_ degrees: Double) -> Double {
        degrees * .pi / 180
    }

    private static func radiansToDegrees(_ radians: Double) -> Double {
        radians * 180 / .pi
    }

    private static func normalizedDegrees(_ degrees: Double) -> Double {
        let value = degrees.truncatingRemainder(dividingBy: 360)
        return value < 0 ? value + 360 : value
    }
}
