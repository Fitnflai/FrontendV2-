# Proposal: Memberships API Integration

## Intent

Integrate backend membership and subscription endpoints to support free trials, plan listing, and active subscription state management within the app. This enables users to view their active plan, initiate a free trial from the onboarding flow, and view available upgrade options.

## Scope

### In Scope
- Extending the `Usuario` Freezed model to include subscription-related fields (`nombre_plan_activo`, `fecha_fin_suscripcion`, `estado_suscripcion`, `tiene_plan_activo`).
- Creating a `PaymentsService` to consume the `/payments/*` backend endpoints.
- Updating `ProfileProvider` to manage subscription state, handle API loading/error states, and expose plan lists and active subscription details.
- Integrating the "Start Free Trial" logic into the `OnboardingFeedbackScreen`, including loading states, error handling, force-refreshing user data upon success, and navigating to `HomeScreen`.

### Out of Scope
- Full UI for payment gateway integration (e.g., entering credit card details), as the current scope focuses on trial initiation and API simulation endpoints.
- Deep UI for complete subscription management (canceling, updating payment methods) beyond what is exposed by the specified endpoints.

## Capabilities

> This section is the CONTRACT between proposal and specs phases.

### New Capabilities
- `payments-management`: Covers fetching available plans, simulating purchases, checking payment status, changing plans, and initiating the free trial.

### Modified Capabilities
- `user-profile`: Modifies the `Usuario` model and `ProfileService` (`/users/me`) to include and parse active subscription details.

## Approach

We will follow the app's established layered architecture (Services -> Providers -> UI) using `freezed` for models and `provider` for state management:

1. **Data Layer**: 
   - Update `Usuario` model with the new subscription fields and run `build_runner`.
   - Create `PaymentsService` to wrap the `GET /payments/planes`, `POST /payments/simulate-purchase`, `GET /payments/status`, `POST /payments/change-plan`, and `POST /payments/start-free-trial` endpoints.
2. **State Management**:
   - Add state variables in `ProfileProvider` for `plans`, `isLoadingSubscription`, and methods like `startFreeTrial()`, `loadPlans()`.
   - The `startFreeTrial()` method will call the `PaymentsService`, and on success, invoke `loadAll(token, force: true)` to synchronize the `Usuario` model with the backend.
3. **UI Layer**:
   - Update `OnboardingFeedbackScreen` to observe `ProfileProvider`. When the "Start Free Trial" button is tapped, trigger the provider method, show a `CircularProgressIndicator` while loading, and navigate to `HomeScreen` upon success.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `lib/models/usuario.dart` | Modified | Add subscription fields (`nombre_plan_activo`, `fecha_fin_suscripcion`, `estado_suscripcion`, `tiene_plan_activo`). |
| `lib/services/payments_service.dart` | New | API client for `/payments` endpoints. |
| `lib/providers/profile_provider.dart` | Modified | Add subscription state, plan list, and integration with `PaymentsService`. |
| `lib/screens/onboarding/onboarding_feedback_screen.dart` | Modified | Wire "Start Free Trial" button to trigger the backend API and handle loading/navigation. |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| JSON parsing errors on `/users/me` if backend fields are unexpectedly null or missing. | Medium | Use nullable types (`String?`, `DateTime?`) and default values (e.g., `tiene_plan_activo = false`) in the `freezed` model. |
| Stale subscription state in the app after trial activation. | Low | Explicitly call `loadAll(token, force: true)` to force a refresh immediately after a successful trial activation. |

## Rollback Plan

- Revert changes to `lib/models/usuario.dart` and regenerate with `build_runner`.
- Remove `PaymentsService` interactions from `ProfileProvider`.
- Restore the static navigation behavior on the "Start Free Trial" button in `OnboardingFeedbackScreen`.

## Dependencies

- Backend API (`/payments/*` and `/users/me`) must be deployed and returning the expected JSON schema.

## Success Criteria

- [ ] `Usuario` model successfully parses the new subscription fields from `/users/me`.
- [ ] `PaymentsService` can successfully fetch the list of plans from `/payments/planes`.
- [ ] Tapping "Start Free Trial" in `OnboardingFeedbackScreen` shows a loading indicator, successfully calls the backend, refreshes the user profile, and navigates to `HomeScreen`.
- [ ] `ProfileProvider` correctly exposes the user's active subscription status and the list of available plans.