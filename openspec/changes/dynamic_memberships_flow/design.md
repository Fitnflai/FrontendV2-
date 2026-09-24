# Design: Dynamic Memberships Flow

## Technical Approach

We will transform `MembershipScreen` from a static representation into a dynamic experience backed by the `/payments/planes` API. We will update `PaymentsService.changePlan` to pass the plan price ID as a query parameter (matching backend requirements), ensure `ProfileProvider` manages and exposes loading and error states cleanly, and make the bottom sheet checkout flow interactive with step-by-step API integration.

## Architecture Decisions

### Decision: Parameter Passing for Plan Changes

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Request Body JSON | Fails to match backend requirement. | Rejected |
| Query Parameter | Matches backend specification, requires empty/minimal body. | **Selected**: Pass `new_price_id` in URI query string, send empty `{}` JSON body. |

### Decision: Dynamic Benefit Mapping on View Layer

| Option | Tradeoff | Decision |
|--------|----------|----------|
| Static Benefit Lists | Fails to reflect changes in benefits from backend. | Rejected |
| Dynamic `beneficios` List | Robust, displays exact backend strings, uses a helper to categorize extra highlights. | **Selected**: Render benefits dynamically using a clean title-description layout. |

## Data Flow

```
[MembershipScreen] ──(initState: loadPlanes)──> [ProfileProvider] ──(GET /planes)──> [PaymentsService]
       │                                                                                   │
 (Selects Plan)                                                                      (Returns Planes)
       │                                                                                   │
       ▼                                                                                   ▼
[Checkout Bottom Sheet] ──(Taps Confirmar)──> [ProfileProvider] ──────────────(State: loading)
       │                                             │
       │                                   (simulatePurchase) ──(POST /simulate-purchase) ──→ API
       │                                             │
       │                                      (changePlan)    ──(POST /change-plan?new_price_id=...) ──→ API
       │                                             │
       ▼                                             ▼
[Success SnackBar & Pop] <──(onSuccess) <── (loadAll force:true) ──(GET /users/me) ──→ API
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `lib/services/payments_service.dart` | Modify | Update `changePlan` to accept query parameters and add robust body parsing. |
| `lib/providers/profile_provider.dart` | Modify | Ensure state fields and actions for purchase orchestration are robustly exposed. |
| `lib/screens/membership/membership_screen.dart` | Modify | Trigger plan fetch on load, listen to provider, and wire up the interactive bottom sheet sequence. |

## Interfaces / Contracts

### Payments Service Change
```dart
Future<Map<String, dynamic>> changePlan(String token, String priceId) async {
  final uri = Uri.parse('$_baseUrl/change-plan?new_price_id=$priceId');
  final response = await CachedHttp.post(
    uri,
    headers: _buildHeaders(token),
    body: json.encode({}),
  );
  _handleError(response, '$_baseUrl/change-plan');
  final responseBody = response.body.trim();
  if (responseBody.startsWith('{') || responseBody.startsWith('[')) {
    return json.decode(responseBody) as Map<String, dynamic>;
  } else {
    return {'message': responseBody};
  }
}
```

### Profile Provider Contract
- `List<dynamic>? get planes`
- `bool get isLoadingSubscription`
- `String? get subscriptionError`
- `Future<void> loadPlanes(String token)`
- `Future<bool> simulatePurchase(String token, String priceId)`
- `Future<bool> changePlan(String token, String priceId)`

### Dynamic Price Extraction (UI Helpers)
```dart
Map<String, dynamic>? _getPriceObj(Map<String, dynamic> plan, String freq) {
  final prices = plan['precios'] as List<dynamic>? ?? plan['prices'] as List<dynamic>?;
  if (prices == null) return null;
  return prices.firstWhere(
    (p) => p is Map<String, dynamic> && p['frecuencia']?.toString().toLowerCase() == freq,
    orElse: () => null,
  ) as Map<String, dynamic>?;
}
```

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| Unit | Price Extraction Helpers | Test extraction of monthly/annual price IDs and amounts with mock plan maps. |
| Integration | Checkout Flow Sequence | Verify `simulatePurchase` followed by `changePlan` executes correctly using mock HTTP client. |
| UI | Checkout Bottom Sheet States | Verify loading spinners, dynamic labels, error displays, and SNACKBAR triggers. |

## Migration / Rollout

No migration required. This is compile-safe and dynamically adapts to the backend payload.

## Open Questions

- None.
