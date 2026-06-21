# CasinoCompass Software Requirements Document

## 1. Product Summary

CasinoCompass is a novelty mobile app that points users toward the nearest casino using a sleek, spatial-finder-style compass interface. The app is satirical in tone but should be engineered for real app store release, high availability, privacy-conscious location use, and a potentially large user base.

The core experience is simple: open the app, grant location permission, and see an elegant directional pointer guiding the user toward the nearest qualifying casino. The visual language should feel modern, premium, and playful, inspired by item-finding interfaces without copying any protected product design, trademarks, animations, or trade dress.

## 1.1 Current Product Decisions

- Working name: CasinoCompass until a final name is chosen.
- Initial launch market: all of Canada by public release.
- Initial platform and stack: iOS first using native Swift/SwiftUI. Android is deferred.
- Age gate: 18+ for MVP, with dynamic region-based age handling deferred.
- Venue scope: full casinos with table games only.
- Distance model: straight-line distance, not driving distance.
- Account model: no accounts for MVP or near-term releases.
- Tone: subtle and witty rather than loud or overtly comedic.
- Monetization: plan for ads, but preserve core functionality first.
- Social sharing: included in MVP as a shareable download card.

## 2. Goals

- Deliver a polished native iOS app suitable for public app store release, with Android considered after the first release.
- Provide accurate nearest-casino detection using location, heading, and reliable venue data.
- Create a fast, humorous, low-friction user experience with no required account.
- Scale data lookup, search, telemetry, and backend services for widespread usage.
- Respect user privacy by minimizing collection and avoiding persistent precise location storage by default.
- Include responsible-use, age-gating, and regional compliance guardrails appropriate for gambling-adjacent content.

## 3. Non-Goals

- The app will not process bets, wagers, deposits, loyalty account access, or gaming transactions.
- The app will not rank casinos by odds, promotions, bonuses, payouts, or gambling incentives.
- The app will not provide turn-by-turn navigation inside the app at launch.
- The app will not copy Apple AirTag, Find My, or any other proprietary UI exactly.
- The app will not target minors or encourage gambling behavior.
- The app will not require users to create accounts.
- The app will not include driving-distance calculation in MVP.

## 4. Target Users

- Adults who enjoy novelty, satire, and location-based utility apps.
- Travelers who want to know what casino is nearby in a lighthearted way.
- Social users sharing humorous screenshots or reactions.
- Users in regions where casino discovery apps are permitted.

## 5. Core User Experience

1. User opens the app.
2. App shows a short onboarding screen explaining location use, satire positioning, and age requirement.
3. User grants location permission.
4. App detects current location and device heading.
5. App finds the nearest casino from a verified venue dataset.
6. Main screen displays:
   - Large directional arrow or radial pointer.
   - Distance to nearest casino.
   - Casino name when the user enables venue-name display or opens details.
   - Optional city/region.
   - Confidence/loading state when heading or location is weak.
7. User can tap for venue details, map handoff, refresh, or "New Venue" to point toward the next closest qualifying casino.

## 6. App Personality and UX Principles

- Sleek and modern: premium glass, depth, motion, and a restrained color palette.
- Satirical but not tacky: witty copy, subtle humor, no exploitative gambling language.
- Immediate: the main directional experience should appear within seconds.
- Minimal: no clutter, no long lists on the primary screen.
- Respectful: include age and responsible-gambling messaging without making the app feel preachy.

## 7. Functional Requirements

### 7.1 Onboarding and Age Gate

- The app must show first-run onboarding before requesting precise location.
- The app must communicate that it is for adults only.
- For MVP, the app must require the user to confirm they are 18 or older.
- Dynamic region-based age requirements may be added after MVP.
- The app must explain that location is used to calculate the nearest casino and direction.
- The app must allow users to continue with approximate location where supported, with reduced accuracy messaging.

### 7.2 Location Permission

- The app must request foreground location permission only.
- The app must not request background location for MVP.
- The app must gracefully handle denied, restricted, approximate, or unavailable location.
- The app must provide a settings recovery path when permission is denied.

### 7.3 Heading and Direction

- The app must use device compass/heading APIs where available.
- The app must calculate bearing from the user's current coordinate to the selected casino.
- The app must rotate the primary pointer relative to device heading.
- The app must show calibration or low-confidence UI when heading accuracy is poor.
- The app must support fallback mode when compass is unavailable by showing map direction or relative bearing.

### 7.4 Nearest Casino Detection

