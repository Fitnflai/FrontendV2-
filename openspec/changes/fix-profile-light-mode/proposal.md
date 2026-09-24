# Proposal: Fix Profile Light Mode

## Intent

Cleanly resolve the unreadable text inside the Premium Banner of the Profile Screen when Light Mode is active, ensuring a highly polished, elegant, and readable look in both themes.

## Scope

### In Scope
- Modifying the `_PremiumBanner` layout and styling inside `lib/screens/profile/profile_screen.dart`.
- Modifying the nested copy under `fitnflaifrontendv2/lib/screens/profile/profile_screen.dart` to prevent divergence (if both exist).

### Out of Scope
- Changing global theme definitions.
- Changing translation keys.
- Modifying payment or subscription flows.

## Capabilities

### New Capabilities
- None

### Modified Capabilities
- None (This is a pure UI/styling fix).

## Approach

- Determine current theme brightness via `Theme.of(context).brightness`.
- Apply a dual-theme premium gradient: soft green-orange in Light Mode, dark green-orange in Dark Mode.
- Set adaptive description text styling: `theme.greyLight` in Light Mode, existing light gray `Color(0xFFBBBBBB)` in Dark Mode.

## Affected Areas

| Area | Impact | Description |
|------|--------|-------------|
| `lib/screens/profile/profile_screen.dart` | Modified | `_PremiumBanner` styling adaptation |
| `fitnflaifrontendv2/lib/screens/profile/profile_screen.dart` | Modified | Syncing nested copy (if exists) |

## Risks

| Risk | Likelihood | Mitigation |
|------|------------|------------|
| Contrast issues on custom theme overrides | Low | Rely directly on `Theme.of(context).brightness` to dynamically dictate contrast values. |

## Rollback Plan

Revert `_PremiumBanner` class to the previous git commit state in `lib/screens/profile/profile_screen.dart`.

## Dependencies

- None

## Success Criteria

- [ ] Premium banner text is perfectly readable and elegant in Light Mode.
- [ ] Premium banner text remains perfectly readable and elegant in Dark Mode.
- [ ] Changes do not affect broader theme settings.
