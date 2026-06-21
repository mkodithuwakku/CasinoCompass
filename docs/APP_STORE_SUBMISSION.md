# App Store Submission Notes

This document tracks the release-hardening state for CasinoCompass. Apple requirements can change, so verify App Store Connect fields before each submission.

## App Identity

- App name: CasinoCompass
- Bundle ID: `com.casinocompass.app`
- Version: `1.0`
- Build: `1`
- Category: Entertainment
- Minimum iOS version: 17.0
- Supported devices: iPhone

## Suggested Subtitle

A novelty compass for nearby casinos.

## Suggested Description

CasinoCompass is a playful location utility for adults. Open the app, allow location access, and the compass points toward a nearby qualifying full casino with table games.

The app is designed as a novelty directional experience. It does not provide betting, deposits, casino accounts, odds, promotions, bonuses, gambling transactions, or casino rankings.

Features:

- Find a nearby qualifying casino from the bundled Canadian venue dataset.
- See distance and direction with a live compass pointer.
- Cycle through other nearby qualifying venues when available.
- Open directions in Apple Maps or Google Maps.
- Hide or show the venue name.
- Share a simple distance card.
- Access privacy, support, and safer-play resources from settings.

Use CasinoCompass responsibly and follow all local laws.

## Keywords

casino, compass, maps, directions, travel, entertainment, Canada

## Review Notes

CasinoCompass is a novelty location utility for adults. It does not include betting, gambling transactions, deposits, accounts, casino promotions, odds, bonuses, or payment features.

The app uses Core Location while open to calculate distance and direction to venues in a bundled static dataset. Venue matching is performed on device. The app does not include analytics, advertising, tracking, accounts, or server sync.

Reviewer access:

- The app includes a built-in demo mode through the sparkle button in the top-right header.
- If location permission is denied or unavailable, the app falls back to a Vancouver demo coordinate.
- The Settings screen includes privacy, support, and responsible-gambling resource links.

## App Privacy Labels

Based on the current implementation:

- Data collected: None.
- Tracking: No.
- Location: Used on device while the app is open, not collected by the developer.
- Analytics: None.
- Advertising: None.
- Third-party SDKs: None.

Verify this again if analytics, crash reporting, ads, backend APIs, or any third-party SDKs are added.

## Required External Values

These must be configured outside the repo before submission:

- Publish the privacy policy at `https://casinocompass.app/privacy`.
- Publish support/contact information at `https://casinocompass.app/support`.
- Confirm the `com.casinocompass.app` bundle ID exists in the Apple Developer account.
- Create App Store Connect listing metadata.
- Upload screenshots for required iPhone sizes.
- Complete age rating questionnaire with gambling/casino references disclosed.
- Confirm app availability regions with legal advice if launching outside Canada.

## Screenshot Plan

Capture at least:

- Main compass screen with a venue result.
- Details screen with Apple Maps and Google Maps actions.
- Settings screen showing privacy and safer-play resources.
- Age gate screen.

Apple's screenshot requirements are maintained in App Store Connect Help:
https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/

## Release QA Checklist

Before submitting:

1. Build a Release archive in Xcode.
2. Install on a physical iPhone.
3. Verify first launch, age gate, and location permission copy.
4. Verify live location updates after moving between meaningful locations.
5. Verify heading rotation across the `0/360` boundary.
6. Verify correct-direction haptics and green background transition.
7. Verify `New Venue` cycles when multiple nearby venues exist.
8. Verify no-other-venue alert copy.
9. Verify Apple Maps and Google Maps handoff.
10. Verify settings links open.
11. Verify share card copy and image rendering.
12. Verify denied-location behavior and demo mode.
13. Confirm app icon appears correctly on device.