- The app must query a casino venue dataset using the user's current coordinate.
- The app must return the nearest open/known full casino with table games by geodesic straight-line distance.
- The app must support regional data updates without requiring an app release.
- The app must exclude non-casino venues, slots-only venues, card rooms without a full casino offering, electronic-gaming-only venues, and other gambling-adjacent venues that do not meet the full-casino-with-table-games rule.
- The app should support configurable inclusion rules for tribal/First Nations casinos, racinos with full table games, and casino hotels.
- The app must maintain a ranked list of nearby qualifying casinos so the user can skip the current venue and point to the next closest venue.
- By default, "New Venue" should cycle through qualifying casinos within 50 km of the user's current location.

### 7.5 Main Compass Screen

- The app must display a high-contrast directional pointer.
- The app must display distance in miles/feet or kilometers/meters based on locale settings.
- The app must offer a control to show or hide the casino name on the main compass screen.
- Venue-name display should default to on for MVP because it makes the app easier to understand and improves the share flow.
- The app must include a "New Venue" control that advances the compass target to the next closest qualifying casino.
- The app must clearly indicate when the app is pointing to a non-nearest venue because the user selected "New Venue".
- The app must show loading, no-results, no-permission, and error states.
- The app must animate pointer movement smoothly without causing motion discomfort.
- The app must include a refresh/recenter control.

### 7.6 Venue Detail Screen

- The app must show venue name, distance, address if available, and data source timestamp.
- The app must provide a "Open in Maps" action using the native maps provider.
- The app should provide website and phone links where available.
- The app must avoid promotional gambling copy.

### 7.7 Map Handoff

- The app must deep link to Apple Maps, Google Maps, or system default maps.
- The app must pass destination coordinates where available.
- The app must not advertise casino incentives or gaming offers.

### 7.8 Share Feature

- The app must allow users to share a tasteful generated download card.
- Shared content must avoid exposing exact user location.
- Shared content should include app branding and humorous copy.
- Social sharing means the user can create a shareable image or card from the app, such as "CasinoCompass says I am 2.4 km from destiny," and send it through iMessage, Instagram, TikTok, or other native share-sheet destinations.
- Social sharing is required for MVP.
- The MVP share card must show the user's approximate distance to the selected casino and a download prompt such as "Download CasinoCompass to find the closest casino to you."
- The share card must be optimized for texting a friend through the native iOS share sheet.

### 7.9 Settings

- The app must include settings for:
  - Distance unit preference.
  - Location permission explanation.
  - Responsible gambling resources.
  - Privacy policy.
  - Terms of service.
  - Data source attribution.
- The app should include haptic feedback controls.

### 7.10 Compliance and Responsible Use

- The app must include clear "novelty/satire" positioning.
- The app must include responsible gambling resources appropriate to launch regions.
- The app must not target minors.
- The app must support geo-restriction or feature suppression where casino-location discovery is not permitted.
- The app must include app store metadata that avoids implying betting functionality.

### 7.11 Monetization and Ads

- The MVP must be usable without ads while core functionality is being validated.
- The app should be architected so ads can be added later without changing the compass flow.
- A future ad placement may appear only after the app has been open for at least 60 seconds.
- Ads must not block initial location permission, first compass result, safety resources, or settings.
- Ads must avoid gambling promotions, betting offers, and other content that could undermine app store review or responsible-use positioning.
- Ad SDK selection must be reviewed for privacy impact before integration.

## 8. User Stories and Acceptance Criteria

### Epic 1: First Run and Trust

#### Story 1.1: Adult user onboarding

As an adult user, I want to understand what the app does before granting location permission so that I can make an informed choice.

Acceptance criteria:
- Given the user opens the app for the first time, when onboarding appears, then it explains the nearest-casino compass concept.
- Given onboarding is visible, when the user reads the location explanation, then it states that foreground location is used for distance and direction.
- Given the user has not confirmed age eligibility, when they try to continue, then the app requires age confirmation.
- Given age confirmation is complete, when the user continues, then the app requests location permission.

#### Story 1.2: Denied location permission

As a privacy-conscious user, I want the app to handle denied location access gracefully so that I am not trapped.

Acceptance criteria:
- Given location permission is denied, when the app loads, then it shows a clear no-location state.
- Given the no-location state is shown, when the user taps settings, then the app opens the system settings page where supported.
- Given the user does not grant location, when they return to the app, then no precise-location-dependent casino result is shown.

### Epic 2: Nearest Casino Compass

#### Story 2.1: Find closest casino

