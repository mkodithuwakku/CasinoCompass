# CasinoCompass

CasinoCompass is a novelty iOS compass app that points adults toward the nearest qualifying casino. It uses live location, device heading, and a curated venue dataset to render a spatial finder-style pointer with distance, venue details, sharing, and directional feedback.

This README is intended to stay continuously updated with the app. When features, build settings, supported platforms, venue data, privacy behavior, or release steps change, update this document in the same change set.

## Current Status

- Platform: native iOS app built with SwiftUI.
- Minimum deployment target: iOS 17.0.
- Bundle identifier: `com.casinocompass.prototype`.
- Current data source: static in-app Canadian casino dataset.
- Current dataset coverage: Canadian full-casino/table-game venues reviewed from province/operator lists and casino directories.
- Location mode: live Core Location when authorized, with a Vancouver demo fallback.
- Heading mode: live device compass when available, with demo heading fallback.

## Product Behavior

The primary experience is a full-screen compass interface:

- Requests location while the app is open.
- Determines the user's current coordinate.
- Shows a witty header tagline chosen fresh each app launch.
- Filters the venue dataset to casinos with table games.
- Sorts venues by distance from the current coordinate.
- Selects the nearest qualifying venue by default.
- Calculates bearing from the user to the selected venue.
- Rotates the pointer relative to device heading.
- Displays distance and, when enabled, the venue name.
- Allows cycling to another nearby venue with `New Venue`.
- Shows an alert when `New Venue` is tapped but no additional qualifying casino exists within 50 km.
- Marks alternate selections so users can tell when the compass is no longer pointing at the nearest venue.
- Shows venue details and opens directions in Apple Maps or Google Maps.
- Generates a share card for the current result.

## Recent Interaction Fixes

The compass has several user-facing refinements:

- Smooth angle wrapping: crossing `359` degrees to `2` degrees now continues through the nearest visual path instead of spinning backward.
- Correct-direction feedback: entering the target direction window triggers success haptics and short impact pulses.
- Correct-path background: the screen fades toward a green path state as the user approaches the correct heading.
- Fresh location refresh: opening or foregrounding the app requests a fresh GPS fix and rejects stale Core Location results older than 60 seconds.
- Nearest venue reset: after a meaningful location change, the selected venue resets to the nearest result so the app does not keep pointing at a casino near the previous location.
- New Venue completion: the control cycles through nearby qualifying venues, labels alternate selections, and explains when there is no other nearby venue.
- Canada-wide table-game venue expansion: added a broader static list of full casino venues across provinces and territories where table-game casinos are known to operate.
- Dynamic cheeky taglines: the subtitle under `CasinoCompass` rotates through a curated set of witty lines on app launch.
- Lightweight Google Maps integration: venue details now offer Apple Maps and Google Maps actions. Google Maps uses a Universal Link, so no Google Maps SDK, API key, or billing setup is required.

## Project Structure

```text
CasinoCompass/
  CasinoCompassApp.swift          App entry point
  ContentView.swift               Main app flow, venue selection, background, haptics
  Models/
    CasinoData.swift              Static venue dataset and demo coordinate
    CasinoVenue.swift             Venue model and distance/bearing helpers
    CompassMath.swift             Bearing, relative angle, and distance formatting
  Services/
    LocationService.swift         Core Location, heading, demo motion, refresh handling
  Views/
    CompassView.swift             Compass rings, pointer, continuous rotation display
    ShareCardView.swift           Share image content
    ShareSheet.swift              UIKit share sheet bridge
  Assets.xcassets/                App icon and accent color assets
CasinoCompass.xcodeproj/          Xcode project
SOFTWARE_REQUIREMENTS.md          Product and engineering requirements
```

## Core Implementation Notes

### Location

`LocationService` owns Core Location authorization, live updates, heading updates, demo mode, and stale-location handling.

Important behavior:

- `refreshCurrentLocation()` starts live updates and calls `requestLocation()` for a fresh foreground fix.
- `didUpdateLocations` only accepts recent, valid coordinates.
- `locationUpdateID` increments when the accepted location changes meaningfully.
- `ContentView` observes `locationUpdateID` and resets the venue selection to the nearest casino.

### Compass Math

`CompassMath` handles:

- Great-circle bearing from current coordinate to venue coordinate.
- Relative angle between target bearing and device heading.
- Distance formatting in meters and kilometers.

The model-level angle remains normalized to `0...360`; `CompassView` keeps a separate continuous display angle so SwiftUI animation does not take the long route across the `0/360` boundary.

### Venue Selection

`ContentView` computes venues from the current coordinate:

- `sortedVenues`: all table-game venues sorted by distance.
- `candidateVenues`: nearby venues within 50 km, or the nearest venue if none are nearby.
- `selectedVenue`: currently selected candidate, defaulting to index `0`.

When the app receives a meaningful fresh location update, `selectedVenueIndex` is reset to `0` so the nearest casino is selected again.

When the user taps `New Venue`, `selectedVenueIndex` advances through the candidate list in distance order. If the current dataset has only one nearby candidate, the app keeps the nearest venue selected and shows a dataset-scoped no-other-nearby alert.

### Maps Integration

`VenueDetailsView` offers two directions actions:

- Apple Maps opens with `maps.apple.com` using the selected venue coordinate and name.
- Google Maps opens with a `google.com/maps/dir` Universal Link using the selected venue coordinate and driving mode.

The Google Maps path is intentionally lightweight. It does not embed Google Maps inside the app, does not use the Google Maps SDK, and does not require a Google Cloud API key. If iOS can route the Universal Link to the Google Maps app, it opens there; otherwise it opens in the browser.

## Build And Run

Open the project in Xcode:

```sh
open CasinoCompass.xcodeproj
```

Build from the command line:

```sh
xcodebuild -project CasinoCompass.xcodeproj -scheme CasinoCompass -configuration Debug -sdk iphonesimulator -derivedDataPath DerivedData build
```

Run on a simulator or a physical iPhone from Xcode. Live heading behavior is best validated on a physical device because Simulator heading support is limited.

## Validation Checklist

Before pushing user-facing changes:

1. Build the app with `xcodebuild`.
2. Launch the app in demo mode and confirm the compass renders.
3. Toggle live/demo location.
4. Confirm venue details open.
5. Confirm Apple Maps and Google Maps actions open directions for the selected venue.
6. Confirm `New Venue` cycles through multiple nearby candidates in distance order.
7. Confirm `New Venue` shows a no-other-nearby alert when only one qualifying casino is available within 50 km.
8. On a physical device, confirm heading rotation is smooth across `0/360`.
9. On a physical device, confirm correct-direction haptics fire once when entering the target window.
10. Move a meaningful distance or simulate a location change and confirm the nearest venue updates.

## Privacy

CasinoCompass uses location while the app is open to point toward the nearest qualifying casino. The current implementation does not include accounts, betting, server sync, analytics, advertising, or persistent location history.

The app falls back to a static demo coordinate when live location is unavailable or denied.

## Dataset Maintenance

The current dataset is static and should be reviewed before release. It intentionally targets full casinos with table games, not every slots-only gaming centre, bingo hall, VLT venue, or online casino.

When adding or editing venues:

- Keep coordinates precise enough for distance and bearing calculations.
- Confirm `hasTableGames` reflects the app's qualifying venue rule.
- Keep `id` values stable because they identify venues in code.
- Treat "no other nearby venue" as a statement about the current dataset, not an authoritative real-world casino directory.
- Prefer provincial regulator, lottery corporation, or operator pages when confirming venues; use general directories only as a cross-check.
- Update this README if the source, scope, or qualification rules change.

## Release Notes Template

Use this section as the running changelog format for future updates:

```text
Version:
Date:
Changes:
- 
Validation:
- 
Known Issues:
- 
```
