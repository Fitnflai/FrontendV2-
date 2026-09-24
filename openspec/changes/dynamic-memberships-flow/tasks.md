# Tasks: Dynamic Memberships Flow

## Review Workload Forecast

| Field | Value |
|-------|-------|
| Estimated changed lines | 150-250 |
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
| 1 | Implement dynamic memberships flow | Single PR | All changes in one PR |

## Phase 1: Service Layer Changes

- [ ] 1.1 Modify `lib/services/payments_service.dart`: Locate `changePlan(String token, String priceId)` method.
- [ ] 1.2 Update `changePlan` to append `new_price_id` as a query parameter to the URL: `/payments/change-plan?new_price_id=$priceId`.
- [ ] 1.3 Implement `changePlan` response parsing to handle both JSON and raw string responses gracefully, preventing format exceptions.
- [ ] 1.4 Ensure `changePlan` correctly passes the provided `token` in the Authorization header.

## Phase 2: Provider Changes

- [ ] 2.1 Verify `lib/providers/profile_provider.dart` contains `loadPlanes(String token)` method.
- [ ] 2.2 Verify `lib/providers/profile_provider.dart` contains `simulatePurchase(String token, String priceId)` method.
- [ ] 2.3 Verify `lib/providers/profile_provider.dart` contains `changePlan(String token, String priceId)` method.
- [ ] 2.4 Ensure `ProfileProvider` correctly exposes fetched lists of planes and their associated loading states.

## Phase 3: View Layer Changes

- [ ] 3.1 In `lib/screens/membership/membership_screen.dart`, locate the `_MembershipScreenState` class.
- [ ] 3.2 In `_MembershipScreenState.initState()`, add logic to read the authentication token.
- [ ] 3.3 Call `ProfileProvider.loadPlanes(token)` within `initState()`.
- [ ] 3.4 Implement conditional UI rendering: while `ProfileProvider.planes` is `null` or loading, display a centered `CircularProgressIndicator`.
- [ ] 3.5 Dynamically map the three membership plans (Essential, Pro, Elite) from the `ProfileProvider.planes` API response to the UI.
- [ ] 3.6 For each plan, extract the `id_precio` and `precio` values based on the active billing period toggle (`_isAnnual`).
- [ ] 3.7 Locate the bottom sheet checkout dialog (`_subscribe` method or equivalent).
- [ ] 3.8 Wrap the content of the checkout dialog within a `StatefulBuilder` to manage local loading and error states.
- [ ] 3.9 Inside the `StatefulBuilder`, initialize a local loading state variable (e.g., `_isProcessingPayment = false`).
- [ ] 3.10 On confirm button press ("Confirmar y Simular Pago"):
    - [ ] 3.10.1 Set `_isProcessingPayment` to `true` and update UI (e.g., show a spinner, disable button).
    - [ ] 3.10.2 Call `ProfileProvider.simulatePurchase(token, selectedPriceId)` with the request body `{"id_precio": selectedPriceId}`.
    - [ ] 3.10.3 On successful `simulatePurchase`, call `ProfileProvider.changePlan(token, selectedPriceId)`.
    - [ ] 3.10.4 Ensure `ProfileProvider.changePlan` correctly sends `new_price_id=selectedPriceId` as a query parameter.
    - [ ] 3.10.5 On successful `changePlan`, call `ProfileProvider.loadAll(token, force: true)` to refresh user data.
    - [ ] 3.10.6 Show a success `SnackBar` notification.
    - [ ] 3.10.7 `Navigator.pop(context)` to dismiss the bottom sheet modal.
    - [ ] 3.10.8 `Navigator.pop(context)` to dismiss the `MembershipScreen`, returning to the previous screen.
    - [ ] 3.10.9 On any caught `Exception` or `Error`:
        - [ ] 3.10.9.1 Set `_isProcessingPayment` to `false` and update UI (hide spinner, re-enable button).
        - [ ] 3.10.9.2 Display the error message prominently within the bottom sheet for user feedback.
        - [ ] 3.10.9.3 Allow the user to retry the operation.

## Phase 4: Verification

- [ ] 4.1 Run `flutter analyze` and resolve any warnings or errors to ensure 100% clean compilation.
- [ ] 4.2 Manually test the membership screen:
    - [ ] 4.2.1 Verify correct loading state display on initial screen load.
    - [ ] 4.2.2 Verify plans are dynamically loaded and displayed correctly for both annual and monthly toggles.
    - [ ] 4.2.3 Select a plan and open the checkout bottom sheet.
    - [ ] 4.2.4 Verify loading states are handled correctly within the bottom sheet.
    - [ ] 4.2.5 Confirm a purchase and verify the success flow (SnackBar, screen navigation).
    - [ ] 4.2.6 Simulate an error during purchase (if possible via a test environment) and verify error display and retry mechanism.
    - [ ] 4.2.7 Verify `new_price_id` is sent as a query parameter for `changePlan` using network inspection tools (e.g., Charles Proxy, Fiddler).