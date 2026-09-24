# Tasks: Fix Memberships Loading

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 5-10 lines |
| 400-line budget risk | Low |
| Chained PRs recommended | No |
| Suggested split | single PR |
| Delivery strategy | single-pr |
| Chain strategy | pending |

Decision needed before apply: No
Chained PRs recommended: No
Chain strategy: pending
400-line budget risk: Low

### Suggested Work Units

| Unit | Goal | Likely PR | Notes |
|------|------|-----------|-------|
| 1 | Implement and verify membership loading fix | PR 1 | Complete bugfix, tests included |

## Phase 1: Implement Loading Fix

- [ ] 1.1 Import `../../providers/auth_provider.dart` into `lib/screens/membership/membership_screen.dart`.
- [ ] 1.2 In `lib/screens/membership/membership_screen.dart`, inside `initState`'s post frame callback, update the token retrieval to use `context.read<AuthProvider>().token`.
- [ ] 1.3 In `lib/screens/membership/membership_screen.dart`, implement the fallback safety check: if token is null or empty, log a debug print and execute `Navigator.pop(context)`.

## Phase 2: Verification

- [ ] 2.1 Run `flutter analyze` in the project root to verify there are no compilation warnings or errors.
