# Dynamic Memberships Flow Specification

## Purpose

This specification details the dynamic memberships screen and checkout flow, transitioning from hardcoded plans to dynamically fetched plans, simulating purchases, and executing plan changes.

## ADDED Requirements

### Requirement: Dynamic Plan Loading

The system MUST fetch and display membership plans dynamically upon screen initialization.

#### Scenario: Loading plans dynamically on screen initialization

- GIVEN the user is on the `MembershipScreen`
- WHEN the screen initializes
- THEN the screen MUST show a loading indicator
- AND the system MUST fetch all available membership plans via `GET /payments/planes`
- AND once loaded, the screen MUST render the 3 plan tabs dynamically.

### Requirement: Billing Period Selection

The system MUST update displayed prices dynamically based on the selected billing period.

#### Scenario: Selecting period (monthly vs annual)

- GIVEN the dynamic plans are loaded
- WHEN the user toggles between monthly and annual billing periods
- THEN the system MUST update the displayed prices
- AND filter the price ID (`id_precio`) corresponding to the selected frequency ("mensual" for monthly, "anual" for annual).

### Requirement: Checkout Modal Presentation

The system MUST display a structured checkout dialog before confirming a purchase.

#### Scenario: Tapping "Suscribirme al..." button opens checkout modal

- GIVEN the user is viewing a selected plan
- WHEN they tap the subscribe button inside the `_PlanCard`
- THEN the system MUST display a bottom sheet checkout dialog showing the selected plan name, dynamic price, frequency, and a "Confirmar y Simular Pago" button.

### Requirement: Purchase Simulation and Plan Change Sequence

The system MUST orchestrate a sequential purchase simulation and plan change workflow upon confirmation.

#### Scenario: Successful purchase simulation and plan change sequence

- GIVEN the checkout bottom sheet is open
- WHEN the user taps "Confirmar y Simular Pago"
- THEN the system MUST show a loading state on the button
- AND call `POST /payments/simulate-purchase` with `{ "id_precio": "<selected_price_id>" }`
- AND on success, immediately call `POST /payments/change-plan?new_price_id=<selected_price_id>` passing the price ID as a query parameter
- AND on success, call `loadAll(token, force: true)` to reload user profile data
- AND display a success message, pop the bottom sheet, and pop the `MembershipScreen`.

#### Scenario: Failure during purchase simulation

- GIVEN the user is confirming the purchase
- WHEN the `/payments/simulate-purchase` API call fails
- THEN the system MUST stop the loading indicator and re-enable the button
- AND display a helpful error message inside the bottom sheet, allowing retry.

#### Scenario: Failure during plan change

- GIVEN the user has successfully simulated the purchase, but the `/payments/change-plan` API call fails
- THEN the system MUST stop the loading indicator and re-enable the button
- AND display a helpful error message inside the bottom sheet, allowing retry.