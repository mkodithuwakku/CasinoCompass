# Edmonton verification — September 30, 2026

Initial audit: commit `861817c`. Follow-up implementation on September 30, 2026 resolves the five findings below. This document separates initial observations from follow-up verification; it is not a release certification.

## Follow-up fixes and validation

- Debug simulator build and unsigned generic-device Release build pass. UserDefaults privacy manifest is valid and present in both app bundles.
- `./tools/verify_release.sh <booted-simulator-UDID>` compiles actual production Swift sources into an executable running inside iOS Simulator. Checks pass for demo callback rejection (location, heading, errors), foreground/authorization preservation, fresh-location gating, background rejection, permission fallback, eight area selections including Century Mile, share text/name visibility, and 1080 × 1350 card rendering. There is still no XCTest/UI-test target.
- On iPhone 17 Pro Max/iOS 26.3, live downtown selection gives Grand Villa at 149 m; alternate selection gives Century Edmonton at 5.7 km. The share sheet now shows prepared text and usable share actions. The renderer produced an image inspected separately. Delivery to a receiving app on physical hardware remains untested.
- Switching to demo then injecting Argyll coordinates leaves Parq Vancouver selected at 992 m. Backgrounding into Settings and returning preserves demo. Explicit live selection shows a locating state until a new fix arrives. Missing real heading shows an unavailable indicator rather than fake live rotation.
- Century Mile remains selectable. At 53.3100, -113.5850 it is 39 m away and displays “No live table games • electronic table games only” on the compass and in details. The same notice is included in share content. Other venues retain their existing bundled classifications; this is not a new national data audit.
- The main screen scrolls when space is limited so notices and controls remain reachable. Details use a large sheet to accommodate game descriptions.
- Static privacy/support pages are supplied in `docs/privacy/` and `docs/support/`, served at `https://mkodithuwakku.github.io/CasinoCompass/`, with public GitHub Issues contact. The app's links use that exact case-sensitive base. Publication verification is recorded after deployment below.

Current captures: [Edmonton](screenshots/edmonton-compass.png), [details](screenshots/edmonton-details.png), [alternate](screenshots/edmonton-alternate.png), [Century Mile](screenshots/century-mile.png), [demo](screenshots/compass-demo.png), [share sheet](screenshots/share-alternate.png), and [Settings](screenshots/settings.png). The original pre-fix observations below are retained as regression context; current captures show the fixed build.

## Initial audit: build and calculation checks

- Debug iOS Simulator build: **passed**, using the repository's documented `xcodebuild` command.
- Release build for generic iOS hardware with `CODE_SIGNING_ALLOWED=NO`: **passed**. This is an unsigned compilation, not a signed archive, TestFlight upload, or physical-device test.
- A temporary Swift executable compiled the actual `CasinoData`, `CasinoVenue`, and `CompassMath` sources. Seven synthetic coordinates selected the expected nearby records; unique venue IDs, four cardinal bearings, and relative-angle wrapping across north passed.
- These coordinates test selection against bundled records. They do **not** independently establish entrance-level coordinate accuracy, completeness of local coverage, current opening hours, or real GPS/heading performance.

| Synthetic test location | Latitude, longitude | Expected nearest record | Distance returned |
| --- | --- | --- | --- |
| Downtown | 53.5461, -113.4938 | Grand Villa Casino Edmonton | 149 m |
| West Edmonton Mall | 53.5230, -113.6240 | Starlight Casino Edmonton | 23 m |
| Argyll | 53.5030, -113.4420 | Pure Casino Edmonton | 36 m |
| Yellowhead | 53.5790, -113.5850 | Pure Casino Yellowhead | 45 m |
| Fort Road | 53.5910, -113.4520 | Century Casino & Hotel Edmonton | 17 m |
| Enoch | 53.5090, -113.6990 | River Cree Resort & Casino | 46 m |
| St. Albert | 53.6470, -113.6230 | Century Casino St. Albert | 35 m |

From the downtown coordinate, the current nearby list is Grand Villa (149 m), Century Edmonton (5.7 km), Pure Edmonton (5.9 km), Pure Yellowhead (7.1 km), Starlight (9.0 km), Century St. Albert (14 km), River Cree (14 km), and Century Mile (27 km). Distances are straight-line, not driving distances. Century Mile remains included under the user-approved broader scope, with explicit game-type notices.

## Official venue evidence

Operator pages support the existence and table-game offerings of the seven main records. Some pages were available through search excerpts but failed direct retrieval; this is not a complete independent coordinate audit.

