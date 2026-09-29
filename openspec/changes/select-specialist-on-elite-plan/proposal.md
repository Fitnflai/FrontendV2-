# Proposal: Membership Payment Flow Optimization & Specialist Selection

## Intent

Optimize the user payment experience and security during membership subscriptions by restricting redundant plan purchases, supporting multiple saved cards selection, introducing CVV security validation on the frontend, and automatically guiding Elite plan subscribers to the specialist selection list immediately upon successful payment.

## Scope

### In Scope
- **Active Plan Restriction**: Disable selection/subscription for the plan the user already has active. Change button text to indicate active status (e.g., "Membresía activa" or "Tu plan actual").
- **Multiple Cards Selector**: In `MembershipScreen`'s checkout sheet, if multiple cards are saved, allow the user to select which card they want to use instead of hardcoding the first card.
- **Associate New Card Integration**: Allow users who already have saved cards to still choose "Asociar una nueva tarjeta" from the checkout sheet to add a new card.
- **CVV Security Verification**: Ask for and validate a 3-to-4 digit CVV in a secure modal/step before finalizing payment with a saved card.
- **Elite Post-Payment Specialist Selection**: Automatically trigger a non-dismissible `SpecialistSelectionBottomSheet` immediately after a successful Elite plan purchase (handles both the normal One-Click success step and the Deep-Link auto-subscription path).

### Out of Scope
- Backend database schema changes.
- Modifications to Nuvei API endpoints (frontend-only validations).
- Storing CVV anywhere on disk or in logs.

## Capabilities

### New Capabilities
- Frontend security check: CVV input form & validation (3-4 digits).
- Card selection mechanism for saved cards.

### Modified Capabilities
- Membership purchase restriction based on user profile's active plan.
- Guided onboarding redirection to Specialist list for Elite plan purchasers.

## Approach

1. **Active Plan Restriction**:
   - Extract the active plan name using `AuthProvider.user.nombrePlanActivo` or `ProfileProvider.planActivo['nombre']`.
   - Compare it against the selected plan card (`plan.name`).
   - If they match, disable the "Subscribe" ElevatedButton and update its text to "Membresía activa" or "Tu plan actual".

2. **Scenario B: Saved Card Selection & CVV**:
   - In `MembershipScreen`'s bottom sheet, if `profileProvider.savedCards` is not empty:
     - Render a list/selector of all saved cards.
     - Add an option/button at the bottom of the list to "Asociar nueva tarjeta".
     - When clicking "Confirmar y Suscribirse" with a saved card:
       - Transition to a CVV input field or display a custom confirmation modal.
       - Force the user to enter their CVV. Validate that the input is numeric and has length 3 (or 4 for American Express, if card brand is Amex).
       - Once validated, trigger the subscription via `profileProvider.subscribeNuveiAction()`.

3. **Elite Specialist Bottom Sheet Integration**:
   - **One-Click Path (MembershipScreen)**: On the success step (`checkoutStep == 3`), update the "Comenzar a entrenar" button's action. If `plan.name` is "Elite", when they click it, pop the checkout dialog and immediately launch the `SpecialistSelectionBottomSheet` with `isDismissible: false`, `enableDrag: false`, and `PopScope(canPop: false)`.
   - **Deep-Link Path (PaymentMethodsScreen)**: In `_saveCardFromDeepLink()` after successful subscription, reload the profile data. If the active plan is Elite, show the non-dismissible `SpecialistSelectionBottomSheet` directly from `PaymentMethodsScreen`'s context before returning.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `lib/screens/membership/membership_screen.dart` | Modified | Restricts active plan purchase, supports card selection, CVV modal, and post-payment Elite sheet trigger |
| `lib/screens/profile/payment_methods_screen.dart` | Modified | Triggers specialist sheet on successful Elite subscription before popping |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| CVV security and compliance exposure | High | Never persist, store, or log the CVV input. Keep it as pure local state variable in memory, and discard it immediately after calling the subscription action. |
| Inability to dismiss specialist sheet causing soft lock | Low | This is by design: Elite users MUST select a specialist before they can receive their training plans. The non-dismissible sheet ensures complete onboarding. |

## Rollback Plan

Revert changes in `lib/screens/membership/membership_screen.dart` and `lib/screens/profile/payment_methods_screen.dart` to their previous git commits.

## Dependencies

- `SpecialistSelectionBottomSheet` (already exists in `lib/widgets/specialist_selection_bottom_sheet.dart`).
- `SpecialistProvider` (provided globally in `MultiProvider`).

## Success Criteria

- [ ] Users cannot click or buy the same plan they currently have active.
- [ ] Users can see and choose between all saved cards during checkout.
- [ ] Users are prompted for a CVV which is verified locally on the frontend (3-4 digits only).
- [ ] Purchasing an Elite plan triggers the specialist selection bottom sheet automatically, which cannot be dismissed without selecting an available specialist.
