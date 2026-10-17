# Feature: Interactive Glossary

Implement an interactive glossary in Flutter that fetches terms from the `/admin/obtener-terminos-glosario` API, highlights them in texts within the app, and displays a localized popup (English/Spanish) with the term's description when clicked.

## Tasks

- [x] **Task 1 (Model)**: Create `lib/models/glossary_term.dart` using Freezed and JsonSerializable, and run `build_runner` to generate files.
- [x] **Task 2 (Service)**: Create `lib/services/glossary_service.dart` to fetch the terms from `https://apifitnflai.com/admin/obtener-terminos-glosario`.
- [x] **Task 3 (Provider)**: Create `lib/providers/glossary_provider.dart` to manage the state of glossary terms.
- [x] **Task 4 (Provider Registration)**: Register `GlossaryProvider` in `lib/main.dart` within the `MultiProvider`.
- [x] **Task 5 (UI Widget)**: Create `lib/widgets/interactive_glossary_text.dart` to parse text using regex, highlight terms, and show localized popup.
- [x] **Task 6 (Verification)**: Run `flutter analyze` and verify code compiles properly.

## Rationale
Using a sorted-by-length RegExp avoids greedy/subset matches on overlapping phrases (e.g. "Myofascial release" vs "Myofascial"). State management via Provider ensures the terms are fetched once and kept in memory.
