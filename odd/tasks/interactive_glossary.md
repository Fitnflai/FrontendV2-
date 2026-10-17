# Feature: Interactive Glossary

Implement an interactive glossary in Flutter that fetches terms from the `/admin/obtener-terminos-glosario` API, highlights them in texts within the app, and displays a localized popup (English/Spanish) with the term's description when clicked.

## Tasks - Phase 1: Core Implementation

- [x] **Task 1 (Model)**: Create `lib/models/glossary_term.dart` using Freezed and JsonSerializable, and run `build_runner` to generate files.
- [x] **Task 2 (Service)**: Create `lib/services/glossary_service.dart` to fetch the terms from `https://apifitnflai.com/admin/obtener-terminos-glosario`.
- [x] **Task 3 (Provider)**: Create `lib/providers/glossary_provider.dart` to manage the state of glossary terms.
- [x] **Task 4 (Provider Registration)**: Register `GlossaryProvider` in `lib/main.dart` within the `MultiProvider`.
- [x] **Task 5 (UI Widget)**: Create `lib/widgets/interactive_glossary_text.dart` to parse text using regex, highlight terms, and show localized popup.
- [x] **Task 6 (Verification)**: Run `flutter analyze` and verify code compiles properly.

## Tasks - Phase 2: Screen Integration

- [x] **Task 7 (Home)**: Integrate `InteractiveGlossaryText` in `lib/screens/home/home_screen.dart` for dynamic daily text content.
- [x] **Task 8 (Plan)**: Integrate `InteractiveGlossaryText` in `lib/screens/plans/plan_screen.dart` for plan/workout descriptions.
- [x] **Task 9 (Nutrition)**: Integrate `InteractiveGlossaryText` in `lib/screens/nutrition/nutrition_screen.dart` for meal plans and comments.
- [x] **Task 10 (Progress)**: Integrate `InteractiveGlossaryText` in `lib/screens/progress/progress_screen.dart` for evaluation details.
- [x] **Task 11 (Workout detail/active)**: Integrate `InteractiveGlossaryText` in `lib/screens/workout/workout_detail_screen.dart` or active screens for exercise notes.
- [x] **Task 12 (Final verification)**: Run build & `flutter analyze` to verify clean builds.

## Rationale
Using a sorted-by-length RegExp avoids greedy/subset matches on overlapping phrases (e.g. "Myofascial release" vs "Myofascial"). State management via Provider ensures the terms are fetched once and kept in memory.
