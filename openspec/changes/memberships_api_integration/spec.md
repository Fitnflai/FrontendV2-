# Delta Spec: Memberships API Integration

## ADDED Requirements

### Requirement: Fetch Plans and Prices
The system MUST retrieve available subscription plans and their respective prices from the `GET /payments/planes` endpoint.

#### Scenario: Successful plans fetch
- GIVEN the user is authenticated
- WHEN the system requests `GET /payments/planes`
- THEN the system MUST parse a list of plans where each plan contains a list of prices
- AND the UI MUST display the available plans to the user

#### Scenario: Empty or failed plans fetch
- GIVEN the user is authenticated
- WHEN the system requests `GET /payments/planes` and the API fails or returns an empty list
- THEN the system MUST handle the error gracefully without crashing
- AND MUST display an appropriate error message or fallback UI

### Requirement: User Profile Subscription Fields
The system MUST parse and handle membership-related fields from the `GET /users/me` response.

#### Scenario: Parsing complete subscription details
- GIVEN the `GET /users/me` response contains active subscription details
- WHEN the system parses the response into the user domain model
- THEN the system MUST successfully extract `nombre_plan_activo`, `fecha_fin_suscripcion`, `estado_suscripcion`, and `tiene_plan_activo`

#### Scenario: Handling null or missing subscription details
- GIVEN the `GET /users/me` response has null or missing subscription fields
- WHEN the system parses the response into the user domain model
- THEN the system MUST map `tiene_plan_activo` to `false` by default
- AND MUST gracefully handle null `fecha_fin_suscripcion` and null or empty `estado_suscripcion` without throwing parsing errors

### Requirement: Free Trial Initiation
The system MUST allow users to start a free trial via `POST /payments/start-free-trial` from the `OnboardingFeedbackScreen`.

#### Scenario: Successful free trial initiation
- GIVEN the user is on the `OnboardingFeedbackScreen`
- WHEN the user taps the action to start the free trial
- THEN the system MUST set a loading state, disable the action button, and show a loading indicator
- AND the system MUST call `POST /payments/start-free-trial`
- AND upon success, the system MUST call `loadAll(token, force: true)` to synchronize backend changes with the local profile state
- AND MUST navigate the user to the `HomeScreen`

#### Scenario: Failed free trial initiation
- GIVEN the user is on the `OnboardingFeedbackScreen`
- WHEN the user taps the action to start the free trial and the API call fails
- THEN the system MUST hide the loading indicator and re-enable the action button
- AND the system MUST display an error SnackBar or alert to the user
- AND the system MUST allow the user to retry the action

### Requirement: Purchase Simulation and Plan Changing
The system MUST expose actions in `ProfileProvider` to simulate a purchase and change a plan, interacting with the corresponding API endpoints.

#### Scenario: Successful purchase simulation
- GIVEN the user is authenticated
- WHEN the user triggers a purchase simulation via `ProfileProvider`
- THEN the system MUST call `POST /payments/simulate-purchase` with `{ "id_precio": "<value>" }` in the request body
- AND the system MUST validate the JSON response
- AND MUST update the local profile state appropriately

#### Scenario: Successful plan change
- GIVEN the user is authenticated
- WHEN the user triggers a plan change via `ProfileProvider`
- THEN the system MUST call `POST /payments/change-plan` with `{ "id_precio": "<value>" }` in the request body
- AND the system MUST validate the JSON response
- AND MUST update the local profile state appropriately

#### Scenario: Handling validation or HTTP errors for payments
- GIVEN the user triggers a purchase simulation or plan change
- WHEN the API responds with a validation or HTTP error
- THEN the system MUST catch the error
- AND MUST NOT crash
- AND MUST propagate the error to the UI for appropriate user feedback
