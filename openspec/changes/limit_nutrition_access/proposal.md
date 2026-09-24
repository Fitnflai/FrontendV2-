# Proposal: Limit Nutrition Access

## Intent
Protect premium nutrition features (macros, meals, hydration) by restricting visibility to users with an active "Pro" or "Elite" plan. Non-premium users will only see the promotional Smart Nutrition banner.

## Scope

### In Scope
- Conditional rendering inside `lib/screens/nutrition/nutrition_screen.dart` based on the user's active plan.
- Test updates in `test/screens/nutrition/nutrition_screen_localization_test.dart` to verify UI correctly hides/shows features based on user tier.

### Out of Scope
- Creating a new payment paywall flow or payment popup within the nutrition screen (using existing banner only).
- Modifying backend endpoint permissions (UI-only restriction for now).
- Changes to other premium screens (only affects Nutrition).

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- `nutrition-dashboard`: Modifying the main nutrition view to enforce plan-based access controls and render a partial paywalled view.

## Approach
- Extract user data from `AuthProvider.user`.
- Calculate `isPremium` based on `user.tienePlanActivo == true && (user.nombrePlanActivo?.toLowerCase() == 'pro' || user.nombrePlanActivo?.toLowerCase() == 'elite')`.
- In `NutritionScreen`, if `isPremium` is true, render the full screen layout (banner, macros, meal cards, hydration card).
- If `isPremium` is false (or null), render ONLY the `_AIBanner()` card as a standalone paywall screen, hiding all other cards.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `lib/screens/nutrition/nutrition_screen.dart` | Modified | Adds conditional logic to render full view vs restricted view based on tier. |
| `test/screens/nutrition/nutrition_screen_localization_test.dart` | Modified | Adds mocked tier states to verify UI differences. |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| State nullability (user not fully loaded) | Medium | Display a loading state or default to restricted until the user's plan is verified. |
| Case sensitivity of plan names | Low | Ensure string comparison uses `.toLowerCase()`. |

## Rollback Plan
Revert the commits affecting `nutrition_screen.dart` to restore unconditional access to the full screen.

## Dependencies
- `AuthProvider` and user model must accurately reflect `tienePlanActivo` and `nombrePlanActivo` fields.

## Success Criteria
- [ ] Users without an active "Pro" or "Elite" plan only see the Smart Nutrition banner.
- [ ] Users with an active "Pro" or "Elite" plan see the full nutrition features (macros, meals, hydration).
- [ ] Unit tests pass for both premium and non-premium states simulating the provider state.