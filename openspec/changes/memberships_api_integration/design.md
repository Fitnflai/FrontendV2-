# Design: Memberships API Integration

## Technical Approach

We will integrate the backend `/payments` and `/users/me` subscription features into the existing MVVM layered architecture.
This includes expanding the `Usuario` Freezed model, creating a new `PaymentsService` using `CachedHttp` for network calls, adding state management in `ProfileProvider`, and wiring the "Start Free Trial" button in `OnboardingFeedbackScreen` with robust loading/error handling.

## Architecture Decisions

### Subscription Data Synchronization

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Expose parsed `Usuario` from `ProfileProvider` | Separates user data source into two providers (`AuthProvider` and `ProfileProvider`). | **Selected**: Add a parsed `Usuario? usuario` field inside `ProfileProvider`. When `loadAll(token, force: true)` fetches the latest profile map, it maps it directly to a local `Usuario` instance. |
| Pull profile changes dynamically through custom events | Highly decoupled, but introduces complex event-stream management and boilerplate. | Rejected |

### Cache Invalidation

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Use automatic GET cache timeout of 1 minute | User might see stale "Not Subscribed" screen for up to 1 minute after subscribing. | Rejected |
| Proactive cache invalidation on mutations | POST requests in `CachedHttp` automatically call `clearCache()`, guaranteeing fresh data on the subsequent `loadAll` call. | **Selected**: Use `CachedHttp.post` for payments endpoints. This invalidates the cached `/users/me` and `/users/usuarios/mi-plan-activo` responses immediately. |

## Data Flow

```
[OnboardingFeedbackScreen] ──(Taps Start Free Trial)──> [ProfileProvider]
                                                               │
                                                       (Calls startFreeTrial)
                                                               │
                                                               ▼
[HomeScreen] <──(Navigates on success) <── [ProfileProvider] <── [PaymentsService] (POST /payments/start-free-trial)
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `lib/models/usuario.dart` | Modify | Add `nombre_plan_activo`, `fecha_fin_suscripcion`, `estado_suscripcion`, and `tiene_plan_activo` fields. Update `fromJson` mapper. |
| `lib/services/payments_service.dart` | Create | Implement `PaymentsService` to make authenticated HTTP calls to `/payments/*` using `CachedHttp`. |
| `lib/providers/profile_provider.dart` | Modify | Add subscription states (`_planes`, `_isLoadingSubscription`, `_subscriptionError`) and handle payments interactions + `loadAll(force: true)` refreshes. |
| `lib/screens/onboarding/onboarding_feedback_screen.dart` | Modify | Wrap the "Start Free Trial" button in `Consumer<ProfileProvider>`, display loading indicator as a `leading` widget, and handle async navigation/errors. |

## Interfaces / Contracts

### Usuario Model Additions (in `lib/models/usuario.dart`)
```dart
String? nombre_plan_activo,
String? fecha_fin_suscripcion,
String? estado_suscripcion,
@Default(false) bool tiene_plan_activo,
```

### Payments Service Class Interface
```dart
class PaymentsService {
  static const _base = 'https://apifitnflai.com';
  
  Future<List<Map<String, dynamic>>> getPlanes(String token) async;
  Future<Map<String, dynamic>> simulatePurchase(String token, String priceId) async;
  Future<String> getStatus(String token) async;
  Future<Map<String, dynamic>> changePlan(String token, String priceId) async;
  Future<Map<String, dynamic>> startFreeTrial(String token) async;
}
```

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit | `Usuario.fromJson` parsing | Mock various backend JSON payloads (valid subscription, null values, missing fields) and assert fields parse correctly. |
| Integration | `PaymentsService` API calls | Mock HTTP client in `CachedHttp.client` to verify endpoints, query parameters, auth headers, and body structures. |
| UI | Onboarding Feedback Screen | Verify loading indicator is shown and button is disabled when `isLoadingSubscription` is true, and check navigation logic. |

## Migration / Rollout

No data migration required as these are additions to an existing model and can handle null/missing backend responses gracefully. Code generation command `dart run build_runner build --delete-conflicting-outputs` MUST be run after updating `lib/models/usuario.dart`.

## Open Questions

- None.