As a user, I want the app to identify the closest casino so that the compass points to the most relevant destination.

Acceptance criteria:
- Given the app has location permission, when the location is available, then it queries the venue service with the user's coordinate.
- Given multiple casinos exist nearby, when results are returned, then the app selects the closest qualifying casino by distance.
- Given no casinos are found within the configured maximum radius, when results complete, then the app shows a no-results state.
- Given the selected casino changes after user movement, when the distance threshold is exceeded, then the app updates the selected casino.
- Given the user taps "New Venue", when another qualifying casino exists, then the app points to the next closest casino instead of the current one.
- Given the user taps "New Venue", when no additional qualifying casino exists within 50 km, then the app explains that no other nearby casino is available.
- Given the user has skipped one or more venues, when all qualifying casinos within 50 km have been cycled through, then the app returns to the closest venue or asks the user to refresh the list.

#### Story 2.2: Directional pointer

As a user, I want a visual pointer to rotate toward the casino so that the app feels like a spatial finding tool.

Acceptance criteria:
- Given the app has a selected casino and valid heading, when the user rotates the phone, then the pointer updates within 250 ms.
- Given heading accuracy is poor, when the compass signal is unreliable, then the app shows a calibration or low-confidence state.
- Given the casino is behind the user, when the device heading changes, then the pointer correctly indicates the relative direction.
- Given heading is unavailable, when the user opens the app, then a fallback direction state is shown instead of a broken pointer.

#### Story 2.3: Distance display

As a user, I want to see how far away the casino is so that the joke has useful context.

Acceptance criteria:
- Given a selected casino exists, when the main screen renders, then distance appears in locale-appropriate units.
- Given the user changes unit preference, when they return to the main screen, then distance reflects the selected unit.
- Given user location changes, when a new location update arrives, then distance refreshes without requiring app restart.

#### Story 2.4: Show or hide venue name

As a user, I want control over whether the venue name is visible on the compass screen so that the experience can feel mysterious or informative.

Acceptance criteria:
- Given the venue-name display setting is enabled, when a casino is selected, then the main compass screen shows the casino name.
- Given the venue-name display setting is disabled, when a casino is selected, then the main compass screen hides the casino name but still shows distance and direction.
- Given the user opens venue details, when the name is hidden on the main screen, then the detail screen still shows the casino name.

### Epic 3: Venue Details and Handoff

#### Story 3.1: View casino details

As a user, I want basic casino details so that I know what the compass is pointing at.

Acceptance criteria:
- Given a selected casino is shown, when the user taps the venue name or details affordance, then a venue detail screen opens.
- Given venue details are available, when the screen opens, then it shows name, address, distance, and source freshness.
- Given optional website or phone data exists, when the screen opens, then those actions are available.

#### Story 3.2: Open in maps

As a user, I want to open the casino in my maps app so that I can navigate outside CasinoCompass.

Acceptance criteria:
- Given destination coordinates exist, when the user taps "Open in Maps", then the system maps app opens with the casino destination.
- Given the maps handoff fails, when an error occurs, then the app shows a recoverable error message.
- Given the user returns from maps, when the app resumes, then the compass screen refreshes location and heading.

### Epic 4: Shareable Satire

#### Story 4.1: Share result

As a user, I want to share the absurdity of being pointed at a casino so that the app has social novelty value.

Acceptance criteria:
- Given a selected casino is visible, when the user taps share, then the app creates a shareable download card.
- Given the share card is generated, when shared, then it includes approximate distance but not exact user coordinates.
- Given the share card is generated, when text is included, then it includes a message similar to "Download CasinoCompass to find the closest casino to you."
- Given the native share sheet opens, when the user selects Messages, then the card and download prompt can be sent to a friend.
- Given sharing is unavailable, when the user taps share, then the app shows a graceful fallback.

### Epic 5: Compliance and Safety

#### Story 5.1: Responsible gambling resources

As a user, I want access to responsible gambling resources so that the app treats the subject matter responsibly.

Acceptance criteria:
- Given the user opens settings, when they tap responsible gambling, then resources for supported launch regions are shown.
- Given the user is in an unsupported region, when resources are not localized, then a general support resource is shown.
- Given app store reviewers inspect the app, when they check safety information, then privacy, age, and responsible-use links are accessible.

#### Story 5.2: Restricted region behavior

As the app operator, I want to disable or modify the experience in restricted regions so that the app can remain compliant.

