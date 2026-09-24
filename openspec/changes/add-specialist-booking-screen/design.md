# Design: Add Specialist Booking Screen

## Technical Approach
Implement a gated access point inside `ProfileScreen` that checks if the active membership tier contains the keyword 'elite'. When true, users are shown an option to navigate to the new `SpecialistBookingScreen` using standard `Navigator.push`. The `SpecialistBookingScreen` is a zero-dependency screen displaying a specialist bio and credential header, an interactive custom date grid (up to 30 days in the future), and a selection of available 45-minute slots. Selecting a slot enables a checkout CTA, which triggers the stateful `_BookingCheckoutSheet` bottom sheet. This sheet simulates checkout, processing, and payment of a $19.99 flat-rate appointment, followed by a success confirmation dialog.

## Architecture Decisions

| Option | Tradeoff | Decision |
| :--- | :--- | :--- |
| **Gating Logic Location** | Checking `Usuario` model only vs Checking `ProfileProvider` plan data vs Check both. | **Combined Model + Provider Check**: Check `nombrePlanActivo` in `Usuario` and the active plan description in `ProfileProvider` for robust, up-to-date validation. |
| **Calendar Engine** | Standard third-party library (`table_calendar`) vs Custom interactive date grid. | **Custom GridView + ListView**: A custom lightweight, interactive date grid is highly tailorable, keeps dependencies at zero, avoids bundle bloat, and aligns with custom Material 3 extensions. |
| **Checkout UI Integration** | Reusing `MembershipScreen` sheet directly vs Dedicated isolated modal bottom sheet. | **Dedicated `_BookingCheckoutSheet` widget**: Mimics the membership flow's visual design while isolating the specialist checkout state, keeping transaction flows independent. |

## Data Flow
```
[ProfileScreen] (Checks plan contains 'elite') 
       │ (OnTap -> Navigator.push)
       ▼
[SpecialistBookingScreen] 
       │ 1. Renders specialist bio & credentials via _SpecialistHeader
       │ 2. Custom date-grid (GridView) + time slots list (ListView)
       │ 3. State tracking for selectedDate and selectedTime
       │ 4. "Schedule Appointment" CTA enabled on valid selection
       ▼
[_BookingCheckoutSheet] (Modal Bottom Sheet via showModalBottomSheet)
       │ 1. Step 1 (Confirm): Details, flat-rate $19.99, disclaimer, Confirm Button
       │ 2. Step 2 (Process): Simulate payment via ProfileProvider
       ▼
[BookingSuccessDialog] (Success animation / Check icon, triggers DB state update)
```

## File Changes

| File | Action | Description |
|------|--------|-------------|
| `lib/screens/profile/profile_screen.dart` | Modify | Conditionally render the Specialist Booking menu item within profile section groups. |
| `lib/screens/specialist_booking/specialist_booking_screen.dart` | Create | Introduce the full booking view comprising structural sub-widgets and checkout sheets. |
| `lib/l10n/app_en.arb` | Modify | Append English localized keys for specialist biography, calendar headers, and checkout flow. |
| `lib/l10n/app_es.arb` | Modify | Append Spanish localized keys for specialist biography, calendar headers, and checkout flow. |

## Interfaces / Contracts

```dart
// Location: lib/screens/specialist_booking/specialist_booking_screen.dart

class SpecialistBookingScreen extends StatefulWidget {
  const SpecialistBookingScreen({super.key});

  @override
  State<SpecialistBookingScreen> createState() => _SpecialistBookingScreenState();
}

class _SpecialistHeader extends StatelessWidget {
  const _SpecialistHeader();

  @override
  Widget build(BuildContext context) { ... }
}

class _BookingCalendar extends StatelessWidget {
  final DateTime selectedDate;
  final String? selectedTime;
  final ValueChanged<DateTime> onDateSelected;
  final ValueChanged<String> onTimeSelected;

  const _BookingCalendar({
    required this.selectedDate,
    required this.selectedTime,
    required this.onDateSelected,
    required this.onTimeSelected,
  });

  @override
  Widget build(BuildContext context) { ... }
}

class _BookingCheckoutSheet extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedTime;

  const _BookingCheckoutSheet({
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<_BookingCheckoutSheet> createState() => _BookingCheckoutSheetState();
}
```

