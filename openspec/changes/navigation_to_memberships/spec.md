# Delta for Navigation to Memberships

## ADDED Requirements

### Requirement: Navigate to Memberships from Nutrition

The system MUST push `MembershipScreen` onto the navigation stack when the user interacts with the upgrade banner in the nutrition screen, and MUST properly handle back navigation to return to the original state.

#### Scenario: User taps 'Ver plan pro' button

- GIVEN the user is on the nutrition screen and has a non-premium tier (Pro/Elite is false)
- WHEN they tap the "Ver plan pro" button inside the `_AIBanner`
- THEN the system MUST push `MembershipScreen` onto the navigation stack
- AND transition the user to the memberships dashboard.

#### Scenario: User navigates back from memberships

- GIVEN the user is on the `MembershipScreen` (navigated from nutrition)
- WHEN they trigger back navigation (system back button or appBar back button)
- THEN the system MUST pop the `MembershipScreen` from the navigation stack
- AND return the user safely to the `NutritionScreen` in its previous state.