Acceptance criteria:
- Given a region is configured as restricted, when the app detects the user is in that region, then casino discovery is suppressed or altered according to policy.
- Given region detection fails, when policy cannot be evaluated, then the app defaults to the safer configured behavior.
- Given policy configuration changes, when the app next fetches remote config, then behavior updates without requiring a new app release.

## 9. Data Requirements

### 9.1 Casino Venue Data

Required fields:
- Unique venue ID.
- Name.
- Latitude and longitude.
- Address.
- City, region/state, country.
- Venue category.
- Data source.
- Last verified timestamp.

Optional fields:
- Phone number.
- Website.
- Opening status.
- Parent property/resort.
- Supported maps place IDs.

### 9.2 Data Sources

Preferred implementation path:
- Start development with a curated static Canadian casino dataset because it is the easiest path to code and test the core compass experience.
- Before public release, confirm whether the static dataset is sufficient for all-Canada coverage and licensing, or replace/augment it with the easiest reliable provider-backed data source.

Potential sources:
- Licensed Places API provider.
- OpenStreetMap and curated validation.
- Internal verified venue database.
- Third-party location data provider.

Selection criteria:
- App store compatible terms.
- Commercial usage rights.
- Strong coverage in launch markets.
- Freshness and correction workflow.
- Cost profile at scale.

### 9.3 Data Quality Rules

- Deduplicate venues by coordinate, place ID, and normalized name.
- Flag questionable categories for manual review.
- Maintain an audit trail for data updates.
- Support user feedback for incorrect venue information.
- Prefer verified coordinates over geocoded address approximations.

## 10. Technical Requirements

### 10.1 Mobile Platform

Recommended approach:
- Build the MVP as a native iOS app using Swift and SwiftUI.
- Use native iOS APIs for heading, haptics, location precision, share sheet, and maps handoff.
- React Native or Flutter are no longer recommended for MVP, but may be reconsidered if Android becomes a near-term priority.
- Design system with reusable components and motion tokens.

Native requirements:
- iOS: Core Location, CLHeading, MapKit handoff.
- Android: deferred; future Android support would use Fused Location Provider, sensor manager, and Google Maps intent.

### 10.2 Backend Services

The backend should provide:
- Nearest venue lookup by coordinate.
- Remote configuration.
- Region policy configuration.
- Data source attribution metadata.
- Optional analytics ingestion proxy.
- Optional feedback submission endpoint.

Recommended architecture:
- API service with geospatial query support.
- PostGIS, managed geospatial database, or search service with geo-distance indexing.
- CDN or edge caching for static policy and configuration.
- Observability with logs, metrics, traces, and alerting.

### 10.3 Scalability Requirements

- Venue lookup p95 latency under 500 ms in launch regions.
- App cold-start to primary compass state under 3 seconds on modern devices with warm network.
- Backend must support horizontal scaling for read-heavy traffic.
- Venue data reads should be cacheable by coarse geohash where privacy rules allow.
- Remote config must tolerate backend degradation using cached last-known-safe config.
- App must remain useful during partial outage by showing cached venue result when appropriate.

### 10.4 Privacy Requirements

- Do not require account creation for MVP.
- Do not require account creation for planned core features.
- Do not store precise user location by default.
- Do not sell location data.
- Round or hash location for analytics where location analytics are necessary.
- Provide clear privacy policy and app store privacy nutrition labels.
- Allow users to clear local cached data.
- Avoid third-party SDKs that collect excessive location data.

### 10.5 Security Requirements

- All network traffic must use HTTPS.
- API keys must not be embedded in a recoverable way that allows abuse of privileged backend services.
- Rate limit location lookup endpoints.
- Validate all client-provided coordinates.
- Protect administrative data tools with strong authentication.
- Maintain dependency scanning and release signing.

## 11. Design Requirements

### 11.1 Visual Direction

- Main screen should feel like a premium spatial compass:
  - Full-screen radial field.
  - Large pointer or glow oriented toward destination.
  - Smooth depth, blur, haptics, and motion.
  - Minimal text hierarchy.
  - High contrast in light and dark modes.
- Avoid exact duplication of Apple AirTag/Find My visuals, copy, iconography, and animations.
- Use app-specific branding, typography, colors, and motion language.

### 11.2 Main Screen Elements

- Directional pointer.
- Distance readout.
- Casino name.
- Heading confidence indicator.
- Refresh/recenter icon button.
- Details icon button.
- Settings icon button.
- Optional share icon button.

### 11.3 Accessibility

