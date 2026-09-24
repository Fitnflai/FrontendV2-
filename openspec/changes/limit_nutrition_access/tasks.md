# Tasks: Limit Nutrition Access

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 40-70 |
| 400-line budget risk | Low |
| Chained PRs recommended | No |
| Suggested split | Single PR |
| Delivery strategy | single-pr |
| Chain strategy | pending |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: pending
400-line budget risk: Low

### Suggested Work Units

| Unit | Goal | Likely PR | Notes |
|------|------|-----------|-------|
| 1 | Implement premium access logic for nutrition screen | PR 1 | base branch; tests/docs included |

## Phase 1: UI Layer Changes (lib/screens/nutrition/nutrition_screen.dart)

- [ ] 1.1 Extract `user` object from `AuthProvider` using `context.watch<AuthProvider>()`.
- [ ] 1.2 Implement `isPremium` calculation based on `user.tienePlanActivo` and `user.nombrePlanActivo == "pro"`.
- [ ] 1.3 Add loading check: if `AuthProvider` is `loading`, render `Center(child: CircularProgressIndicator())` within the `Scaffold` body.
- [ ] 1.4 Wrap `_MacrosCard` widget with an `if (isPremium)` condition.
- [ ] 1.5 Wrap all `_MealCard` widgets with an `if (isPremium)` condition.
- [ ] 1.6 Wrap `_HydrationCard` widget with an `if (isPremium)` condition.
- [ ] 1.7 Display `_AIBanner()` widget when `isPremium` is false.

## Phase 2: Test Alignment (test/screens/nutrition/nutrition_screen_localization_test.dart)

- [ ] 2.1 Update `_mockUser` definition in `MockAuthProvider` to set `tienePlanActivo: true`.
- [ ] 2.2 Update `_mockUser` definition in `MockAuthProvider` to set `nombrePlanActivo: "pro"`.

## Phase 3: Verification

- [ ] 3.1 Run `flutter analyze` to confirm no new warnings or errors are introduced.
- [ ] 3.2 Run `flutter test test/screens/nutrition/` to ensure all relevant tests pass with the changes.