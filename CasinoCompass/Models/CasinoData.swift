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
            name: "Great Canadian Casino Vancouver",
            city: "Coquitlam",
            province: "BC",
            address: "2080 United Boulevard",
            coordinate: CLLocationCoordinate2D(latitude: 49.2283, longitude: -122.8401),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "grand-villa-burnaby",
            name: "Grand Villa Casino Burnaby",
            city: "Burnaby",
            province: "BC",
            address: "4331 Dominion Street",
            coordinate: CLLocationCoordinate2D(latitude: 49.2564, longitude: -123.0070),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "starlight-new-westminster",
            name: "Starlight Casino New Westminster",
            city: "New Westminster",
            province: "BC",
            address: "350 Gifford Street",
            coordinate: CLLocationCoordinate2D(latitude: 49.1896, longitude: -122.9481),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "cascades-langley",
            name: "Cascades Casino Langley",
            city: "Langley",
            province: "BC",
            address: "20393 Fraser Highway",
            coordinate: CLLocationCoordinate2D(latitude: 49.1068, longitude: -122.6589),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "cascades-delta",
            name: "Cascades Casino Delta",
            city: "Delta",
            province: "BC",
            address: "6005 Highway 17A",
            coordinate: CLLocationCoordinate2D(latitude: 49.1066, longitude: -123.0657),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "elements-victoria",
            name: "Elements Casino Victoria",
            city: "View Royal",
            province: "BC",
            address: "1708 Island Highway",
            coordinate: CLLocationCoordinate2D(latitude: 48.4497, longitude: -123.4274),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "casino-of-the-rockies",
            name: "Casino of the Rockies",
            city: "Cranbrook",
            province: "BC",
            address: "7777 Mission Road",
            coordinate: CLLocationCoordinate2D(latitude: 49.5124, longitude: -115.7574),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "chances-kamloops",
            name: "Chances Casino Kamloops",
            city: "Kamloops",
            province: "BC",
            address: "1250 Halston Avenue",
            coordinate: CLLocationCoordinate2D(latitude: 50.6988, longitude: -120.3514),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "chances-kelowna",
            name: "Chances Casino Kelowna",
            city: "Kelowna",
            province: "BC",
            address: "1585 Springfield Road",
            coordinate: CLLocationCoordinate2D(latitude: 49.8762, longitude: -119.4637),
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
            id: "pure-casino-calgary",
            name: "Pure Casino Calgary",
            city: "Calgary",
            province: "AB",
            address: "1420 Meridian Road NE",
            coordinate: CLLocationCoordinate2D(latitude: 51.0660, longitude: -114.0005),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "cowboys-casino-calgary",
            name: "Cowboys Casino",
            city: "Calgary",
            province: "AB",
            address: "421 12 Avenue SE",
            coordinate: CLLocationCoordinate2D(latitude: 51.0403, longitude: -114.0556),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "elbow-river-casino",
            name: "Elbow River Casino",
            city: "Calgary",
            province: "AB",
            address: "218 18 Avenue SE",
            coordinate: CLLocationCoordinate2D(latitude: 51.0363, longitude: -114.0594),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "deerfoot-inn-casino",
            name: "Deerfoot Inn & Casino",
            city: "Calgary",
            province: "AB",
            address: "11500 35 Street SE",
            coordinate: CLLocationCoordinate2D(latitude: 50.9512, longitude: -113.9814),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "ace-casino-blackfoot",
            name: "ACE Casino Blackfoot",
            city: "Calgary",
            province: "AB",
            address: "4040 Blackfoot Trail SE",
            coordinate: CLLocationCoordinate2D(latitude: 51.0202, longitude: -114.0485),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "ace-casino-airport",
            name: "ACE Casino Airport",
            city: "Calgary",
            province: "AB",
            address: "40 Aero Crescent NE",
            coordinate: CLLocationCoordinate2D(latitude: 51.1438, longitude: -114.0206),
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
            id: "pure-casino-yellowhead",
            name: "Pure Casino Yellowhead",
            city: "Edmonton",
            province: "AB",
            address: "12464 153 Street NW",
            coordinate: CLLocationCoordinate2D(latitude: 53.5794, longitude: -113.5850),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "pure-casino-edmonton",
            name: "Pure Casino Edmonton",
            city: "Edmonton",
            province: "AB",
            address: "7055 Argyll Road NW",
            coordinate: CLLocationCoordinate2D(latitude: 53.5033, longitude: -113.4418),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "century-casino-edmonton",
            name: "Century Casino & Hotel Edmonton",
            city: "Edmonton",
            province: "AB",
            address: "13103 Fort Road NW",
            coordinate: CLLocationCoordinate2D(latitude: 53.5909, longitude: -113.4522),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "grand-villa-edmonton",
            name: "Grand Villa Casino Edmonton",
            city: "Edmonton",
            province: "AB",
            address: "10224 104 Avenue NW",
            coordinate: CLLocationCoordinate2D(latitude: 53.5469, longitude: -113.4956),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "starlight-edmonton",
            name: "Starlight Casino Edmonton",
            city: "Edmonton",
            province: "AB",
            address: "8882 170 Street NW",
            coordinate: CLLocationCoordinate2D(latitude: 53.5229, longitude: -113.6237),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "century-casino-st-albert",
            name: "Century Casino St. Albert",
            city: "St. Albert",
            province: "AB",
            address: "24 Boudreau Road",
            coordinate: CLLocationCoordinate2D(latitude: 53.6472, longitude: -113.6234),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "century-mile-leduc-county",
            name: "Century Mile Racetrack and Casino",
            city: "Leduc County",
            province: "AB",
            address: "4711 Airport Perimeter Road",
            coordinate: CLLocationCoordinate2D(latitude: 53.3097, longitude: -113.5847),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "camrose-resort-casino",
            name: "Camrose Resort Casino",
            city: "Camrose",
            province: "AB",
            address: "3201 48 Avenue",
            coordinate: CLLocationCoordinate2D(latitude: 53.0198, longitude: -112.8475),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "rivers-casino-fort-mcmurray",
            name: "Rivers Casino & Entertainment Centre",
            city: "Fort McMurray",
            province: "AB",
            address: "8528 Manning Avenue",
            coordinate: CLLocationCoordinate2D(latitude: 56.7253, longitude: -111.3830),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "great-northern-grande-prairie",
            name: "Great Northern Casino",
            city: "Grande Prairie",
            province: "AB",
            address: "10910 107 Avenue",
            coordinate: CLLocationCoordinate2D(latitude: 55.1784, longitude: -118.8121),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "stoney-nakoda-kananaskis",
            name: "Stoney Nakoda Resort & Casino",
            city: "Kananaskis",
            province: "AB",
            address: "888 Nakoda Way",
            coordinate: CLLocationCoordinate2D(latitude: 51.0979, longitude: -115.0124),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "pure-casino-lethbridge",
            name: "Pure Casino Lethbridge",
            city: "Lethbridge",
            province: "AB",
            address: "3756 2 Avenue S",
            coordinate: CLLocationCoordinate2D(latitude: 49.6942, longitude: -112.7890),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "copper-coulee-medicine-hat",
            name: "Copper Coulee Casino",
            city: "Medicine Hat",
            province: "AB",
            address: "1051 Ross Glen Drive SE",
            coordinate: CLLocationCoordinate2D(latitude: 50.0060, longitude: -110.6477),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "red-deer-resort-casino",
            name: "Red Deer Resort & Casino",
            city: "Red Deer",
            province: "AB",
            address: "3310 50 Avenue",
            coordinate: CLLocationCoordinate2D(latitude: 52.2433, longitude: -113.8146),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "cash-casino-red-deer",
            name: "Cash Casino Red Deer",
            city: "Red Deer",
            province: "AB",
            address: "6350 67 Street",
            coordinate: CLLocationCoordinate2D(latitude: 52.2864, longitude: -113.8314),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "casino-dene-cold-lake",
            name: "Casino Dene",
            city: "Cold Lake",
            province: "AB",
            address: "Highway 28",
            coordinate: CLLocationCoordinate2D(latitude: 54.4484, longitude: -110.1851),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "eagle-river-whitecourt",
            name: "Eagle River Casino & Travel Plaza",
            city: "Whitecourt",
            province: "AB",
            address: "Highway 43",
            coordinate: CLLocationCoordinate2D(latitude: 54.1404, longitude: -115.6644),
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
            id: "casino-moose-jaw",
            name: "Casino Moose Jaw",
            city: "Moose Jaw",
            province: "SK",
            address: "21 Fairford Street E",
            coordinate: CLLocationCoordinate2D(latitude: 50.3911, longitude: -105.5349),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "dakota-dunes-whitecap",
            name: "Dakota Dunes Casino",
            city: "Whitecap",
            province: "SK",
            address: "204 Dakota Dunes Way",
            coordinate: CLLocationCoordinate2D(latitude: 51.9840, longitude: -106.6881),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "gold-eagle-north-battleford",
            name: "Gold Eagle Casino",
            city: "North Battleford",
            province: "SK",
            address: "11902 Railway Avenue E",
            coordinate: CLLocationCoordinate2D(latitude: 52.7781, longitude: -108.2843),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "gold-horse-lloydminster",
            name: "Gold Horse Casino",
            city: "Lloydminster",
            province: "SK",
            address: "3910 41 Street",
            coordinate: CLLocationCoordinate2D(latitude: 53.2801, longitude: -110.0106),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "northern-lights-prince-albert",
            name: "Northern Lights Casino",
            city: "Prince Albert",
            province: "SK",
            address: "44 Marquis Road W",
            coordinate: CLLocationCoordinate2D(latitude: 53.1785, longitude: -105.7461),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "bear-claw-carlyle",
            name: "Bear Claw Casino & Hotel",
            city: "Carlyle",
            province: "SK",
            address: "White Bear First Nations",
            coordinate: CLLocationCoordinate2D(latitude: 49.6333, longitude: -102.2671),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "painted-hand-yorkton",
            name: "Painted Hand Casino",
            city: "Yorkton",
            province: "SK",
            address: "510 Broadway Street W",
            coordinate: CLLocationCoordinate2D(latitude: 51.2110, longitude: -102.4775),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "living-sky-swift-current",
            name: "Living Sky Casino",
            city: "Swift Current",
            province: "SK",
            address: "1401 North Service Road E",
            coordinate: CLLocationCoordinate2D(latitude: 50.2992, longitude: -107.7770),
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
            id: "mcphillips-station-winnipeg",
            name: "McPhillips Station Casino",
            city: "Winnipeg",
            province: "MB",
            address: "484 McPhillips Street",
            coordinate: CLLocationCoordinate2D(latitude: 49.9254, longitude: -97.1690),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "south-beach-scanterbury",
            name: "South Beach Casino",
            city: "Scanterbury",
            province: "MB",
            address: "1 Ocean Drive",
            coordinate: CLLocationCoordinate2D(latitude: 50.6227, longitude: -96.5060),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "aseneskak-the-pas",
            name: "Aseneskak Casino",
            city: "Opaskwayak",
            province: "MB",
            address: "PTH 10",
            coordinate: CLLocationCoordinate2D(latitude: 53.8270, longitude: -101.2570),
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
            id: "pickering-casino-resort",
            name: "Pickering Casino Resort",
            city: "Pickering",
            province: "ON",
            address: "888 Durham Live Avenue",
            coordinate: CLLocationCoordinate2D(latitude: 43.8435, longitude: -79.0702),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "casino-rama",
            name: "Casino Rama Resort",
            city: "Rama",
            province: "ON",
            address: "5899 Rama Road",
            coordinate: CLLocationCoordinate2D(latitude: 44.6481, longitude: -79.3493),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "elements-brantford",
            name: "Elements Casino Brantford",
            city: "Brantford",
            province: "ON",
            address: "40 Icomm Drive",
            coordinate: CLLocationCoordinate2D(latitude: 43.1391, longitude: -80.2682),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "shorelines-thousand-islands",
            name: "Shorelines Casino Thousand Islands",
            city: "Gananoque",
            province: "ON",
            address: "380 Highway 2",
            coordinate: CLLocationCoordinate2D(latitude: 44.3300, longitude: -76.1613),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "shorelines-peterborough",
            name: "Shorelines Casino Peterborough",
            city: "Peterborough",
            province: "ON",
            address: "1400 Crawford Drive",
            coordinate: CLLocationCoordinate2D(latitude: 44.2753, longitude: -78.3433),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "gateway-sault-ste-marie",
            name: "Gateway Casinos Sault Ste. Marie",
            city: "Sault Ste. Marie",
            province: "ON",
            address: "30 Bay Street",
            coordinate: CLLocationCoordinate2D(latitude: 46.5137, longitude: -84.3422),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "gateway-thunder-bay",
            name: "Gateway Casinos Thunder Bay",
            city: "Thunder Bay",
            province: "ON",
            address: "50 Cumberland Street S",
            coordinate: CLLocationCoordinate2D(latitude: 48.4340, longitude: -89.2190),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "gateway-sudbury",
            name: "Gateway Casinos Sudbury",
            city: "Sudbury",
            province: "ON",
            address: "400 Bonin Road",
            coordinate: CLLocationCoordinate2D(latitude: 46.4914, longitude: -80.9940),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "gateway-point-edward",
            name: "Gateway Casinos Point Edward",
            city: "Point Edward",
            province: "ON",
            address: "2000 Venetian Boulevard",
            coordinate: CLLocationCoordinate2D(latitude: 42.9950, longitude: -82.4091),
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
            id: "casino-charlevoix",
            name: "Casino de Charlevoix",
            city: "La Malbaie",
            province: "QC",
            address: "183 Rue Richelieu",
            coordinate: CLLocationCoordinate2D(latitude: 47.6230, longitude: -70.1436),
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
            id: "casino-mont-tremblant",
            name: "Casino de Mont-Tremblant",
            city: "Mont-Tremblant",
            province: "QC",
            address: "300 Chemin des Pléiades",
            coordinate: CLLocationCoordinate2D(latitude: 46.1947, longitude: -74.5894),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "playground-kahnawake",
            name: "Playground Poker Club",
            city: "Kahnawake",
            province: "QC",
            address: "1500 Route 138",
            coordinate: CLLocationCoordinate2D(latitude: 45.4076, longitude: -73.6827),
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
            id: "grey-rock-edmundston",
            name: "Grey Rock Casino",
            city: "Edmundston",
            province: "NB",
            address: "100 Chief Joanna Boulevard",
            coordinate: CLLocationCoordinate2D(latitude: 47.3966, longitude: -68.3240),
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
        ),
        CasinoVenue(
            id: "casino-nova-scotia-sydney",
            name: "Casino Nova Scotia Sydney",
            city: "Sydney",
            province: "NS",
            address: "525 George Street",
            coordinate: CLLocationCoordinate2D(latitude: 46.1366, longitude: -60.1953),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "red-shores-charlottetown",
            name: "Red Shores Racetrack & Casino",
            city: "Charlottetown",
            province: "PE",
            address: "58 Kensington Road",
            coordinate: CLLocationCoordinate2D(latitude: 46.2472, longitude: -63.1160),
            hasTableGames: true
        ),
        CasinoVenue(
            id: "diamond-tooth-gerties-dawson",
            name: "Diamond Tooth Gertie's Gambling Hall",
            city: "Dawson City",
            province: "YT",
            address: "1001 Fourth Avenue",
            coordinate: CLLocationCoordinate2D(latitude: 64.0601, longitude: -139.4332),
            hasTableGames: true
        )
    ]
}