- Support Dynamic Type or platform text scaling.
- Provide VoiceOver/TalkBack labels for pointer, distance, and venue.
- Do not rely on color alone for heading confidence.
- Respect reduced motion settings.
- Maintain sufficient contrast across light/dark themes.

## 12. Analytics and Success Metrics

### 12.1 Product Metrics

- First-run onboarding completion rate.
- Location permission grant rate.
- Successful nearest-casino lookup rate.
- Time to first compass result.
- Share action rate.
- Map handoff rate.
- Day 1 and Day 7 retention.

### 12.2 Reliability Metrics

- Venue lookup latency p50/p95/p99.
- API error rate.
- App crash-free sessions.
- Sensor unavailable rate.
- No-result rate by region.
- Data freshness by market.

### 12.3 Privacy Constraints for Analytics

- Avoid storing raw precise coordinates.
- Use coarse region, coarse geohash, or venue ID where possible.
- Do not combine location analytics with advertising identifiers.
- Document all collected events in the privacy policy.

## 13. App Store and Release Requirements

- App must include privacy policy and terms of service URLs.
- App metadata must clearly state that it is a novelty location utility and does not enable gambling.
- App must avoid using protected trademarks such as "AirTag" in public marketing except as legally reviewed comparative language.
- Age rating should reflect gambling-adjacent casino references.
- App screenshots should show the compass UI, settings, and responsible-use resources.
- App review notes should explain:
  - No betting or gambling transactions occur.
  - Location is foreground-only.
  - Casino data source and responsible-use handling.
  - Age-gate and region policy behavior.

## 14. Development Phase Roadmap

### Phase 0: Discovery and Validation

Duration: 1-2 weeks

Deliverables:
- Confirm all-Canada launch assumptions and legal/compliance requirements.
- Confirm Swift/SwiftUI project architecture.
- Choose venue data provider.
- Define brand name, visual identity, and satire tone.
- Produce clickable prototype of compass screen.
- Create app store policy checklist.

Exit criteria:
- Approved product scope.
- Approved data source.
- Approved design direction.
- Compliance risks documented.

### Phase 1: MVP Prototype

Duration: 3-5 weeks

Deliverables:
- Mobile app shell.
- First-run onboarding and age confirmation.
- Foreground location permission.
- Device heading integration.
- Local/static sample casino dataset.
- Main compass screen.
- Basic venue detail screen.
- Native maps handoff.

Exit criteria:
- User can open app and be pointed toward nearest sample casino.
- Pointer behaves correctly on physical devices.
- Permission denial and no-heading states are handled.

### Phase 2: Production Backend and Data

Duration: 4-6 weeks

Deliverables:
- Backend API for nearest casino lookup.
- Geospatial venue database.
- Data ingestion and deduplication pipeline.
- Remote config service.
- Region policy service.
- Observability baseline.

Exit criteria:
- API returns accurate nearest casino in launch markets.
- Venue data can be updated without app release.
- Backend meets initial latency and reliability targets.

### Phase 3: Polished Beta

Duration: 3-5 weeks

Deliverables:
- Production visual design pass.
- Motion, haptics, loading states, and accessibility.
- Share card generation.
- Settings screen.
- Responsible gambling resources.
- Analytics events.
- Crash reporting.
- TestFlight/internal testing.
- Closed Android beta only if Android support is included in the chosen stack.

Exit criteria:
- Crash-free beta sessions above target threshold.
- Core flow succeeds for representative testers.
- Accessibility and reduced-motion checks pass.
- Privacy policy and app store metadata draft complete.

### Phase 4: App Store Release

Duration: 2-4 weeks

Deliverables:
- App store listings.
- Privacy labels.
- Terms and privacy pages.
- App review notes.
- Production monitoring dashboards.
- Launch support plan.

Exit criteria:
- iOS build submitted.
- Android build submitted only if included in the launch scope.
- Review feedback resolved.
- Launch checklist approved.
- Rollout plan configured.

### Phase 5: Scale and Growth

Duration: ongoing

Deliverables:
- More launch regions.
- Improved venue correction workflow.
- Better offline/cache behavior.
- Localized responsible-use resources.
- Social sharing iteration and improvements.
- Performance tuning.
- Optional premium visual themes if compliant.

Exit criteria:
- App handles increased traffic within SLOs.
- Venue data freshness meets target.
- Support and correction processes are sustainable.

## 15. Testing Strategy

### 15.1 Unit Tests

- Bearing calculation.
- Distance calculation.
- Unit conversion.
- Venue selection logic.
- Remote config parsing.
- Region policy evaluation.

