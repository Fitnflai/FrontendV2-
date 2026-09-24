# AGENTS.md

## Project Overview
Flutter frontend for the Fitnflai application.

## Development Commands
- **Run:** `flutter run`
- **Build (APK):** `flutter build apk`
- **Test:** `flutter test`
- **Analyze:** `flutter analyze`
- **Dependencies:** `flutter pub get`
- **Code Generation:** `dart run build_runner build --delete-conflicting-outputs` (Required for `freezed` and `json_serializable`).

## Architecture & Conventions
- **State Management:** `provider`.
- **Data/Models:** Uses `freezed` and `json_serializable`. **Must run build_runner after model changes.**
- **Authentication:** `google_sign_in`, `sign_in_with_apple`. Uses `url_launcher` for OAuth (e.g., Strava).
- **Location Services:** `google_maps_flutter`, `geolocator`.
- **Assets:** Located in `assets/images/`.

## Operational Gotchas
- **Build Runner:** If models are not updating, verify `build_runner` has been executed.
- **Environment:** Flutter SDK requirement `>=3.8.0 <4.0.0`.
- **Assets:** Ensure all new assets are registered in `pubspec.yaml` under `flutter.assets`.
