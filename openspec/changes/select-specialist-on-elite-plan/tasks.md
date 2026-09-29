# Tasks: Membership Payment Flow Optimization & Specialist Selection

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | ~180 lines |
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
| 1 | Active Plan Restriction | PR 1 | Disable selection of already active membership |
| 2 | Multiple Cards Selection & CVV Input | PR 1 | Render saved card selection list, prompt & validate CVV |
| 3 | Elite Plan Specialist Selection Redirection | PR 1 | Auto-trigger Specialist Selection sheet on Elite plan checkout success |
| 4 | Verification & Compilation Check | PR 1 | Run analysis and compiler verification |

---

## Phase 1: Active Plan Subscription Restriction

- [x] 1.1 In `lib/screens/membership/membership_screen.dart`, inspect imports and ensure `AuthProvider` and `ProfileProvider` are available.
- [x] 1.2 Inside `MembershipScreenState.build` method, extract the currently active plan's name from `context.watch<AuthProvider>().user?.nombrePlanActivo` or `profileProvider.planActivo?['nombre']` (case-insensitively).
- [x] 1.3 Modify the construction of `_PlanCard` to pass `isActivePlan: (plan.name.toLowerCase() == activePlanName.toLowerCase())`.
- [x] 1.4 Update the `_PlanCard` widget constructor to accept `required bool isActivePlan`.
- [x] 1.5 In `_PlanCard`'s build method, if `isActivePlan` is true:
  - Disable the button (set `onPressed` to `null`).
  - Change the button text label to "Tu plan actual".

## Phase 2: Multiple Saved Cards Selection & CVV Validation

- [x] 2.1 In `lib/screens/membership/membership_screen.dart` inside the `_subscribe` bottom sheet builder, declare state variables inside the `StatefulBuilder`:
  - `int selectedCardIndex = 0;` (to track selection)
  - `bool showCvvPrompt = false;` (to toggle CVV modal phase)
  - `final TextEditingController cvvController = TextEditingController();` (for CVV input text control)
  - `String? cvvError;` (for local validation feedback)
- [x] 2.2 Modify the layout when `profileProvider.savedCards.isNotEmpty` to:
  - Display a clean list of all saved cards using `Column` with radio checklist or checkmark selections.
  - Render a clickable option/button at the bottom of the list for "Asociar una nueva tarjeta" to allow adding cards even when some are already saved. Clicking this triggers the `associateCard` flow and dismisses the checkout modal.
- [x] 2.3 Update the "Confirm and Subscribe" button's action. Instead of calling `subscribeNuveiAction()` directly, toggle `setModalState(() { showCvvPrompt = true; });`.
- [x] 2.4 Render the CVV security prompt inside the bottom sheet when `showCvvPrompt` is true:
  - Display the card details being charged.
  - Show a secured numerical text field (`obscureText: true`, keyboard type `TextInputType.number`, max length `4`).
  - Render "Confirmar Pago" and "Atrás" action buttons.
- [x] 2.5 Implement local frontend validation for the CVV inside the "Confirmar Pago" action:
  - Verify that the input consists of only digits and is exactly 3 (or 4 digits if the selected card's brand contains "amex" or "american").
  - If validation fails, update `cvvError` to "El CVV debe tener 3 o 4 dígitos" and prevent submission.
  - If validation passes, reset controller state and trigger `profileProvider.subscribeNuveiAction(token!, priceId)`. Ensure CVV is never logged or stored.

## Phase 3: Elite Post-Payment Specialist Selection

- [x] 3.1 In `lib/screens/membership/membership_screen.dart`'s checkout success step (`checkoutStep == 3`), modify the "Comenzar a entrenar" button action.
- [x] 3.2 If the plan name is "Elite" (`plan.name.toLowerCase() == 'elite'`), upon clicking "Comenzar a entrenar", pop the checkout modal and immediately open `SpecialistSelectionBottomSheet` using:
  ```dart
  showModalBottomSheet(
    context: pageContext,
    isScrollControlled: true,
    isDismissible: false,
    enableDrag: false,
    builder: (ctx) => const SpecialistSelectionBottomSheet(),
  );
  ```
- [x] 3.3 In `lib/screens/profile/payment_methods_screen.dart`'s `_saveCardFromDeepLink` method, after successful Nuvei subscription (`await profileProvider.subscribeNuveiAction(...)`):
  - Force-reload the profile to ensure synchronization: `await profileProvider.loadAll(authProvider.token!, force: true)`.
  - Check if the newly active plan's name contains "elite" (`profileProvider.planActivo?['nombre']?.toString().toLowerCase().contains('elite') == true`).
  - If it is Elite, trigger `SpecialistSelectionBottomSheet` as a non-dismissible sheet:
    ```dart
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      isDismissible: false,
      enableDrag: false,
      builder: (ctx) => const SpecialistSelectionBottomSheet(),
    );
    ```
  - Then proceed to navigate pop back.

## Phase 4: Verification & Integrity

- [x] 4.1 Run `flutter analyze` to ensure there are no compilation errors or analysis issues.
- [x] 4.2 Run existing tests to ensure no regressions are introduced.