## ARB Translations

### `lib/l10n/app_en.arb`
```json
  "specialistBookingMenuTitle": "Specialist Booking",
  "scheduleAppointmentBtn": "Schedule Appointment",
  "checkoutSessionTitle": "Specialist Session (45 min)",
  "confirmPaymentBtn": "Confirm Payment",
  "bookingSuccessTitle": "Booking Confirmed",
  "specialistHeaderTitle": "Your Specialist",
  "specialistName": "Dr. Alex Rivera",
  "specialistCredential": "Elite Health & Biomechanics Coach",
  "specialistBio": "Certified expert in athletic biomechanics, elite nutrition, and recovery protocols with 10+ years coaching professionals.",
  "calendarSelectDate": "Select Date",
  "calendarSelectTime": "Available Times",
  "checkoutPriceLabel": "Flat Rate",
  "bookingSuccessMessage": "Your elite appointment has been scheduled! Check your inbox for confirmation details."
```

### `lib/l10n/app_es.arb`
```json
  "specialistBookingMenuTitle": "Reserva con Especialista",
  "scheduleAppointmentBtn": "Programar Cita",
  "checkoutSessionTitle": "Sesión con Especialista (45 min)",
  "confirmPaymentBtn": "Confirmar Pago",
  "bookingSuccessTitle": "Reserva Confirmada",
  "specialistHeaderTitle": "Tu Especialista",
  "specialistName": "Dr. Alex Rivera",
  "specialistCredential": "Entrenador Élite de Biomecánica y Salud",
  "specialistBio": "Experto certificado en biomecánica deportiva, nutrición élite y protocolos de recuperación con más de 10 años de experiencia.",
  "calendarSelectDate": "Seleccionar Fecha",
  "calendarSelectTime": "Horarios Disponibles",
  "checkoutPriceLabel": "Tarifa Plana",
  "bookingSuccessMessage": "¡Tu cita de élite ha sido programada! Revisa tu bandeja de entrada para ver los detalles de confirmación."
```

## Theme Styling
To ensure dynamic compliance with Light and Dark modes, colors are mapped to `context.themeColors` using `GlobalThemeContextExt` from `app_theme_extension.dart`:

| Component | Color Variable | Light Mode | Dark Mode |
| :--- | :--- | :--- | :--- |
| **Main Background** | `context.themeColors.bg` | Clean Light Grey | Pitch Black / Dark Blue |
| **Header & Cards** | `context.themeColors.card` | Pure White | Elevated Charcoal |
| **Inner Box / Fields** | `context.themeColors.cardDark` | Soft Off-White | Dark Card Inset |
| **Primary Accent / CTA**| `context.themeColors.primary` | Orange (Brand Accent) | Orange (Brand Accent) |
| **Main Typography** | `context.themeColors.text` | Charcoal Black | Premium White |
| **Secondary Subtitles**| `context.themeColors.textSecondary` | Mid Grey | Soft Silver |
| **Active Calendar Day** | Bg: `primary` / Text: `white` | Orange / White | Orange / White |
| **Inactive Day / Grid** | Bg: `card` / Text: `textSecondary`| Off-White / Mid Grey | Charcoal / Soft Silver |
| **Borders & Dividers** | `context.themeColors.border` | Very Light Grey | Hard Charcoal |

## Testing Strategy

| Layer | What to Test | Approach |
|-------|-------------|----------|
| **Unit** | Subscription check utility | Validate plan names containing "elite" allow entry, while "essential" and "pro" block navigation. |
| **Integration** | End-to-end booking flow | Click Specialist Booking -> Select Day -> Select Time -> Tapping "Schedule" opens bottom sheet -> Complete simulation checkout. |
| **Widget** | Adaptive theme verification | Ensure text, active calendar days, time slots, and sheets repaint correctly under Light and Dark theme modes. |

## Migration / Rollout
No database schema or state model migrations are required. The feature is completely dynamic and gated at run-time based on the local caches of `Usuario.nombrePlanActivo` and `ProfileProvider.planActivo`.

## Open Questions
- None.
