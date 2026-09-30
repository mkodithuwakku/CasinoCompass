# App Store Submission Notes

This document is a practical submission guide for CasinoCompass, checked against Apple's documentation on September 30, 2026. Apple requirements can change; verify the linked requirements at upload time.

**Current status: the five audited issues have been addressed in code/data and the GitHub Pages website. Physical-device and signed TestFlight validation are still required before submission.** See [Edmonton verification](EDMONTON_QA.md) for passing checks, completed fixes, and remaining limits. No account setup, signing validation, upload, or submission has been performed.

## Step-by-step release path

### 1. Verify the release candidate

The location service now preserves demo mode through callbacks and foreground transitions; sharing uses an item-driven payload and accurate nearest/alternate/demo copy; the UserDefaults privacy manifest is bundled; and Century Mile remains listed with explicit electronic-only notices, as requested. The public [privacy](https://mkodithuwakku.github.io/CasinoCompass/privacy/) and [support](https://mkodithuwakku.github.io/CasinoCompass/support/) pages use GitHub Pages, with public GitHub Issues for support.

Run the simulator build and `./tools/verify_release.sh <booted-simulator-UDID>`, then the device QA below. Independently verify venue entrance coordinates/current offerings before making precise navigation claims. The standalone regression executable is not a physical-device or XCTest/UI-test run.

`CasinoCompass/PrivacyInfo.xcprivacy` declares `NSPrivacyAccessedAPICategoryUserDefaults` with `CA92.1` for the app's own preferences, no collected data types, and no tracking. It is included in Copy Bundle Resources and was verified in Debug and unsigned Release bundles. Reassess declarations if data practices change. [Apple required-reason documentation](https://developer.apple.com/documentation/bundleresources/app-privacy-configuration/nsprivacyaccessedapitypes/nsprivacyaccessedapitypereasons?language=objc).

### 2. Enroll in the Apple Developer Program

Go to [Apple enrollment](https://developer.apple.com/programs/enroll/) and enroll with your Apple Account (two-factor authentication required). Membership is US$99 per year, or the local price shown during enrollment. A free Xcode Personal Team does not provide App Store distribution.

Individual enrollment displays your legal name as seller. Organization enrollment uses the legal entity's name and generally requires a D-U-N-S number. Complete identity verification, agreements, and payment yourself. If already enrolled, use the existing account.

### 3. Set up signing in Xcode

1. Open `CasinoCompass.xcodeproj`.
2. Xcode → Settings → Accounts: add your enrolled Apple Account.
3. Select the CasinoCompass project, then its app target → Signing & Capabilities.
4. Enable Automatically manage signing and choose your paid developer team. The committed team ID is `L4U54A86F5`; use it only if it is your intended team.
5. Confirm the bundle identifier. The current value is `com.casinocompass.app`; it must be available and registered to your team. If unavailable, change it consistently before creating the store listing.
6. Under General, confirm version `1.0` and build `1`. Increment the build for subsequent uploads. Keep iPhone support and the iOS 17 minimum unless intentionally changing support.
7. Use a stable Xcode version accepted by Apple at upload time; check [current SDK submission requirements](https://developer.apple.com/app-store/submitting/). This audit used Xcode 26.3/iOS 26.3; passing locally does not establish upload eligibility.

### 4. Test on a physical iPhone

Connect and trust your iPhone, enable Developer Mode if prompted, select it in Xcode, and Run. Test downtown Edmonton, west Edmonton, and a southeast location or use Xcode location simulation for selection checks. Real outdoor testing is still needed for GPS, compass orientation, accuracy, haptics, and north crossing. Do not describe simulated location tests as physical navigation validation.

Also check denied permission, Settings permission changes, demo/live switching, background/foreground return, every map/share action, and small-screen/larger-text layouts. Resolve failures before upload.

### 5. Create the App Store Connect record

At [App Store Connect](https://appstoreconnect.apple.com/), open Apps → + → New App. Choose iOS, name CasinoCompass (subject to availability), English, the exact registered bundle ID, and a unique internal SKU such as `casinocompass-ios`. Choose the intended user access. The SKU is internal; it is not the bundle ID. [Apple instructions](https://developer.apple.com/help/app-store-connect/create-an-app-record/add-a-new-app/).

### 6. Archive and upload

In Xcode choose the CasinoCompass scheme and **Any iOS Device (arm64)** or the equivalent generic iOS device destination, not a simulator. Choose Product → Archive. In Window → Organizer → Archives, select the archive, validate it if offered, then Distribute App → App Store Connect → Upload (some versions label this App Store Connect distribution). Use automatic signing and resolve validation errors. [Apple upload instructions](https://help.apple.com/xcode/mac/current/en.lproj/dev442d7f2ca.html).

Wait for processing in App Store Connect. Address any missing-compliance prompts or upload emails. A local unsigned Release build is not a substitute for this signed archive and upload.

### 7. Install through TestFlight

In the app's TestFlight tab, select the processed build, complete test information/export-compliance questions, and add an eligible internal tester. Install Apple's TestFlight app on the iPhone and test the distributed build. External testers may require Beta App Review. See [TestFlight overview](https://developer.apple.com/help/app-store-connect/test-a-beta-version/testflight-overview/).

### 8. Complete the product page and declarations

Use the draft metadata below, adjusting it to the final implemented behavior. Enter the description, subtitle (maximum 30 characters), keywords, copyright, category, support URL, privacy-policy URL, and review contact details.

Upload real screenshots of the final build. The iPhone 17 Pro Max captures in this repository are 1320 × 2868, a supported 6.9-inch screenshot size. They currently document QA, contain an alpha channel, and should be recaptured after fixes as opaque PNGs or JPEGs before upload. Apple's [screenshot specifications](https://developer.apple.com/help/app-store-connect/reference/app-information/screenshot-specifications/) allow one to ten screenshots and prohibit alpha/transparency. The project is iPhone-only; follow the slots actually required by App Store Connect.

Complete App Privacy based on the final binary. With the present local-only implementation and no analytics, accounts, ads, or backend, “Data Not Collected” appears appropriate; on-device use is distinct from developer collection. Reassess after any integration changes. [Apple privacy-label definitions](https://developer.apple.com/app-store/app-privacy-details/).

Complete the age-rating questionnaire truthfully, including casino/mature themes and linked content. The app contains no playable real-money or simulated wagering; do not mislabel it as a casino game merely because it lists casino locations. Review Apple's generated rating and use an appropriate higher-age override for the adult-only positioning if available. The in-app age acknowledgement does not set the store age rating. [Apple definitions](https://developer.apple.com/help/app-store-connect/reference/app-information/age-ratings-values-and-definitions/).

Answer export-compliance questions from the final app's actual encryption use. Current source has no custom cryptography; system HTTPS links alone do not establish that custom encryption documentation is needed. Follow Apple's [export-compliance flow](https://developer.apple.com/help/app-store-connect/manage-app-information/overview-of-export-compliance/) rather than guessing declarations.

### 9. Choose price, availability, and review access

Set your intended price (Free is the simplest initial option) and countries/regions. Canada is a sensible initial market for the bundled Canadian dataset; storefront availability is not in-app geofencing. Consider disabling availability on Apple-silicon Mac and Apple Vision Pro until tested because this app depends on phone location and heading.

Attach the processed build to version 1.0, provide review contact details, and explain the demo path and on-device venue matching using the notes below. No sign-in credentials are required. Apple will evaluate functionality and casino-related positioning; a location utility is not automatically a real-money gambling app, and approval is not guaranteed. See [review guidelines, including 4.2 and 5.3](https://developer.apple.com/app-store/review/guidelines/).

### 10. Submit, then release after approval

Choose manual release for launch control. Select **Add for Review**, check the submission, then **Submit for Review**. Respond to questions in App Store Connect. If a binary fix is needed, increment the build number, upload, and select the new build. After approval, use **Release This Version** if you selected manual release, then verify the public listing and a store installation. [Apple submission instructions](https://developer.apple.com/help/app-store-connect/manage-submissions-to-app-review/submit-an-app).

Before any requested GitHub push, update README with shipped behavior, commit only the intended files, and run `python3 tools/check_readme_update.py <base-commit> HEAD` as required by this repository.

## App Identity

- App name: CasinoCompass
- Bundle ID: `com.casinocompass.app`
- Version: `1.0`
- Build: `1`
- Category: Entertainment
- Minimum iOS version: 17.0
- Supported devices: iPhone

## Suggested Subtitle

Find nearby Canadian casinos

## Suggested Description

CasinoCompass is a playful location utility for adults. Open the app, allow location access, and the compass points toward a nearby listed casino.

The app includes casinos with different game offerings. Venues without listed live table games are labelled explicitly; Century Mile is marked as electronic-table-only. Confirm games and hours with the venue before travelling.

The app is designed as a novelty directional experience. It does not provide betting, deposits, casino accounts, odds, promotions, bonuses, gambling transactions, or casino rankings.

Features:

- Find a nearby listed casino from the bundled Canadian venue dataset.
- See distance and direction with a live compass pointer.
- Cycle through other nearby listed venues when available.
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

- Accept the age notice, then use the sparkle button in the top-right header (or Use Vancouver Demo while locating) to select the fixed Vancouver demo. The location-arrow button explicitly returns to live mode. Demo remains selected through foreground/background transitions within the session.
- Denied/restricted permission falls back to Vancouver demo. A live-fix failure shows an error/retry option or labels the last known position; the user can explicitly choose demo. Live mode does not show a simulated compass heading.
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

## Remaining Account and Submission Setup

These must be configured outside the repo before submission:

- Verify the published privacy policy at `https://mkodithuwakku.github.io/CasinoCompass/privacy/`.
- Verify support/contact information at `https://mkodithuwakku.github.io/CasinoCompass/support/` (public GitHub Issues).
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
