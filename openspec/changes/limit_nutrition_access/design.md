# Design: Limit Nutrition Access

## Technical Approach

We will restrict access to premium nutrition features (macros, meals, and hydration cards) to users with active "Pro" or "Elite" plans. Non-premium users will only see the promotional Smart Nutrition banner (`_AIBanner()`). We will fetch user subscription details from `AuthProvider` and conditionally render layout components.

## Architecture Decisions

### Decision: Loading State Presentation

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Full-screen Scaffold Early Return | Quick implementation; causes visible layout shift and flashes header/navigation. | Rejected |
| Integrated Expanded Loader | Seamless UX; keeps the App Header and Bottom Navigation visible during auth load. | **Chosen** |

### Decision: Subscription Status Computation

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Local view calculation | Easy to implement directly in the view; duplicates if needed in other screens. | **Chosen** (simplest for single screen) |
| Abstract domain-level getter | Keeps view clean; over-engineering since the business logic is scoped to one screen. | Rejected |

## Data Flow

`AuthProvider` reads `Usuario` state. `NutritionScreen` listens via `context.watch<AuthProvider>()`, computes `isPremium`, and updates the UI accordingly.

```
[AuthRepository] ──→ [AuthProvider] ──(Notify)──→ [NutritionScreen]
                             │                            │
                     (Usuario model)             (Computes isPremium)
                             │                            │
                             └────────── UI Layout ───────┘
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `lib/screens/nutrition/nutrition_screen.dart` | Modify | Consume `AuthProvider` to compute `isPremium`, handle auth loading states, and wrap premium cards in conditional blocks. |
| `test/screens/nutrition/nutrition_screen_localization_test.dart` | Modify | Update `MockAuthProvider`'s `_mockUser` to include active `Pro` plan to ensure existing localization tests pass. |

## Interfaces / Contracts

No new interfaces. The computation uses existing `Usuario` fields:
```dart
final user = context.watch<AuthProvider>().user;
final bool isPremium = user != null &&
    user.tienePlanActivo == true &&
    (user.nombrePlanActivo?.toLowerCase() == 'pro' ||
     user.nombrePlanActivo?.toLowerCase() == 'elite');
```

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit (Widget) | Premium Access | Verify macros, meals, and hydration render when user is premium. |
| Unit (Widget) | Non-Premium Gate | Verify ONLY the AI Banner renders when user is non-premium. |
| Unit (Widget) | Loading State | Verify `CircularProgressIndicator` renders when auth is uninitialized/loading. |

## Migration / Rollout

No database migrations or feature flags are required. The changes are fully backward-compatible and rely on existing backend models.

## Open Questions

- None.