### 15.2 Integration Tests

- Location permission flows.
- Backend venue lookup.
- Maps handoff.
- Analytics event emission.
- Offline and degraded network behavior.

### 15.3 Device Testing

- iPhone models with varied compass hardware.
- Android devices across sensor quality tiers if Android support is in scope.
- Low-power mode.
- Reduced motion mode.
- Approximate location mode.
- Poor GPS environments.

### 15.4 Acceptance Testing

- User can complete first-run flow.
- User can see nearest casino direction.
- User can open destination in maps.
- User can understand permission denial recovery.
- App does not expose precise user location in share output.

## 16. Risks and Mitigations

| Risk | Impact | Mitigation |
| --- | --- | --- |
| App store rejects gambling-adjacent concept | High | Position as novelty location utility, include age gate, no betting, responsible-use resources, clear review notes |
| UI too closely resembles protected product design | High | Use original visual system and legal review before launch |
| Venue data licensing issue | High | Choose commercial-compatible data source and document attribution |
| Compass accuracy poor indoors | Medium | Show confidence states, calibration guidance, fallback bearing UI |
| Precise location privacy concern | High | Foreground-only location, no raw coordinate storage, transparent privacy policy |
| Region-specific gambling regulations | High | Remote region policy and conservative defaults |
| High API cost at scale | Medium | Cache coarse location lookups, optimize geospatial queries, monitor usage |
| Satire tone perceived as encouraging gambling | Medium | Keep copy restrained, avoid promotions, include support resources |
| Ad SDK introduces privacy or app review risk | Medium | Delay ads until after core validation, avoid gambling ads, review SDK privacy behavior |

## 17. Clarification Responses and Remaining Questions

Answered decisions:
- Use CasinoCompass as the working name until a final name is selected.
- Cover all of Canada by public release.
- Use 18+ age confirmation for MVP.
- Include only full casinos with table games.
- Use straight-line distance.
- Provide a venue-name display option and a "New Venue" control that points to the next closest qualifying casino within 50 km.
- Use subtle, witty satire.
- Do not require accounts.
- Plan for ads later, with a possible placement after 60 seconds of app use, but prioritize functionality first.
- Prioritize native iOS with Swift/SwiftUI. Android is deferred.
- Include social sharing in MVP.
- Use the easiest reliable data provider to implement, as long as licensing, Canada coverage, and table-game casino filtering are acceptable.
- Default venue-name display to on, with a user-facing hide option.
- Share cards should focus on distance and the download prompt; they should not include the casino name by default.
- Share cards should use a placeholder download link before release, then replace it with the live App Store download link once available.

Social sharing requirements:
- Social sharing means generating a shareable image or card from the current result and opening the native iOS share sheet so the user can text it to a friend or post it elsewhere.
- The share card should include the user's approximate distance to the selected casino and a message similar to "Download CasinoCompass to find the closest casino to you."
- Before App Store release, the share card should use a placeholder landing-page link.
- After App Store release, the placeholder should be replaced with the live App Store download link.
- The share card must not include exact user coordinates.

Venue-name display explanation:
- Default-on venue names make the app easier to understand, make the share card more legible, and reduce confusion when users tap "New Venue."
- The hide option still supports a more mysterious compass-only experience for users who prefer the joke to unfold without naming the destination immediately.

Legal/compliance note:
- The founder can perform the initial product review, but a public app store launch should strongly consider outside legal review because the app is gambling-adjacent, location-based, and may rely on licensed venue data.
- At minimum, legal/compliance review should cover app store positioning, age gate, Canada launch region rules, privacy policy, data licensing, responsible gambling resources, ad SDK policy, and trademark/trade-dress risk.

Remaining questions:
- None at this stage.

## 18. Initial MVP Definition

The MVP should include:
- iOS app shell.
- First-run onboarding.
- Age confirmation.
- Foreground location permission.
- Nearest-casino lookup from a curated or provider-backed Canadian dataset.
- Directional compass screen.
- Distance and optional venue name.
- "New Venue" control for cycling to the next closest qualifying casino.
- Shareable download card for texting friends.
- Low-confidence and no-permission states.
- Venue details.
- Open in maps.
- Settings with privacy, terms, and responsible-use resources.
- Basic analytics and crash reporting.

The MVP should exclude:
- Account creation.
- Betting, odds, promotions, or financial flows.
- Background location.
- Turn-by-turn navigation.
- Casino ranking or recommendation algorithms.
- Aggressive advertising or gambling-related monetization.
- Android release.
