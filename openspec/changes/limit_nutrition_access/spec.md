# Delta for Nutrition

## ADDED Requirements

### Requirement: Limit Nutrition Dashboard by Active Plan

The system MUST restrict access to the full Nutrition dashboard based on the authenticated user's active plan tier.

#### Scenario: Premium user accesses nutrition screen

- GIVEN the user is authenticated and has an active plan named "Pro" or "Elite"
- WHEN they open the nutrition screen
- THEN the screen MUST render the full dashboard including `_AIBanner()`, `_MacrosCard()`, meal lists, and `_HydrationCard()`

#### Scenario: Non-premium user accesses nutrition screen

- GIVEN the user is authenticated but has no active plan, or has an active plan that is NOT "Pro" and NOT "Elite"
- WHEN they open the nutrition screen
- THEN the screen MUST ONLY render the `_AIBanner()` card
- AND the screen MUST NOT render any other cards (`_MacrosCard()`, meal lists, or `_HydrationCard()`)

#### Scenario: User state is loading

- GIVEN the user authentication state is currently loading (the user object is null or fetching)
- WHEN they open the nutrition screen
- THEN the screen MUST display a central `CircularProgressIndicator` instead of showing any content or paywall

#### Scenario: Case insensitivity of plan names

- GIVEN the user has an active plan named "PRO", "pro", "Elite", or "elite"
- WHEN they open the nutrition screen
- THEN the screen MUST recognize them as premium and show all cards

#### Scenario: Test environment alignment

- GIVEN the nutrition localization tests run
- WHEN testing assertions for full dashboard elements (like "Daily Macros" or "Basic hydration")
- THEN the mock user MUST be configured with a "Pro" or "Elite" plan so that the full layout is rendered and the test passes
