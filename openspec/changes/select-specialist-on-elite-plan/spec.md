# Specifications: Membership Payment Flow Optimization & Specialist Selection

## MODIFIED Requirements

### Requirement: Active Plan Subscription Restriction
The system MUST prevent users from purchasing or subscribing to the membership plan they currently have active.
- The UI MUST compare the selected plan's name against the active plan name retrieved from the backend (accessible via `AuthProvider.user.nombrePlanActivo` or `ProfileProvider.planActivo['nombre']`).
- If they match, the subscription button for that plan MUST be disabled and updated to display "Tu plan actual" or "Membresía activa".
- The system MUST prevent opening the payment bottom sheet if the plan is already active.

### Requirement: Multiple Saved Cards Selection
The system MUST support listing and selecting from multiple saved credit cards when initiating a subscription checkout.
- If the user has saved cards (`profileProvider.savedCards` is not empty), the checkout bottom sheet MUST render a selectable list (radio buttons or checkmarks) displaying the brand and last four digits of all saved cards.
- The default selection MUST be the first card in the list.
- The checkout sheet MUST display a button/option labeled "Asociar nueva tarjeta" to allow the user to trigger the add-card flow even if they already have saved cards.

### Requirement: Frontend CVV Verification Step
The system MUST enforce a CVV security check on the frontend before charging any saved card.
- Upon clicking "Confirm and Subscribe" with a saved card, the checkout sheet MUST prompt the user to enter their card's CVV security code.
- The CVV input MUST be masked (keyboard type number, secure text entry or obscure text enabled).
- The system MUST validate the CVV locally: it must contain only digits and have a length of exactly 3 (or 4 for American Express card brand).
- If validation fails, an appropriate local error message MUST be shown, and the purchase request MUST NOT be sent.
- If validation passes, the system proceeds to process the payment via `profileProvider.subscribeNuveiAction()`.
- **Security Constraint**: The CVV MUST NOT be stored in local preferences, database, or written to debug logs. It must exist only as transient widget state and be discarded immediately after the payment action starts.

### Requirement: Post-Payment Specialist Selection (Elite Plan)
The system MUST automatically and non-dismissibly prompt Elite plan subscribers to choose an available specialist immediately after their payment is successfully confirmed.
- This applies to both checkout paths:
  - **One-Click Payment**: In `MembershipScreen`, when completing checkout via a saved card, upon reaching the success step (`checkoutStep == 3`), clicking the "Comenzar a entrenar" action button MUST close the checkout modal and immediately open the `SpecialistSelectionBottomSheet`.
  - **Deep-Link Auto-Subscription**: In `PaymentMethodsScreen`, upon returning from card association and successfully auto-subscribing, if the newly active plan is Elite, the system MUST display the `SpecialistSelectionBottomSheet` directly from the screen context before performing navigation pops.
- **Enforcement**: The `SpecialistSelectionBottomSheet` MUST be opened with `isDismissible: false`, `enableDrag: false`, and wrapped in a `PopScope(canPop: false)` to prevent closure without choosing a specialist.

---

## Acceptance Criteria & Test Scenarios

### Scenario 1: Preventing Redundant Subscriptions
```gherkin
Given a user has an active "Pro" plan subscription
When they open the "Membresías" screen
Then the plan card for the "Pro" plan should display a disabled button with the text "Tu plan actual"
And clicking this button should do nothing
But the button for the "Elite" plan should be enabled and allow the user to subscribe
```

### Scenario 2: Multiple Card Selection in Checkout
```gherkin
Given a user has two saved cards:
  | brand      | last_four |
  | Visa       | 1111      |
  | Mastercard | 2222      |
When they click "Suscribirme al Pro"
Then the checkout bottom sheet should list both cards with radio selection buttons
And the Visa card ending in 1111 should be selected by default
And an option "Asociar nueva tarjeta" should be visible in the sheet
When the user selects the Mastercard ending in 2222
Then the selected card state should update to the Mastercard
```

### Scenario 3: Secure CVV Prompt and Local Validation
```gherkin
Given a user is in the checkout bottom sheet with a selected saved card
When they click "Confirmar y Suscribirse"
Then they should be prompted to enter the CVV of the card
When they enter "1" (length < 3) and click confirm
Then a validation error "El CVV debe tener 3 o 4 dígitos" should be shown
And no API requests should be sent
When they enter "123" (valid CVV) and click confirm
Then the purchase should be processed via subscribeNuveiAction
And the CVV state should be cleared/discarded immediately
```

### Scenario 4: Automated Specialist Selection upon successful Elite subscription (One-Click)
```gherkin
Given a user has successfully purchased the "Elite" plan using One-Click payment
And they are shown the payment success screen
When they click the "Comenzar a entrenar" button
Then the payment bottom sheet should close
And the "Elige a tu Especialista" bottom sheet should open immediately
And the sheet should not close when tapping outside or swiping down
And pressing the system back button should not close the sheet
```

### Scenario 5: Automated Specialist Selection upon successful Elite subscription (Deep-Link)
```gherkin
Given a user without saved cards initiates an "Elite" subscription checkout
And they are redirected to Nuvei to associate their card
When they successfully associate their card and the deep-link returns them to the app
Then the card is saved and they are auto-subscribed to the "Elite" plan
And they are shown a success snackbar "¡Suscripción realizada con éxito!"
Then the "Elige a tu Especialista" bottom sheet should open immediately on top of the PaymentMethodsScreen
And the sheet should not close when tapping outside or swiping down
```
