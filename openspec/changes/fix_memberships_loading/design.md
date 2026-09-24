# Design: Fix Memberships Loading

## Technical Approach

To fix the infinite loading spinner on `MembershipScreen` caused by retrieving a null token, we will update how `token` is fetched on screen initialization. Instead of retrieving the token from `ProfileProvider`'s nested `profileData` (which is often null or uninitialized on entry, leading to `loadPlanes` not being invoked and leaving `planes` as null), we will fetch it directly from `AuthProvider`, which is the Single Source of Truth (SSOT) for auth session state.

If the retrieved token is null or empty, a safety fallback will trigger: logging a debug message and popping the screen safely to avoid trapping the user in an infinite spinner.

## Architecture Decisions

| Option | Tradeoff | Decision |
|--------|----------|----------|
| **Retrieve token from `AuthProvider` vs. `ProfileProvider`** | `ProfileProvider` relies on nested, potentially uninitialized `profileData?['token']`. `AuthProvider` maintains clean, direct access to the session token as the SSOT. | **Use `context.read<AuthProvider>().token`** to fetch the session token directly and reliably. |
| **Safely pop screen vs. showing inline error on Null Token** | Inline error requires UI updates for a fallback state that should never occur (since the screen is auth-only). Popping immediately and logging prevents infinite spinner hangs cleanly. | **Log error and pop the screen** via `Navigator.pop(context)` in `addPostFrameCallback` if token is missing. |

## Data Flow

    [MembershipScreen (initState)] ──(Reads Token)──→ [AuthProvider (SSOT)]
                 │                                            │
           (Token Valid)                                (Token Null/Empty)
                 │                                            │
                 ▼                                            ▼
      [ProfileProvider.loadPlanes]                    [debugPrint + Navigator.pop]
                 │
                 ▼
      [API GET /payments/planes]
                 │
                 ▼
     [Renders Membership Tiers]

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `lib/screens/membership/membership_screen.dart` | Modify | Update token retrieval to use `AuthProvider`, add safety callback fallback, and import `auth_provider.dart`. |

## Interfaces / Contracts

No new API endpoints or data models are introduced. The contract between `MembershipScreen` and `AuthProvider` is:

```dart
// lib/providers/auth_provider.dart
class AuthProvider with ChangeNotifier {
  String? get token => _token;
}
```

And in `lib/screens/membership/membership_screen.dart`:

```dart
import '../../providers/auth_provider.dart';

// Inside initState's post-frame callback:
final token = context.read<AuthProvider>().token;
```

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Integration | Token change compilation and flow safety | Verify screen compiles cleanly and `loadPlanes` is successfully triggered on transition when a valid token is present in `AuthProvider`. |
| Manual / UI | Authentication fallback handling | Emulate an empty/null token and verify that the screen pops gracefully with a logged error instead of getting stuck on an infinite loading spinner. |

## Migration / Rollout

No database migrations or feature flags required. This is a targeted hotfix for state retrieval.

## Open Questions

- None. The fix is self-contained and verified.
