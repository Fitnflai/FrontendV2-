# Proposal: Dynamic Memberships Flow

## Intent
Turn the static `MembershipScreen` into a fully dynamic screen showing 3 plan tiers (Essential, Pro, Elite) by loading them from the API. Integrate the real simulated purchase and plan-change API sequence to enable users to upgrade or change their subscriptions dynamically.

## Scope

### In Scope
- Modifying `PaymentsService` to correctly send `new_price_id` as a query parameter for the `/payments/change-plan` endpoint.
- Updating `ProfileProvider` to fetch the available plans (`/payments/planes`), orchestrate the simulation and change-plan flow, and refresh the profile data upon success.
- Modifying `MembershipScreen` to:
  - Fetch plans on initialization.
  - Display the 3 plans dynamically, including switching between monthly and annual pricing.
  - Update the checkout bottom sheet to execute the real simulated sequence and show a success toast.

### Out of Scope
- Real payment gateway integration with bank cards (this is handled via the backend mock simulation API).
- Creating new backend endpoints.

## Capabilities

### New Capabilities
- `memberships`: Displaying available membership plans, their benefits, and allowing price selection (monthly/annual).
- `checkout-simulation`: Orchestrating the API sequence to simulate a purchase and update the user's plan.

### Modified Capabilities
- None

## Approach
1. Load plans via `ProfileProvider` using the `GET /payments/planes` endpoint on `MembershipScreen` init.
2. Filter plan prices dynamically (`mensual` vs. `anual`) based on the user's toggle selection.
3. Update `_subscribe` in the checkout bottom sheet to execute a step-by-step API sequence:
   - Call `ProfileProvider.simulatePurchase(token, priceId)`.
   - Call `ProfileProvider.changePlan(token, priceId)` which hits `POST /payments/change-plan?new_price_id=...`.
   - On success: reload the user profile (`ProfileProvider.loadAll`), show a success toast, and pop the navigation stack.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `lib/services/payments_service.dart` | Modified | Fix `changePlan` to pass `new_price_id` as a query parameter. |
| `lib/providers/profile_provider.dart` | Modified | Add logic to fetch plans and coordinate the simulated purchase flow. |
| `lib/screens/membership/membership_screen.dart` | Modified | Remove static UI, use API data, and wire up the interactive checkout bottom sheet. |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| API failures during checkout | Low | Implement robust try-catch blocks and show clear error UI in the bottom sheet. |
| Profile failing to reload | Low | Fallback to existing cached profile state, prompt user to pull-to-refresh if needed. |

## Rollback Plan
Revert changes to `MembershipScreen`, `ProfileProvider`, and `PaymentsService` via Git if the dynamic plan fetching causes app crashes or blockers in the navigation flow. 

## Dependencies
- Backend simulation API endpoints (`/payments/planes`, `/payments/simulate-purchase`, `/payments/change-plan`) must be operational.

## Success Criteria
- [ ] `MembershipScreen` displays 3 plans loaded from the API.
- [ ] Toggling between monthly and annual updates prices properly.
- [ ] Subscribing to a plan successfully calls both the simulation and change-plan APIs.
- [ ] User profile reloads and reflects the new active plan after a successful checkout.