# Tasks: Memberships API Integration

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 200-300 |
| 400-line budget risk | Low |
| Chained PRs recommended | No |
| Suggested split | Single PR |
| Delivery strategy | hybrid |
| Chain strategy | pending |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: pending
400-line budget risk: Low

### Suggested Work Units

| Unit | Goal | Likely PR | Notes |
|------|------|-----------|-------|
| 1 | Full feature implementation | Single PR | All changes in one PR |

## Phase 1: Model Changes (Approx. 30-50 lines)

- [ ] 1.1 Add `nombre_plan_activo` (String?), `fecha_fin_suscripcion` (String?), `estado_suscripcion` (String?), and `tiene_plan_activo` (bool) fields to `lib/models/usuario.dart`.
- [ ] 1.2 Update the `fromJson` factory inside `lib/models/usuario.dart` to parse these fields from their snake_case keys in the backend JSON payload.
- [ ] 1.3 Run `dart run build_runner build --delete-conflicting-outputs` to regenerate `lib/models/usuario.freezed.dart` and `lib/models/usuario.g.dart`.

## Phase 2: Service Layer (Approx. 80-120 lines)

- [ ] 2.1 Create `lib/services/payments_service.dart`.
- [ ] 2.2 Implement `Future<List<Map<String, dynamic>>> getPlanes(String token)` (GET `/payments/planes`) in `PaymentsService`.
- [ ] 2.3 Implement `Future<Map<String, dynamic>> simulatePurchase(String token, String priceId)` (POST `/payments/simulate-purchase` with body `{"id_precio": priceId}`) in `PaymentsService`.
- [ ] 2.4 Implement `Future<String> getStatus(String token)` (GET `/payments/status`) in `PaymentsService`.
- [ ] 2.5 Implement `Future<Map<String, dynamic>> changePlan(String token, String priceId)` (POST `/payments/change-plan` with body `{"id_precio": priceId}`) in `PaymentsService`.
- [ ] 2.6 Implement `Future<Map<String, dynamic>> startFreeTrial(String token)` (POST `/payments/start-free-trial` with empty body) in `PaymentsService`.

## Phase 3: State Management Layer (Approx. 60-90 lines)

- [ ] 3.1 Modify `lib/providers/profile_provider.dart` to hold `_planes` (List<dynamic>?), `_isLoadingSubscription` (bool), and `_subscriptionError` (String?).
- [ ] 3.2 Add getter methods for these fields in `ProfileProvider`.
- [ ] 3.3 Add `Future<void> loadPlanes(String token)` method to `ProfileProvider` to fetch and update available plans.
- [ ] 3.4 Add `Future<bool> startFreeTrial(String token)` method to `ProfileProvider` which calls `PaymentsService.startFreeTrial` and, on success, calls `loadAll(token, force: true)` to sync the profile.
- [ ] 3.5 Add `Future<bool> simulatePurchase(String token, String priceId)` and `Future<bool> changePlan(String token, String priceId)` to `ProfileProvider`.
- [ ] 3.6 Ensure `loadAll(token)` updates the dynamic profile map and we can deserialise/expose `Usuario?` if needed, maintaining backward compatibility.

## Phase 4: UI Layer (Approx. 20-30 lines)

- [ ] 4.1 Update `lib/screens/onboarding/onboarding_feedback_screen.dart` to check `ProfileProvider.isLoadingSubscription`.
- [ ] 4.2 Modify the "Start Free Trial" button in `onboarding_feedback_screen.dart` to display a loading indicator (`CircularProgressIndicator`) and disable the button while `isLoadingSubscription` is true.
- [ ] 4.3 Implement success/error handling (e.g. SnackBar on failure) and ensure navigation to `HomeScreen(fromOnboarding: true)` on success.

## Phase 5: Verification (Approx. 5-10 tasks)

- [ ] 5.1 Write unit/widget tests or verify local compilation using `flutter analyze` and `flutter test`.
- [ ] 5.2 Manual Test: Verify `OnboardingFeedbackScreen` displays loading indicator when "Start Free Trial" is tapped.
- [ ] 5.3 Manual Test: Verify `OnboardingFeedbackScreen` navigates correctly on successful free trial activation.
- [ ] 5.4 Manual Test: Verify `OnboardingFeedbackScreen` displays an error message on failed free trial activation.
- [ ] 5.5 Manual Test: Verify `Usuario` model correctly reflects subscription status after API calls.
