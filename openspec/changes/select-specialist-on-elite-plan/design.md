# Design: Specialist Selection on Elite Plan

## Technical Approach

We will enforce a non-dismissible modal bottom sheet (`SpecialistSelectionBottomSheet`) immediately after a user successfully purchases or upgrades to the Elite plan in `MembershipScreen`.
This design uses clean MVVM layers:
- **Model**: `Specialist` (Freezed + JSON serialization).
- **Service**: `SpecialistService` (using `CachedHttp` for network requests).
- **Provider**: `SpecialistProvider` (manages specialists list and assignment states).
- **UI**: `SpecialistSelectionBottomSheet` (using `PopScope` and non-dismissible parameters).

The provider is instantiated locally using `ChangeNotifierProvider` to avoid polluting the global provider tree.

## Architecture Decisions

### Location of `SpecialistProvider` Registration

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Global inside `main.dart` | Simple, but pollutes the global scope with feature-specific state. | Rejected |
| Local via `ChangeNotifierProvider` | Requires proper wrapping context, but ensures clean lifecycle & automatic disposal when modal closes. | **Selected**: Provide `SpecialistProvider` directly to the `showModalBottomSheet` builder. |

### Block Sheet Dismissal (Pop Prevention)

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Rely only on `isDismissible: false` | Blocks tap-outside and swipe, but doesn't block Android hardware back button. | Rejected |
| Use `PopScope(canPop: false)` | Blocks back button, fully ensuring sheet cannot be dismissed until programmatic pop on success. | **Selected**: Combine `isDismissible: false`, `enableDrag: false` and `PopScope(canPop: false)`. |

## Data Flow

```
[MembershipScreen] ──(Elite Success)──> [SpecialistSelectionBottomSheet]
                                                       │
                                            (loadSpecialists via Auth token/discipline)
                                                       │
                                                       ▼
[Dashboard] <──(Pop Sheet & Screen) <── [SpecialistService] (POST /specialist/solicitar-seguimiento)
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `lib/models/specialist.dart` | Create | Freezed specialist model with JSON parsing. |
| `lib/services/specialist_service.dart` | Create | Handles `GET /specialist/especialistas` and `POST /specialist/solicitar-seguimiento/{id}`. |
| `lib/providers/specialist_provider.dart` | Create | Fetches specialists and filters by user's discipline; requests assignment. |
| `lib/widgets/specialist_selection_bottom_sheet.dart` | Create | Non-dismissible UI with `PopScope` blocking. |
| `lib/screens/membership/membership_screen.dart` | Modify | Trigger specialist sheet upon successful Elite purchase before popping screen. |
| `lib/l10n/app_localizations_en.dart` | Modify | Add English translation strings. |
| `lib/l10n/app_localizations_es.dart` | Modify | Add Spanish translation strings. |
| `lib/l10n/app_localizations.dart` | Modify | Declare new localized getter properties. |

## Interfaces / Contracts

### Specialist Model (`lib/models/specialist.dart`)
```dart
@freezed
class Specialist with _$Specialist {
  const factory Specialist({
    required String id,
    required String nombre,
    String? fotoUrl,
    required List<String> disciplinas,
  }) = _Specialist;

  factory Specialist.fromJson(Map<String, dynamic> json) => _$SpecialistFromJson({
    'id': json['id_especialista']?.toString() ?? json['id']?.toString() ?? '',
    'nombre': json['nombre'] ?? '',
    'fotoUrl': json['foto_url'] ?? json['fotoUrl'],
    'disciplinas': (json['disciplinas'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
  });
}
```

### SpecialistService
```dart
class SpecialistService {
  static const _base = 'https://apifitnflai.com/specialist';
  Future<List<Specialist>> getAvailableSpecialists(String token);
  Future<void> requestSpecialistFollowUp(String token, String specialistId);
}
```

### SpecialistProvider
```dart
class SpecialistProvider with ChangeNotifier {
  List<Specialist>? get specialists;
  bool get isLoadingSpecialists;
  String? get specialistError;
  bool get isRequestingFollowUp;
  String? get followUpError;

  Future<void> loadSpecialists(String token, String userDiscipline);
  Future<bool> requestFollowUp(String token, String specialistId);
}
```

## PopScope Integration Pattern

```dart
@override
Widget build(BuildContext context) {
  return PopScope(
    canPop: false, // Fully block hardware back button dismissal
    child: Container(
      // Non-dismissible sheet UI layout
    ),
  );
}
```

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit | Model Parsing & Filter | Verify `Specialist.fromJson` and `SpecialistProvider` local filtering of specialists by discipline. |
| Integration | Specialist API | Verify `SpecialistService` makes correct authenticated requests to `/specialist/*` using `CachedHttp`. |
| UI | Sheet Dismissal Block | Verify widget remains open when attempting to dismiss via back gesture / drag. |

## Migration / Rollout

Run code generation to build `specialist.freezed.dart` and `specialist.g.dart`:
```bash
dart run build_runner build --delete-conflicting-outputs
```

## Open Questions

- None.
