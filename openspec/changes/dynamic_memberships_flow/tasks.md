# Tasks: Dynamic Memberships Flow

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 400-600 |
| 400-line budget risk | High |
| Chained PRs recommended | Yes |
| Suggested split | PR 1 (Service Layer) → PR 2 (Provider) → PR 3 (UI & Integration) |
| Delivery strategy | ask-on-risk |
| Chain strategy | pending |

Decision needed before apply: Yes
Chained PRs recommended: Yes
Chain strategy: pending
400-line budget risk: High

### Suggested Work Units

| Unit | Goal | Likely PR | Notes |
|------|------|-----------|-------|
| 1 | Service layer updates for `changePlan` | PR 1 | Base branch; independent |
| 2 | Profile Provider implementation | PR 2 | Depends on PR 1; updates `profile_provider.dart` |
| 3 | Membership UI and integration | PR 3 | Depends on PR 2; updates `membership_screen.dart` |

## Phase 1: Service Layer Enhancements

- [ ] 1.1 Modify `lib/services/payments_service.dart` to add `changePlan` query parameters.
- [ ] 1.2 Implement safe body parsing for the `changePlan` method in `lib/services/payments_service.dart`.
- [ ] 1.3 Add unit tests for `payments_service.dart` to cover new query parameter handling and body parsing.

## Phase 2: Profile Provider Implementation

- [ ] 2.1 Update `lib/providers/profile_provider.dart` to fetch available membership plans from `payments_service`.
- [ ] 2.2 Implement state management within `profile_provider.dart` for selected plan and pricing.
- [ ] 2.3 Add methods to `profile_provider.dart` to handle user actions related to plan selection.
- [ ] 2.4 Add unit tests for `profile_provider.dart` covering plan fetching, state updates, and action handling.

## Phase 3: Membership Screen UI & Integration

- [ ] 3.1 Implement dynamic loading of membership plans in `lib/screens/membership/membership_screen.dart` on initialization.
- [ ] 3.2 Add UI logic to `membership_screen.dart` to toggle between monthly/annual pricing based on `prices list frequency`.
- [ ] 3.3 Implement mapping of `id_precio` corresponding to the selected period within `membership_screen.dart`.
- [ ] 3.4 Design and implement an interactive bottom sheet for membership plan selection in `membership_screen.dart`.
- [ ] 3.5 Integrate the `changePlan` sequence by calling the `profile_provider` method from the UI.
- [ ] 3.6 Create integration tests to verify the end-to-end flow from UI selection to service call.

## Phase 4: Verification and Quality Assurance

- [ ] 4.1 Run `flutter analyze` to ensure code quality, adherence to style guidelines, and identify any static analysis issues across all modified files.
- [ ] 4.2 Review all implemented features against the original design specifications.
