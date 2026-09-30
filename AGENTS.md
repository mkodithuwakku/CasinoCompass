# Repository workflow

## Keep the portfolio README current

- Treat `README.md` as the current implementation walkthrough and interview guide.
- For every change to application code, venue data, assets, build configuration, or development tooling, review and update the README in the same change set before committing or pushing to GitHub.
- Describe observable behavior, architecture, setup, validation, and limitations from the actual code. Do not present requirements or future work as shipped features or invent personal motivation, metrics, or test results.
- For internal changes that do not affect the walkthrough, add a concise explanation of the change and its validation under `Maintenance notes`. Do not satisfy the check with whitespace or a date-only edit.
- Refresh screenshots when visible behavior changes. Keep real captures in `docs/screenshots/`; do not generate fake application screenshots.
- Preserve useful technical explanations and remove obsolete details. Keep the README focused rather than accumulating a full commit log.
- Run appropriate validation and the README freshness check before a requested push. Do not include unrelated local files or generated build products.

## Validation

- Simulator build: `xcodebuild -project CasinoCompass.xcodeproj -scheme CasinoCompass -configuration Debug -sdk iphonesimulator -derivedDataPath DerivedData build`.
- Documentation check after committing: `python3 tools/check_readme_update.py <base-commit> HEAD`.
- There is currently no application test target. Do not claim automated app test coverage or physical-device validation without running it.
- Keep application behavior unchanged for documentation-only tasks.
