import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme_extension.dart';
import 'package:intl/intl.dart'; // Added for DateFormat
import '../../l10n/app_localizations.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/specialist_selection_bottom_sheet.dart';
import '../../providers/profile_provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/specialist_provider.dart';
import '../membership/membership_screen.dart';
import '../../models/specialist.dart';



class SpecialistBookingScreen extends StatefulWidget {
  const SpecialistBookingScreen({super.key});

  @override
  State<SpecialistBookingScreen> createState() => _SpecialistBookingScreenState();
}

class _SpecialistBookingScreenState extends State<SpecialistBookingScreen> {
  DateTime _selectedDate = DateTime.now();
  String? _selectedTime;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadAssignedSpecialist();
      _fetchInitialAvailability(); // Renamed function
    });
  }

  Future<void> _loadAssignedSpecialist() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final specialistProvider = context.read<SpecialistProvider>();

    final token = authProvider.token;
    final specialistId = profileProvider.profileData?['id_especialista'];

    if (token != null && specialistId != null) {
      await specialistProvider.loadAssignedSpecialist(token, _tryParseInt(specialistId)!);
      // Load specialist availability after assigned specialist is loaded
      await _fetchInitialAvailability(); // Renamed function
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themeColors;
    final isBookingEnabled = _selectedTime != null;


    return Consumer<AuthProvider>(
      builder: (context, authProvider, _) {
        final profileProvider = context.watch<ProfileProvider>();
        final planName = (profileProvider.planActivo?['nombre'] as String?)?.toLowerCase() ?? '';
        final bool isElite = authProvider.user?.isElite == true ||
            planName.contains('elite') || planName.contains('élite');

        if (!isElite) {
          return Scaffold(
            backgroundColor: theme.bg,
            appBar: FitnflaiAppBar(title: l10n.specialistBookingTitle),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.workspace_premium, size: 80, color: theme.orange),
                    const SizedBox(height: 24),
                    Text(
                      l10n.specialistBookingEliteRequiredTitle,
                      style: TextStyle(color: theme.text, fontSize: 22, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.specialistBookingEliteRequiredDesc,
                      style: TextStyle(color: theme.textSecondary, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          final authProvider = context.read<AuthProvider>();
                          final profileProvider = context.read<ProfileProvider>();
                          final token = authProvider.token;

                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => const MembershipScreen()),
                          ).then((_) {
                            if (!mounted) return;
                            if (token != null) {
                              profileProvider.loadAll(token, force: true).then((_) {
                                if (!mounted) return;
                                _loadAssignedSpecialist();
                              });
                            }
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.orange,
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          l10n.specialistBookingUpgradeBtn,
                          style: TextStyle(color: theme.white, fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        return Consumer<SpecialistProvider>(
          builder: (context, specialistProvider, child) {
            final bool isSpecialistAssigned = specialistProvider.assignedSpecialist != null;
            return Scaffold(

              backgroundColor: theme.bg,
              appBar: FitnflaiAppBar(title: l10n.specialistBookingTitle),
              body: Stack(
                children: [
                  SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 100), // Add padding for the button
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _SpecialistHeader(
                          theme: theme,
                          l10n: l10n,
                          specialist: specialistProvider.assignedSpecialist,
                          isLoading: specialistProvider.isLoadingAssigned,
                          errorMessage: specialistProvider.errorMessage,
                          onSelectSpecialist: () => _showSpecialistSelectionSheet(context),
                          onRetry: _loadAssignedSpecialist,
                        ),
                        const SizedBox(height: 24),

                        if (isSpecialistAssigned) ...[
                          Text(
                            l10n.specialistBookingSelectDate,
                            style: TextStyle(color: theme.text, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildDateSelector(theme, l10n, isSpecialistAssigned),
                          const SizedBox(height: 24),

                          Text(
                            l10n.specialistBookingSelectTime,
                            style: TextStyle(color: theme.text, fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 16),
                          _buildTimeSlots(theme, l10n, isSpecialistAssigned),
                        ] else ...[
                          // Display a message or disable the selection if no specialist is assigned
                          // This is implicitly handled by the _SpecialistHeader, but we ensure the selectors are gone.
                          const SizedBox.shrink(),
                        ],
                      ],
                    ),
                  ),
                  _buildScheduleButton(theme, l10n, isBookingEnabled && isSpecialistAssigned),
                ],
              ),
            );
          },
        );
      },
    );
  }

  void _showSpecialistSelectionSheet(BuildContext context) async {
    final specialistProvider = context.read<SpecialistProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final authProvider = context.read<AuthProvider>();

    final userDiscipline = profileProvider.profileData?['nombreDisciplina'] as String?;
    final planNamePreload = (profileProvider.planActivo?['nombre'] as String?)?.toLowerCase() ?? '';
    final bool isEliteUserPreload = (authProvider.user?.isElite == true) ||
        planNamePreload.contains('elite') || planNamePreload.contains('élite');

    // Ensure specialists are loaded before showing the sheet
    if (specialistProvider.specialists.isEmpty) {
      await specialistProvider.loadAndFilter(authProvider.token!, isEliteUserPreload ? null : userDiscipline);
    }

    if (!context.mounted) return;
    final selected = await showModalBottomSheet<Specialist?>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext ctx) {
        return ChangeNotifierProvider.value(
          value: specialistProvider,
          child: SpecialistSelectionBottomSheet(initialSpecialist: specialistProvider.assignedSpecialist,),
        );
      },
    );

    if (selected != null) {
      if (!mounted) return;
      // Assuming the API call to update the assigned specialist is successful
      // Trigger profile reload to get the updated id_especialista
      // And then reload the assigned specialist in this screen
      await profileProvider.loadAll(authProvider.token!, force: true);
      await _loadAssignedSpecialist();
    }
  }

  Widget _buildDateSelector(AppThemeExtensionWrapper theme, AppLocalizations l10n, bool isEnabled) {
    final today = DateTime.now();
    return SizedBox(
      height: 80,
      child: ListView.builder(
        key: const Key('date_selector_list_view'),
        scrollDirection: Axis.horizontal,
        itemCount: 30, // 30 days from today
        itemBuilder: (context, index) {
          final date = today.add(Duration(days: index));
          final isSelected = date.day == _selectedDate.day && date.month == _selectedDate.month && date.year == _selectedDate.year;

          return GestureDetector(
            onTap: isEnabled ? () {
              setState(() {
                _selectedDate = date;
                _selectedTime = null; // Clear selected time when date changes
              });
              context.read<SpecialistProvider>().filterAvailabilityForDate(DateTime(date.year, date.month, date.day));
            } : null,
            key: Key('date_selector_${date.year}-${date.month}-${date.day}'),
            child: Container(
              width: 60,
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: isSelected ? theme.orange : theme.card,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: isSelected ? theme.orange : theme.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _getShortDayName(date, l10n.localeName), // Short day name
                    style: TextStyle(
                      color: isSelected ? theme.white : theme.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date.day.toString(),
                    style: TextStyle(
                      color: isSelected ? theme.white : theme.text,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildTimeSlots(AppThemeExtensionWrapper theme, AppLocalizations l10n, bool isEnabled) {
    return Consumer<SpecialistProvider>(
      builder: (context, specialistProvider, child) {
        if (!isEnabled) {
          return const SizedBox.shrink(); // Hide time slots if not enabled
        }
        
        if (specialistProvider.isAvailabilityLoading) {
          return Center(
            child: CircularProgressIndicator(color: theme.orange),
          );
        }

        if (specialistProvider.availabilityErrorMessage != null) {
          return Center(
            child: Text(
              specialistProvider.availabilityErrorMessage!,
              style: TextStyle(color: theme.redText),
              textAlign: TextAlign.center,
            ),
          );
        }

        final assignedSpecialist = specialistProvider.assignedSpecialist;
        if (assignedSpecialist == null) {
          // If no specialist assigned, no slots to show. This state should be handled by _SpecialistHeader
          return const SizedBox.shrink();
        }

        if (specialistProvider.specialistAvailability.isEmpty) {
          return Center(
            child: Text(
              l10n.specialistBookingNo30DayAvailability,
              style: TextStyle(color: theme.textSecondary),
              textAlign: TextAlign.center,
            ),
          );
        }

        final availableSlots = specialistProvider.filteredAvailability;
        if (availableSlots.isEmpty) {
          return Center(
            child: Text(
              l10n.specialistBookingNoSlotsForSelectedDate,
              style: TextStyle(color: theme.textSecondary),
              textAlign: TextAlign.center,
            ),
          );
        }

        return Wrap(
          spacing: 10,
          runSpacing: 10,
          children: availableSlots.map((turno) {
            final time = turno.horaInicio.substring(0, 5); // Format HH:MM from HH:MM:SS
            final isSelected = _selectedTime == time;
            final isAvailable = turno.estado == 'disponible'; // Check the status from the Turno object

            return GestureDetector(
              onTap: isAvailable && isEnabled
                  ? () {
                      setState(() {
                        _selectedTime = turno.horaInicio; // Store full time string
                      });
                    }
                  : null, // Disable onTap if not available or not enabled
              child: Container(
                width: 80, // Adjust width as needed
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                decoration: BoxDecoration(
                  color: isSelected
                      ? theme.orange
                      : isAvailable
                          ? theme.card
                          : theme.border, // Different color for unavailable slots
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                      color: isSelected
                          ? theme.orange
                          : isAvailable
                                ? theme.border
                                : theme.textSecondary.withValues(alpha: 0.5)),
                ),
                child: Center(
                  child: Text(
                    time,
                    style: TextStyle(
                      color: isSelected
                          ? theme.white
                          : isAvailable
                                ? theme.text
                                : theme.textSecondary.withValues(alpha: 0.7),
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      decoration: isAvailable ? TextDecoration.none : TextDecoration.lineThrough,
                      decorationColor: theme.textSecondary,
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        );
      },
    );
  }


  Widget _buildScheduleButton(AppThemeExtensionWrapper theme, AppLocalizations l10n, bool isEnabled) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.bg,
          boxShadow: [
            BoxShadow(
              color: theme.bg.withValues(alpha: 0.5),
              spreadRadius: 5,
              blurRadius: 7,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: isEnabled
              ? () async {
                  final result = await showModalBottomSheet<bool>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    isScrollControlled: true,
                    builder: (BuildContext ctx) {
                      return _CheckoutBottomSheet(
                        selectedDate: _selectedDate,
                        selectedTime: _selectedTime!,
                      );
                    },
                  );
                  if (result == true && mounted) {
                    _showSuccessDialog(l10n, theme);
                  }
                }
              : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: theme.orange,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text(
            l10n.specialistBookingConfirmBtn,
            style: TextStyle(
              color: theme.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _fetchInitialAvailability() async { // Renamed function
    final specialistProvider = context.read<SpecialistProvider>();
    final authProvider = context.read<AuthProvider>();

    final token = authProvider.token;
    final assignedSpecialist = specialistProvider.assignedSpecialist;

    if (token != null && assignedSpecialist != null) {
      final now = DateTime.now();
      final startDate = DateTime(now.year, now.month, now.day);
      final endDate = startDate.add(const Duration(days: 29));

      await specialistProvider.fetchAvailability(token, startDate, endDate);
      specialistProvider.filterAvailabilityForDate(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day));

      if (mounted) {
        setState(() {
          _selectedTime = null;
        });
      }
    } else if (assignedSpecialist == null) {
      debugPrint('No assigned specialist found to load availability for.');
      specialistProvider.filterAvailabilityForDate(DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day));
      if (mounted) {
        setState(() {
          _selectedTime = null;
        });
      }
    }
  }

  String _getShortDayName(DateTime date, String locale) {
    // Use DateFormat from intl package for proper localization
    return DateFormat('EEE', locale).format(date); // e.g., 'Mon', 'Lun'
  }

  int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  String _formatFecha(DateTime dt, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    // Use DateFormat for month names as well
    return DateFormat.yMMMd(l10n.localeName).format(dt); // e.g., 'Sep 9, 2026' or '9 sept. 2026'
  }
  
  void _showSuccessDialog(AppLocalizations l10n, AppThemeExtensionWrapper theme) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext ctx) {
        return AlertDialog(
          backgroundColor: theme.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '🎉',
                style: TextStyle(fontSize: 50),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.specialistBookingSuccessTitle,
                style: TextStyle(
                  color: theme.text,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                l10n.specialistBookingSuccessDesc(
                  _formatFecha(_selectedDate, context),
                  _selectedTime!,
                ),

                style: TextStyle(color: theme.textSecondary, fontSize: 15),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (!ctx.mounted) return; // Guard against context use after async gap
                    Navigator.pop(ctx); // Close the dialog
                    if (!context.mounted) return; // Guard against context use after async gap
                    Navigator.pop(context); // Navigate back to Profile screen
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.orange,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    l10n.specialistBookingSuccessClose,
                    style: TextStyle(
                      color: theme.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _CheckoutBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final String selectedTime;

  const _CheckoutBottomSheet({
    required this.selectedDate,
    required this.selectedTime,
  });

  @override
  State<_CheckoutBottomSheet> createState() => _CheckoutBottomSheetState();
}

class _CheckoutBottomSheetState extends State<_CheckoutBottomSheet> with WidgetsBindingObserver {
  int _checkoutStep = 1;
  bool _isProcessingVerification = false;
  bool _isLoading = false;
  String? _selectedCardId;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadSavedCards();
    });
  }

  Future<void> _loadSavedCards() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final token = authProvider.token;
    if (token != null) {
      await profileProvider.loadSavedCards(token);
      if (profileProvider.savedCards.isNotEmpty && mounted) {
        setState(() {
          _selectedCardId = profileProvider.savedCards.first.id;
        });
      }
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _checkoutStep == 2 && !_isProcessingVerification) {
      _verifyAndBook();
    }
  }

  String _buildIsoDateTimeString(DateTime date, String timeSlot) {
    final parts = timeSlot.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final combined = DateTime(date.year, date.month, date.day, hour, minute);
    return combined.toUtc().toIso8601String();
  }

  String _formatFecha(DateTime dt, BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return DateFormat.yMMMd(l10n.localeName).format(dt);
  }

  int? _tryParseInt(dynamic value) {
    if (value == null) return null;
    if (value is int) return value;
    if (value is num) return value.toInt();
    if (value is String) return int.tryParse(value);
    return null;
  }

  Future<void> _verifyAndBook() async {
    if (_isProcessingVerification) return;

    setState(() {
      _isProcessingVerification = true;
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final specialistProvider = context.read<SpecialistProvider>();
    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final token = authProvider.token;
    final specialistId = specialistProvider.assignedSpecialist?.id ?? _tryParseInt(profileProvider.profileData?['id_especialista']);
    final idSeguimiento = _tryParseInt(profileProvider.profileData?['id_seguimiento_especialista']) ?? _tryParseInt(profileProvider.profileData?['id_seguimiento']);

    if (token == null || specialistId == null || idSeguimiento == null) {
      if (mounted) {
        setState(() {
          _isProcessingVerification = false;
          _isLoading = false;
        });
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(l10n.specialistBookingErrorMissingData)),
        );
      }
      return;
    }

    try {
      bool bookingSuccess = await specialistProvider.solicitarCita(
        token,
        idEspecialista: specialistId,
        idSeguimiento: idSeguimiento,
        fechaHora: _buildIsoDateTimeString(widget.selectedDate, widget.selectedTime),
        esExpress: true,
        descripcionCita: l10n.specialistBookingDefaultDescription,
        tipoCita: "online",
      );

      if (bookingSuccess) {
        try {
          await profileProvider.loadAll(token, force: true);
        } catch (e) {
          debugPrint('Error reloading profile after booking: $e');
        }
        if (mounted) Navigator.pop(context, true);
      }
    } catch (e) {
      debugPrint('Error during booking verification: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessingVerification = false;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _chargeWithSavedCardLocal() async {
    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final specialistProvider = context.read<SpecialistProvider>();
    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    // Capture size and locale BEFORE async gap to avoid linter warnings
    final size = MediaQuery.of(context).size;
    final locale = Localizations.localeOf(context).languageCode;

    final token = authProvider.token;
    final idSeguimiento = _tryParseInt(profileProvider.profileData?['id_seguimiento_especialista']) ??
        _tryParseInt(profileProvider.profileData?['id_seguimiento']);

    if (token == null || idSeguimiento == null || _selectedCardId == null) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.specialistBookingErrorMissingData)),
      );
      return;
    }

    // Show Dialog to collect CVV / CVC
    final TextEditingController cvvController = TextEditingController();
    final bool? confirmed = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        String? localError;
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: const Color(0xFF1E1E1E),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              title: const Text(
                'Confirmación de Seguridad',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Por motivos de seguridad, ingresá el código de verificación (CVV) de tu tarjeta guardada.',
                    style: TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: 120,
                    child: TextField(
                      controller: cvvController,
                      keyboardType: TextInputType.number,
                      obscureText: true,
                      maxLength: 4,
                      style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 8, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                      decoration: InputDecoration(
                        hintText: '•••',
                        hintStyle: const TextStyle(color: Colors.grey, fontSize: 20, letterSpacing: 8),
                        counterText: '',
                        errorText: localError,
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Colors.orange, width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              actionsAlignment: MainAxisAlignment.spaceEvenly,
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(dialogContext, false),
                  child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                ),
                TextButton(
                  onPressed: () {
                    final cvv = cvvController.text.trim();
                    final isNumeric = RegExp(r'^\d+$').hasMatch(cvv);
                    if (cvv.length < 3 || cvv.length > 4 || !isNumeric) {
                      setDialogState(() {
                        localError = 'CVV inválido';
                      });
                      return;
                    }
                    Navigator.pop(dialogContext, true);
                  },
                  child: const Text('Confirmar', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    final cvv = cvvController.text.trim();

    // Collect device/browser properties for Nuvei security
    final extraData = {
      'device_type': 'mobile',
      'reference_id': DateTime.now().millisecondsSinceEpoch.toString(),
      'ip': '127.0.0.1', // Placeholder IP, backend overrides with connection IP
      'language': locale,
      'java_enabled': false,
      'js_enabled': true,
      'color_depth': 24,
      'screen_height': size.height.toInt(),
      'screen_width': size.width.toInt(),
      'timezone_offset': DateTime.now().timeZoneOffset.inMinutes,
      'user_agent': 'Mozilla/5.0 (iPhone; CPU iPhone OS 15_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile/15E148',
      'accept_header': 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8',
    };

    try {
      final success = await specialistProvider.payMeetingSpecialistOneClick(
        token,
        idSeguimiento,
        cvc: cvv,
        extraData: extraData,
      );

      if (success) {
        await _verifyAndBook();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(specialistProvider.directChargeErrorMessage ?? 'Error al procesar el cobro.')),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _initiatePaymentLocal() async {
    setState(() {
      _isLoading = true;
    });

    final authProvider = context.read<AuthProvider>();
    final profileProvider = context.read<ProfileProvider>();
    final specialistProvider = context.read<SpecialistProvider>();
    final l10n = AppLocalizations.of(context);
    final scaffoldMessenger = ScaffoldMessenger.of(context);

    final token = authProvider.token;
    final specialistId = specialistProvider.assignedSpecialist?.id ??
        _tryParseInt(profileProvider.profileData?['id_especialista']);
    final idSeguimiento = _tryParseInt(profileProvider.profileData?['id_seguimiento_especialista']) ??
        _tryParseInt(profileProvider.profileData?['id_seguimiento']);

    if (token == null || specialistId == null || idSeguimiento == null) {
      setState(() {
        _isLoading = false;
      });
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(l10n.specialistBookingErrorMissingData)),
      );
      return;
    }

    try {
      await specialistProvider.initiatePaymentFlow(token, idSeguimiento, 'fitnflai://nuvei_redirect');

      final checkoutUrl = specialistProvider.checkoutUrl;
      if (checkoutUrl != null) {
        final uri = Uri.parse(checkoutUrl);
                                if (await canLaunchUrl(uri)) {
                                  await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
                                  setState(() {
                                    _checkoutStep = 2;
                                    _isLoading = false;
                                  });
                                } else {
          scaffoldMessenger.showSnackBar(
            SnackBar(content: Text(specialistProvider.paymentErrorMessage ?? 'No se pudo abrir la pasarela de pagos.')),
          );
          setState(() {
            _isLoading = false;
          });
        }
      } else {
        scaffoldMessenger.showSnackBar(
          SnackBar(content: Text(specialistProvider.paymentErrorMessage ?? 'Error al inicializar el pago.')),
        );
        setState(() {
          _isLoading = false;
        });
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(
        SnackBar(content: Text(specialistProvider.paymentErrorMessage ?? l10n.specialistBookingGenericError)),
      );
      setState(() {
        _isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themeColors;
    final profileProvider = context.watch<ProfileProvider>();
    final specialistProvider = context.watch<SpecialistProvider>();
    final BookingStatus bookingStatus = specialistProvider.bookingStatus;

    final String? paymentErrorMessage = specialistProvider.paymentErrorMessage;


    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: theme.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          // Title
          Text(
            l10n.specialistBookingCheckoutTitle,
            style: TextStyle(color: theme.text, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          if (_checkoutStep == 1) ...[
            // Transaction Card Details (existing UI)
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.cardDark,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.border),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.specialistBookingCheckoutSummary,
                        style: TextStyle(color: theme.text, fontSize: 16),
                      ),
                      Text(
                        r"\$19.99",
                        style: TextStyle(color: theme.orange, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Divider(color: theme.border, height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.specialistBookingSelectDate,
                        style: TextStyle(color: theme.text, fontSize: 16),
                      ),
                      Text(
                        _formatFecha(widget.selectedDate, context),
                        style: TextStyle(color: theme.text, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        l10n.specialistBookingSelectTime,
                        style: TextStyle(color: theme.text, fontSize: 16),
                      ),
                      Text(
                        widget.selectedTime,
                        style: TextStyle(color: theme.text, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Consumer<ProfileProvider>(
              builder: (context, profileProvider, child) {
                if (profileProvider.isLoadingCards) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16.0),
                      child: CircularProgressIndicator(color: theme.orange, strokeWidth: 2),
                    ),
                  );
                }
                if (profileProvider.savedCards.isEmpty) {
                  return const SizedBox.shrink();
                }

                // Auto-select the first card if none is selected yet
                if (_selectedCardId == null && profileProvider.savedCards.isNotEmpty) {
                  _selectedCardId = profileProvider.savedCards.first.id;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.localeName == 'es' ? 'Método de pago guardado' : 'Saved Payment Method',
                      style: TextStyle(color: theme.text, fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: profileProvider.savedCards.length,
                      itemBuilder: (context, index) {
                        final card = profileProvider.savedCards[index];
                        final isSelected = _selectedCardId == card.id;

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCardId = card.id;
                            });
                          },
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: theme.cardDark,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: isSelected ? theme.orange : theme.border,
                                width: isSelected ? 2 : 1,
                              ),
                            ),
                            child: Row(
                              children: [
                                Icon(
                                  card.brand.toLowerCase() == 'visa' ? Icons.credit_card : Icons.credit_card_outlined,
                                  color: isSelected ? theme.orange : theme.textSecondary,
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        '${card.brand} **** ${card.lastFour}',
                                        style: TextStyle(
                                          color: theme.text,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        '${l10n.localeName == 'es' ? 'Vence' : 'Expires'}: ${card.expMonth}/${card.expYear}',
                                        style: TextStyle(
                                          color: theme.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (isSelected)
                                  Icon(Icons.check_circle, color: theme.orange)
                                else
                                  Icon(Icons.circle_outlined, color: theme.border),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                );
              },
            ),
            if (specialistProvider.directChargeErrorMessage != null) ...[
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  specialistProvider.directChargeErrorMessage!,
                  style: TextStyle(color: theme.redText, fontSize: 14, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
            const SizedBox(height: 24),
            // Checkout Confirm / Direct Pay Buttons
            if (profileProvider.savedCards.isNotEmpty) ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          _chargeWithSavedCardLocal();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading && specialistProvider.isDirectCharging
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: theme.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          l10n.localeName == 'es' ? 'Pagar con esta tarjeta' : 'Pay with this card',
                          style: TextStyle(
                            color: theme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          _initiatePaymentLocal();
                        },
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(color: theme.orange),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading && !specialistProvider.isDirectCharging
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: theme.orange,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          l10n.localeName == 'es' ? 'Pagar con otro medio' : 'Pay with another method',
                          style: TextStyle(
                            color: theme.orange,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ] else ...[
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading
                      ? null
                      : () async {
                          _initiatePaymentLocal();
                        },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(
                            color: theme.white,
                            strokeWidth: 2,
                          ),
                        )
                      : Text(
                          l10n.specialistBookingCheckoutConfirmBtn,
                          style: TextStyle(
                            color: theme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                ),
              ),
            ],
                  ] else if (_checkoutStep == 2) ...[
                    if (_isProcessingVerification || bookingStatus == BookingStatus.loading || bookingStatus == BookingStatus.idle) ...[
                      Column(
                        children: [
                          CircularProgressIndicator(color: theme.orange),
                          const SizedBox(height: 16),
                          Text(
                            _isProcessingVerification || bookingStatus == BookingStatus.loading
                                ? 'Confirmando tu pago de Nuvei... Por favor, esperá unos segundos.'
                                : 'Completá tu pago en la pasarela de Nuvei. Al volver, confirmaremos tu reserva automáticamente.',
                            style: TextStyle(color: theme.text, fontSize: 16),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ] else ...[

              if (bookingStatus == BookingStatus.paymentPending) ...[
                Column(
                  children: [
                    Text(
                      'Tu pago está pendiente de confirmación. Por favor, verificá manualmente o reintentá.',
                      style: TextStyle(color: theme.redText, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _isLoading
                            ? null
                            : () async {
                                _verifyAndBook();
                              },
                        child: Text('Verificar Pago y Reservar'),
                      ),
                    ),
                  ],
                ),
              ] else if (bookingStatus == BookingStatus.slotCollision) ...[
                Column(
                  children: [
                    Text(
                      'El turno ya no está disponible, pero tu pago fue exitoso. Podés cerrar este cuadro, seleccionar otro turno libre con el especialista gratis, o pedir reembolso.',
                      style: TextStyle(color: theme.orange, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context); // Close the bottom sheet
                        },
                        child: Text('Seleccionar otro turno'),
                      ),
                    ),
                  ],
                ),
              ] else if (bookingStatus == BookingStatus.error) ...[
                Column(
                  children: [
                    Text(
                      paymentErrorMessage ?? 'Hubo un error con tu reserva. Por favor, reintentá.',
                      style: TextStyle(color: theme.redText, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                         onPressed: _isLoading ? null : _initiatePaymentLocal,
                        child: Text('Reintentar'),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ],
        ],
      ),
    ),);
  }
}

class _SpecialistHeader extends StatelessWidget {
  final AppThemeExtensionWrapper theme;
  final AppLocalizations l10n;
  final Specialist? specialist;
  final bool isLoading;
  final String? errorMessage;
  final VoidCallback? onSelectSpecialist;
  final VoidCallback? onRetry;

  const _SpecialistHeader({
    required this.theme,
    required this.l10n,
    this.specialist,
    this.isLoading = false,
    this.errorMessage,
    this.onSelectSpecialist,
    this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    final bool isEs = l10n.localeName == 'es';
    // Removed isEs variable as l10n object handles locale for specific strings
    if (isLoading) {
      return Card(
        color: theme.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(color: theme.orange, strokeWidth: 2),
              ),
              const SizedBox(width: 16),
              Text(
                isEs ? 'Cargando especialista...' : 'Loading specialist...', // Fallback for specialistBookingLoadingSpecialist
                style: TextStyle(color: theme.text, fontSize: 16),
              ),
            ],
          ),
        ),
      );
    }

    if (errorMessage != null) {
      return Card(
        color: theme.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.redText),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEs ? 'Error al cargar especialista.' : 'Error loading specialist.', // Fallback for specialistBookingErrorLoadingSpecialist
                style: TextStyle(color: theme.redText, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Text(
                errorMessage!,
                style: TextStyle(color: theme.textSecondary, fontSize: 14),
              ),
              if (onRetry != null) ...[
                const SizedBox(height: 12),
                TextButton(
                  onPressed: onRetry,
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: Text(
                    isEs ? 'Reintentar' : 'Retry', // Fallback for specialistBookingRetry
                    style: TextStyle(color: theme.orange, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              if (onSelectSpecialist != null) ...[
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSelectSpecialist,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isEs ? 'Seleccionar Especialista' : 'Select Specialist', // Fallback for specialistBookingSelectSpecialist
                      style: TextStyle(color: theme.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    if (specialist == null) {
      return Card(
        color: theme.card,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: theme.border),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                l10n.specialistBookingNoSpecialist, // Using the new l10n key
                style: TextStyle(color: theme.text, fontSize: 16, fontWeight: FontWeight.bold),
              ),
              // Removed secondary text as per task.
              const SizedBox(height: 16), // Added padding for consistency
              if (onSelectSpecialist != null)
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: onSelectSpecialist,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.orange,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: Text(
                      isEs ? 'Seleccionar Especialista' : 'Select Specialist', // Fallback for specialistBookingSelectSpecialist
                      style: TextStyle(color: theme.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: theme.card,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: theme.border),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: theme.primary.withValues(alpha: 0.2),
              backgroundImage: specialist?.fotoUrl != null && specialist!.fotoUrl!.isNotEmpty
                  ? NetworkImage(specialist!.fotoUrl!) as ImageProvider
                  : null,
              child: specialist?.fotoUrl == null || specialist!.fotoUrl!.isEmpty
                  ? const Text(
                      '👩‍⚕️',
                      style: TextStyle(fontSize: 40),
                    )
                  : null,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    specialist!.nombre,
                    style: TextStyle(color: theme.text, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: theme.orange.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      l10n.specialistBookingDuration,
                      style: TextStyle(color: theme.orange, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    specialist!.especialidad ?? (isEs ? 'Especialista Élite' : 'Elite Specialist'), // Fallback for specialistBookingEliteSpecialist
                    style: TextStyle(color: theme.text, fontSize: 14, fontWeight: FontWeight.w500),
                  ),
                  if (specialist!.disciplinas.isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      isEs ? 'Disciplinas: ${specialist!.disciplinas.join(', ')}' : 'Disciplines: ${specialist!.disciplinas.join(', ')}', // Fallback for specialistBookingDisciplines
                      style: TextStyle(color: theme.textSecondary, fontSize: 12, fontStyle: FontStyle.italic),
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