| Record | Evidence and limits |
| --- | --- |
| Pure Edmonton | [Operator contact page](https://www.purecasinoedmonton.com/contact/) confirms 7055 Argyll Rd NW and table-game hours. |
| Pure Yellowhead | [Operator contact page](https://www.purecasinoyellowhead.com/contact/) confirms 12464 153 St NW and table-game hours. |
| Century Edmonton | [Operator page](https://www.cnty.com/edmonton/) confirms 13103 Fort Road and table games. |
| Century St. Albert | [Operator page](https://www.cnty.com/stalbert/) confirms 24 Boudreau Road and live gaming tables. |
| River Cree | [Operator page](https://www.rivercreeresort.com/stay/) confirms 300 East Lapotac Blvd; [operator hours](https://www.rivercreeresort.com/promotions/) list table games. |
| Starlight Edmonton | [Getting here](https://edmonton.starlightcasino.ca/getting-here/) confirms unit 2710, 8882–170 Street and entrance 9; [table games](https://edmonton.starlightcasino.ca/gaming/table-games/) is listed by the operator. The app omits the unit/entrance information. |
| Grand Villa Edmonton | [Operator gaming page](https://grandvillacasinoedmonton.com/gaming/) advertises table games. Direct contact-page retrieval failed; the bundled street number was not independently verified. |
| Century Mile | [Operator casino page](https://www.cnty.com/centurymile/casino/) advertises slots, VLTs, and **electronic** table games. The initial app incorrectly flagged it as a live table-game casino. The corrected record explicitly identifies electronic-only tables while retaining the venue. |

## Initial audit: simulator observations

Device: iPhone 17 Pro Max, iOS 26.3. Location was injected through `simctl`; no personal location was used.

- First-launch age gate displayed and accepted in the test simulator.
- Downtown location selected Grand Villa and showed 149 m.
- Details displayed Edmonton, address, distance, location mode, and both map buttons.
- New Venue selected Century Edmonton, 5.7 km, with “Alternate venue 2 of 8”.
- Apple Maps opened a named pin at the bundled Grand Villa coordinate (53.5469, -113.4956). This demonstrates URL handoff, not a verified entrance or completed journey.
- Google Maps opened in Safari with the same destination coordinates. Google Maps native-app behavior and turn-by-turn navigation were not tested.
- Moving the injected coordinate to West Edmonton Mall reset selection to Starlight (23 m); Argyll selected Pure Edmonton (36 m).
- Demo selected Parq Vancouver (992 m), but a subsequent injected Argyll location **overrode demo mode** without tapping Use Live Location. This reproduces the callback-mode bug.
- Revoking location permission and relaunching returned to Vancouver demo successfully.
- Sharing an alternate opened a blank system sheet with no visible share targets/card in this simulator run. End-to-end sharing did **not** pass; no content was sent.
- Settings displayed privacy, support, and safer-play entries. External privacy/support HTTPS checks failed as described below.

The [main](screenshots/edmonton-compass.png), [details](screenshots/edmonton-details.png), and [alternate](screenshots/edmonton-alternate.png) captures have since been refreshed for the fixed build. These raw PNG captures contain an alpha channel; export opaque images or capture JPEGs for App Store upload.

## Initial findings and their resolutions

1. **Privacy manifest:** fixed by adding `CasinoCompass/PrivacyInfo.xcprivacy` and target resource membership; required-reason declaration `CA92.1` covers the local preferences.
2. **Public pages:** replaced the failing custom-domain links with GitHub Pages routes and provided public support/privacy content. No paid custom domain is required.
3. **Venue scope:** user explicitly chose to keep Century Mile. Selection includes all bundled casinos; known no-live-table venues display notices. Century Mile is marked live tables false / electronic tables true with an operator source/date.
4. **Location lifecycle:** explicit mode, sensor stop/start, callback guards, session timestamps, and mode-preserving foreground handling fix the reproduced demo override. The movement reset now accumulates from an anchor.
5. **Sharing:** a single identifiable prepared payload replaces independent items/presentation state. The sheet is populated in simulator checks; copy identifies alternate/demo selections and retains table-game notices even with names hidden. A text fallback remains when rendering fails.
6. **Copy:** removed the favorable-odds tagline and updated venue-scope language. Age gate, data disclaimers, and safer-play resources remain.
7. **Still outstanding:** signed archive/upload, TestFlight, physical GPS/heading/haptics, end-to-end sharing to a receiving app on hardware, current venue entrance verification, and broader accessibility checks. No App Store publication is claimed.

Follow [the submission guide](APP_STORE_SUBMISSION.md) for the remaining account and device steps.
