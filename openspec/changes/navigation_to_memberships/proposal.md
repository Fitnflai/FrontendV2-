# Proposal: Navigation to Memberships

## Intent

Provide a seamless path for non-premium users to upgrade by connecting the "Ver plan pro" button on the nutrition paywall banner to the existing `MembershipScreen`.

## Scope

### In Scope
- Modifying `lib/screens/nutrition/nutrition_screen.dart` to wire the `onPressed` callback of the `ElevatedButton` inside `_AIBanner()` with navigation using `Navigator.push`.

### Out of Scope
- Any modification to `main.dart` or `app_routes.dart` (using direct navigation route push for maximum localization and safety).
- Modifying `MembershipScreen` itself.

## Capabilities

> This section is the CONTRACT between proposal and specs phases.
> The sdd-spec agent reads this to know exactly which spec files to create or update.

### New Capabilities
- None

### Modified Capabilities
- None

## Approach

- Import `package:fitnflaifrontendv2/screens/membership/membership_screen.dart` inside `lib/screens/nutrition/nutrition_screen.dart`.
- Update the `onPressed` callback of the `ElevatedButton` inside the `_AIBanner` class to execute `Navigator.push(context, MaterialPageRoute(builder: (context) => const MembershipScreen()))`.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `lib/screens/nutrition/nutrition_screen.dart` | Modified | Connects the "Ver plan pro" button to the MembershipScreen |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Navigation stack buildup if clicked multiple times | Low | Use standard `Navigator.push` which correctly handles back navigation without breaking existing flows |

## Rollback Plan

Revert the specific commit in `lib/screens/nutrition/nutrition_screen.dart` to restore the empty `onPressed` callback.

## Dependencies

- None

## Success Criteria

- [ ] Clicking the "Ver plan pro" button inside the `_AIBanner` successfully navigates the user to the `MembershipScreen`.
- [ ] Users can navigate back to the `NutritionScreen` without issues.
