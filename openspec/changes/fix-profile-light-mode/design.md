# Design: Fix Profile Premium Card Light Mode

## Technical Approach

We will resolve the unreadable text contrast of the `_PremiumBanner` widget in the Profile Screen when the application is switched to Light Mode. This will be accomplished by dynamically adapting both the background gradient and the description text color based on the current theme brightness using `Theme.of(context).brightness`. The change will keep the existing dark theme aesthetic completely untouched while rendering a beautiful, high-contrast, soft premium banner in Light Mode.

## Architecture Decisions

### Decision: Theme Brightness Evaluation Method

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Querying `Theme.of(context).brightness` | Highly reactive, standard, and optimized. Instantaneous and standard pattern in Flutter for local widget adaptability. | **Chosen** |
| Registering dedicated light/dark banner widgets | Redundant code replication; increases maintenance overhead for duplicate layouts. | Rejected |
| Using a global theme extension color for the gradient | Adds unnecessary configuration to `AppThemeExtension` for a single-use banner background. | Rejected |

### Decision: Text Styling Adaptability

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Branching Description color, leaving Title on `theme.white` | Simplest and most robust; leverages the fact that `theme.white` already maps to dark gray (`0xFF151515`) in Light Mode, and only branches the hardcoded description color (`0xFFBBBBBB`) to `theme.greyLight` (`0xFF616161`). | **Chosen** |
| Dynamic theme-independent styling | Breaks custom light/dark design intentions; can result in poor contrast under subtle layout shifts. | Rejected |

## Data Flow

The `_PremiumBanner` queries the ambient `BuildContext` to read the active `Theme` brightness. When the theme is switched, a repaint is triggered automatically, and the UI adapts on the next frame.

```
[System/App Theme Toggle] ──(Notifies)──→ [ProfileScreen / BuildContext]
                                                    │
                                                    ▼
                                            [_PremiumBanner]
                                                    │
                      ┌─────────────────────────────┴─────────────────────────────┐
                      ▼                                                           ▼
             [Brightness.dark]                                           [Brightness.light]
      - Gradient: Dark Green-Orange                               - Gradient: Soft Green-Orange
      - Title: White (0xFFFFFFFF)                                 - Title: Dark Gray (0xFF151515)
      - Desc: Hardcoded Grey (0xFFBBBBBB)                         - Desc: greyLight (0xFF616161)
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `lib/screens/profile/profile_screen.dart` | Modify | Update `_PremiumBanner` background gradient and text color styling based on dynamic brightness. |
| `fitnflaifrontendv2/lib/screens/profile/profile_screen.dart` | Modify | Apply the exact same changes to the nested project copy to keep them perfectly in sync. |

## Interfaces / Contracts

The dynamic styles are evaluated inside the `build` method of `_PremiumBanner`.

### Structure of `_PremiumBanner` Build Method

The `_PremiumBanner` is a stateless widget that builds a root `Container` with dynamic decoration, holding a `Row` composed of a two-row text block (`Column`) and a crown emoji (`👑`):

```dart
@override
Widget build(BuildContext context) {
  final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
  final l10n  = AppLocalizations.of(context);
  
  final isDarkMode = Theme.of(context).brightness == Brightness.dark;

  // Dynamic LinearGradient colors
  final gradientColors = isDarkMode
      ? const [Color(0xFF1A4A2E), Color(0xFF3A1A0A)]
      : const [Color(0xFFE8F5E9), Color(0xFFFFE0B2)];

  // Dynamic Description Text color
  // Dark mode retains the exact hardcoded Color(0xFFBBBBBB).
  // Light mode resolves contrast issues by using theme.greyLight (Color(0xFF616161)).
  final descColor = isDarkMode 
      ? const Color(0xFFBBBBBB) 
      : theme.greyLight;

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(18),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(14),
      gradient: LinearGradient(
        colors: gradientColors,
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
      ),
      border: Border.all(color: theme.primary.withValues(alpha: 0.3)),
    ),
    child: Row(children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          // Title text uses theme.white which automatically evaluates to 
          // Color(0xFFFFFFFF) in Dark Mode and Color(0xFF151515) in Light Mode
          Text(l10n.profilePremiumTitle(nombre),
              style: TextStyle(
                  color: theme.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 6),
          // Description text branches based on theme brightness to solve readability
          Text(
            l10n.profilePremiumDesc,
            style: TextStyle(
                color: descColor, 
                fontSize: 12, 
                height: 1.4)),
          const SizedBox(height: 12),
          // ... Navigation buttons
        ]),
      ),
      const SizedBox(width: 12),
      const Text('👑', style: TextStyle(fontSize: 40)),
    ]),
  );
}
```

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit (Widget) | Dark Mode Renders | Render `_PremiumBanner` under Dark theme, verifying that colors and gradients match the dark specification. |
| Unit (Widget) | Light Mode Renders | Render `_PremiumBanner` under Light theme, verifying that colors and gradients match the light specification. |

## No Performance Regressions

Checking `Theme.of(context).brightness` is highly optimized in Flutter. This is because standard `InheritedWidget` subscriptions register a dynamic dependency that only triggers a rebuild on the exact frame the theme changes, completely bypassing extra layout passes, layout calculation, or expensive graphics rendering cycles.

## Migration / Rollout

No database, feature flags, or API migrations are required.

## Open Questions

- None.
