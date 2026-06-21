import CoreLocation
import Foundation

enum CasinoData {
    static let demoCoordinate = CLLocationCoordinate2D(latitude: 49.2827, longitude: -123.1207)

    static let venues: [CasinoVenue] = [
        CasinoVenue(
            id: "river-rock-richmond",
            name: "River Rock Casino Resort",
            city: "Richmond",
            province: "BC",
            address: "8811 River Road",
            coordinate: CLLocationCoordinate2D(latitude: 49.1967, longitude: -123.1279),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "parq-vancouver",
            name: "Parq Vancouver",
            city: "Vancouver",
            province: "BC",
            address: "39 Smithe Street",
            coordinate: CLLocationCoordinate2D(latitude: 49.2753, longitude: -123.1131),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "hard-rock-coquitlam",
            name: "Hard Rock Casino Vancouver",
            city: "Coquitlam",
            province: "BC",
            address: "2080 United Boulevard",
            coordinate: CLLocationCoordinate2D(latitude: 49.2283, longitude: -122.8401),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "grey-eagle-calgary",
            name: "Grey Eagle Resort & Casino",
            city: "Calgary",
            province: "AB",
            address: "3777 Grey Eagle Drive",
            coordinate: CLLocationCoordinate2D(latitude: 51.0087, longitude: -114.1462),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "river-cree-enoch",
            name: "River Cree Resort & Casino",
            city: "Enoch",
            province: "AB",
            address: "300 East Lapotac Boulevard",
            coordinate: CLLocationCoordinate2D(latitude: 53.5092, longitude: -113.6996),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "casino-regina",
            name: "Casino Regina",
            city: "Regina",
            province: "SK",
            address: "1880 Saskatchewan Drive",
            coordinate: CLLocationCoordinate2D(latitude: 50.4542, longitude: -104.6065),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "club-regent-winnipeg",
            name: "Club Regent Casino",
            city: "Winnipeg",
            province: "MB",
            address: "1425 Regent Avenue West",
            coordinate: CLLocationCoordinate2D(latitude: 49.8955, longitude: -97.0575),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "great-canadian-toronto",
            name: "Great Canadian Casino Resort Toronto",
            city: "Toronto",
            province: "ON",
            address: "1133 Queens Plate Drive",
            coordinate: CLLocationCoordinate2D(latitude: 43.7147, longitude: -79.6047),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "fallsview-niagara",
            name: "Fallsview Casino Resort",
            city: "Niagara Falls",
            province: "ON",
            address: "6380 Fallsview Boulevard",
            coordinate: CLLocationCoordinate2D(latitude: 43.0829, longitude: -79.0811),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "casino-niagara",
            name: "Casino Niagara",
            city: "Niagara Falls",
            province: "ON",
            address: "5705 Falls Avenue",
            coordinate: CLLocationCoordinate2D(latitude: 43.0918, longitude: -79.0719),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "caesars-windsor",
            name: "Caesars Windsor",
            city: "Windsor",
            province: "ON",
            address: "377 Riverside Drive East",
            coordinate: CLLocationCoordinate2D(latitude: 42.3201, longitude: -83.0337),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "casino-montreal",
            name: "Casino de Montreal",
            city: "Montreal",
            province: "QC",
            address: "1 Avenue du Casino",
            coordinate: CLLocationCoordinate2D(latitude: 45.5067, longitude: -73.5256),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "lac-leamy-gatineau",
            name: "Casino du Lac-Leamy",
            city: "Gatineau",
            province: "QC",
            address: "1 Boulevard du Casino",
            coordinate: CLLocationCoordinate2D(latitude: 45.4450, longitude: -75.7258),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "casino-new-brunswick",
            name: "Casino New Brunswick",
            city: "Moncton",
            province: "NB",
            address: "21 Casino Drive",
            coordinate: CLLocationCoordinate2D(latitude: 46.1341, longitude: -64.8869),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "casino-nova-scotia-halifax",
            name: "Casino Nova Scotia",
            city: "Halifax",
            province: "NS",
            address: "1983 Upper Water Street",
            coordinate: CLLocationCoordinate2D(latitude: 44.6503, longitude: -63.5745),
            hasTableGames: true
        )
    ]
}
