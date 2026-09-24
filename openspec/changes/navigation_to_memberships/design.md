# Design: Navigation to Memberships

## Technical Approach

We will connect the promotional paywall banner (`_AIBanner`) on the nutrition screen to the membership plans screen (`MembershipScreen`). This allows non-premium users who see the banner to tap the upgrade button and seamlessly navigate to the memberships dashboard. We will use standard declarative Flutter navigation (`Navigator.push`) with a relative screen-to-screen import to maintain local code cohesion.

## Architecture Decisions

### Decision: Navigation Routing Approach

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Named Routes (`Navigator.pushNamed`) | Centralized routing; requires updating global router configurations and registering a new route for a localized transition. | Rejected |
| Direct MaterialPageRoute Push | Highly localized; doesn't require modifying global routing tables or `main.dart`, making it self-contained and safe. | **Chosen** |

### Decision: Screen Import Style

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Package Import (`import 'package:fitnflaifrontendv2/...'`) | Explicit and uniform across the project; can feel overly verbose for neighboring screens within the same directory tree. | Rejected |
| Relative Import (`import '../membership/membership_screen.dart'`) | Direct and clean; matches the existing import patterns used in `nutrition_screen.dart` for modular structures. | **Chosen** |

## Data Flow

When the user taps the upgrade button, `_AIBanner` initiates navigation. The `Navigator` pushes `MembershipScreen` onto the stack. Back navigation pops `MembershipScreen` to return the user back to the same state.

```
[NutritionScreen] ──(Renders)──→ [_AIBanner] ──(Taps 'Ver plan pro')──→ [Navigator.push]
       ▲                                                                      │
       │                                                                      ▼
[NutritionScreen] ←──(Pops Stack)── [Navigator.pop] ←──(Taps back) ── [MembershipScreen]
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `lib/screens/nutrition/nutrition_screen.dart` | Modify | Import `membership_screen.dart` and update the `_AIBanner`'s `ElevatedButton.onPressed` callback. |

## Interfaces / Contracts

### Context Access inside `_AIBanner`

Because `_AIBanner` is a stateless widget (`class _AIBanner extends StatelessWidget`), it receives `BuildContext` as a parameter in its `build(BuildContext context)` method. The `onPressed` callback has immediate access to `context` via lexical scoping, ensuring standard and safe Flutter navigation.

```dart
// Import target
import '../membership/membership_screen.dart';

// Callback change
onPressed: () {
  Navigator.push(
    context,
    MaterialPageRoute(builder: (context) => const MembershipScreen()),
  );
}
```

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit (Widget) | Transition to MembershipScreen | Write a widget test where `_AIBanner` button is tapped, verifying that `MembershipScreen` is pushed. |
| Unit (Widget) | Return from MembershipScreen | Verify popping `MembershipScreen` returns the user to the nutrition state. |

## Migration / Rollout

No database migration or backend changes are required.

## Open Questions

- None.
