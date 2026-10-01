import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:provider/provider.dart';
import '../../services/cached_http.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme_extension.dart';
import '../../config/app_routes.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/bottom_nav.dart';
import '../../providers/profile_provider.dart';
import '../../providers/specialist_provider.dart';
import 'edit_profile_screen.dart';
import 'reporte_config_screen.dart';
import 'notifications_screen.dart';
import 'connected_apps_screen.dart';
import 'general_settings_screen.dart';
import 'training_settings_screen.dart';
import 'my_tests_screen.dart';
import 'periodic_evaluation_screen.dart';
import '../membership/membership_screen.dart';
import '../../widgets/shared_widgets.dart';
import 'support_screen.dart';
import 'specialist_booking_screen.dart';

import 'payment_methods_screen.dart'; // Import the new screen
import '../../l10n/app_localizations.dart';
import '../../models/usuario.dart';
import '../../models/specialist.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String? _apodo;
  String? _avatarUrl;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _load());
  }

  Future<void> _load() async {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      final profileProvider = context.read<ProfileProvider>();
      await profileProvider.loadAll(token);
      _loadUserData(token);

      if (mounted) {
        final user = context.read<AuthProvider>().user;
        final hasElitePlan = user?.isElite == true ||
            profileProvider.planActivo?['nombre']?.toString().toLowerCase().contains('elite') == true;
        if (hasElitePlan) {
          final specialistId = profileProvider.profileData?['id_especialista'];
          if (specialistId != null) {
            final idInt = int.tryParse(specialistId.toString());
            if (idInt != null && mounted) {
              context.read<SpecialistProvider>().loadAssignedSpecialist(token, idInt);
            }
          }
        }
      }
    }
  }

  Future<void> _loadUserData(String token) async {
    try {
      final res = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200 && mounted) {
        final d = jsonDecode(res.body) as Map<String, dynamic>;
        setState(() {
          _apodo     = d['apodo']         as String?;
          _avatarUrl = d['foto_avatar_url'] as String?;
        });
      }
    } catch (e) {
      debugPrint('LOAD USER ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final auth    = context.watch<AuthProvider>();
    final profile = context.watch<ProfileProvider>();
    final specialistProvider = context.watch<SpecialistProvider>();
    final user    = auth.user;
    final isEs    = l10n.localeName == 'es';

    final nombre   = user?.nombre ?? '';
    final apodo    = _apodo ?? user?.apodo ?? '';
    final initials = nombre.trim().isNotEmpty
        ? nombre.trim().split(' ').map((w) => w[0]).take(2).join().toUpperCase()
        : '?';


    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        bottom: false,
        child: Column(children: [
          Expanded(
            child: profile.isLoading
              ? Center(child: CircularProgressIndicator(color: theme.primary))
              : RefreshIndicator(
                color: theme.primary,
                backgroundColor: theme.card,
                onRefresh: () async => _load(),
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 20, 16, 100),
                  child: Column(children: [

                    if (user != null) ...[
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Left side: Avatar Circle
                        Container(
                          width: 100, height: 100,
                          decoration: BoxDecoration(
                            color: theme.primary.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                            border: Border.all(color: theme.primary, width: 2.5),
                            image: (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                                ? DecorationImage(
                                    image: NetworkImage(_avatarUrl!),
                                    fit: BoxFit.cover)
                                : null,
                          ),
                          child: (_avatarUrl == null || _avatarUrl!.isEmpty)
                              ? Center(child: Text(initials,
                                  style: TextStyle(
                                      color: theme.primary,
                                      fontSize: 34,
                                      fontWeight: FontWeight.w800)))
                              : null,
                        ),
                        const SizedBox(width: 16), // Spacer between avatar and text
                        // Right side: Column for user data
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Name Text
                              Text(apodo.isNotEmpty ? apodo : (nombre.isNotEmpty ? nombre : 'Usuario'),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: theme.white,
                                      fontSize: 18, // Changed from 20 to 18
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2), // Reduced spacing
                              // Email Text
                              if (user.email.isNotEmpty)
                                Text(user.email,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                        color: theme.grey, fontSize: 12)),
                              // City & Altitude Row
                              if ((user.ciudad != null && user.ciudad!.isNotEmpty) || (user.altitud != null && user.altitud!.isNotEmpty))
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    children: [
                                      if (user.ciudad != null && user.ciudad!.isNotEmpty) ...[
                                        Icon(Icons.location_on_outlined, color: theme.grey, size: 12),
                                        const SizedBox(width: 4),
                                        Flexible(
                                          child: Text(
                                            user.ciudad!,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(color: theme.grey, fontSize: 12),
                                          ),
                                        ),
                                        if (user.altitud != null && user.altitud!.isNotEmpty) const SizedBox(width: 8),
                                      ],
                                      if (user.altitud != null && user.altitud!.isNotEmpty) ...[
                                        Icon(Icons.terrain_outlined, color: theme.grey, size: 12),
                                        const SizedBox(width: 4),
                                        Text('${user.altitud!}m', style: TextStyle(color: theme.grey, fontSize: 12)),
                                      ],
                                    ],
                                  ),
                                ),
                              // Discipline Row
                              if (user.nombreDisciplina != null && user.nombreDisciplina!.isNotEmpty)
                                Padding(
                                  padding: const EdgeInsets.only(top: 4.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.directions_run_outlined, color: theme.primary, size: 12),
                                      const SizedBox(width: 4),
                                      Flexible(
                                        child: Text(
                                          user.nombreDisciplina!,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: TextStyle(color: theme.primary, fontSize: 12),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    ],
                    const SizedBox(height: 20), // Spacing below the new Row
                    // "EDITAR PERFIL" Button (full-width)
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton(
                        onPressed: () => Navigator.push(context,
                            MaterialPageRoute(builder: (_) => const EditProfileScreen()))
                            .then((_) => _load()),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: theme.border),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 28, vertical: 10),
                        ),
                        child: Text(l10n.profileButtonEdit,
                            style: TextStyle(
                                color: theme.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.5)),
                      ),
                    ),
                    const SizedBox(height: 20),

                     // ── Banner premium ────────────────────
                     GestureDetector(
                       onTap: () => Navigator.push(context,
                           MaterialPageRoute(builder: (_) =>
                               const MembershipScreen())),
                       child: _PremiumBanner(
                         nombre: nombre.split(' ').first,
                         user: user,
                       ),
                     ),
                     const SizedBox(height: 20),

                    // ── ESPECIALISTA ──────────────────────
                    if (user?.isElite == true ||
                        profile.planActivo?['nombre']?.toString().toLowerCase().contains('elite') == true) ...[
                      () {
                        final assigned = specialistProvider.assignedSpecialist;
                        final upcomingSpecialist = profile.upcomingAppointment?['especialista'] as Map<String, dynamic>?;

                        // Get photoUrl
                        final photoUrl = assigned?.fotoUrl ?? upcomingSpecialist?['foto_url'] as String?;

                        // Get name
                        final name = assigned?.nombre ?? upcomingSpecialist?['nombre_especialista'] ?? upcomingSpecialist?['nombre'] as String?;

                        // Get specialty
                        final rawSpecialty = assigned?.especialidad ?? upcomingSpecialist?['especialidad'] as String?;
                        final specialty = (rawSpecialty != null && rawSpecialty.isNotEmpty)
                            ? (isEs ? 'Especialidad: $rawSpecialty' : 'Specialty: $rawSpecialty')
                            : (isEs ? 'Especialidad: General' : 'Specialty: General');

                        final hasSpecialist = name != null && name.isNotEmpty;

                        // Let's build the model if we need to show the details
                        final specialistModel = hasSpecialist
                            ? (assigned ?? Specialist(
                                id: int.tryParse(profile.upcomingAppointment?['especialista']?['id_especialista']?.toString() ?? '') ?? 0,
                                nombre: name,
                                especialidad: rawSpecialty,
                                fotoUrl: photoUrl,
                                disciplinas: [],
                                bio: '',
                              ))
                            : null;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(left: 4, bottom: 8),
                              child: Text(
                                l10n.profileSectionSpecialist,
                                style: TextStyle(
                                  color: theme.grey,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.8,
                                ),
                              ),
                            ),
                            if (hasSpecialist) ...[
                              GestureDetector(
                                onTap: () => _showSpecialistProfileBottomSheet(context, specialistModel!),
                                child: Card(
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
                                        // Header Row: Avatar, Name, Specialty, and "Ver perfil →"
                                        Row(
                                          children: [
                                            CircleAvatar(
                                              radius: 20,
                                              backgroundColor: theme.primary.withValues(alpha: 0.2),
                                              backgroundImage: (photoUrl != null && photoUrl.isNotEmpty)
                                                  ? NetworkImage(photoUrl)
                                                  : null,
                                              child: (photoUrl == null || photoUrl.isEmpty)
                                                  ? const Text('👩‍⚕️', style: TextStyle(fontSize: 20))
                                                  : null,
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    name,
                                                    style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.bold),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    specialty,
                                                    style: TextStyle(color: theme.primary, fontSize: 12, fontWeight: FontWeight.bold),
                                                  ),
                                                ],
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            GestureDetector(
                                              onTap: () => _showSpecialistProfileBottomSheet(context, specialistModel!),
                                              child: Text(
                                                isEs ? 'Ver perfil →' : 'View profile →',
                                                style: TextStyle(
                                                  color: theme.primary,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),

                                        // Upcoming Appointment Info (Inside Card)
                                        if (profile.upcomingAppointment != null) ...[
                                          const Divider(height: 24),
                                          Row(
                                            children: [
                                              Icon(Icons.calendar_today_outlined, color: theme.primary, size: 14),
                                              const SizedBox(width: 8),
                                              Text(
                                                _formatAppointmentDateTime(profile.upcomingAppointment!['fecha_hora'], l10n),
                                                style: TextStyle(color: theme.primary, fontSize: 13, fontWeight: FontWeight.w600),
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 16),
                                          Row(
                                            children: [
                                              // "Ir a la cita" button — only visible ON THE DAY of the appointment
                                              if (profile.isUpcomingAppointmentToday) ...[
                                                Expanded(
                                                  child: ElevatedButton.icon(
                                                    onPressed: () => _launch('https://meet.google.com/abc-defg-hij'),
                                                    icon: const Icon(Icons.videocam_outlined, size: 16),
                                                    label: Text(l10n.profileActiveBookingJoinBtn, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                                                    style: ElevatedButton.styleFrom(
                                                      backgroundColor: theme.primary,
                                                      foregroundColor: Colors.white,
                                                      elevation: 0,
                                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                    ),
                                                  ),
                                                ),
                                                const SizedBox(width: 10),
                                              ],
                                              // "Cancelar cita" button — only visible BEFORE the day of the appointment
                                              if (!profile.isUpcomingAppointmentToday) ...[
                                                OutlinedButton.icon(
                                                  onPressed: () {
                                                    final upcoming = profile.upcomingAppointment;
                                                    if (upcoming == null) return;
                                                    final idCita = upcoming['id_cita'] as int?;
                                                    if (idCita == null) return;

                                                    final navigator = Navigator.of(context);
                                                    final scaffoldMessenger = ScaffoldMessenger.of(context);
                                                    final TextEditingController motivoController = TextEditingController();
                                                    bool isLoading = false;

                                                    showDialog(
                                                      context: context,
                                                      builder: (ctx) => StatefulBuilder(
                                                        builder: (ctx, setState) => AlertDialog(
                                                          backgroundColor: theme.card,
                                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                                          title: Text(l10n.profileActiveBookingCancelBtn, style: TextStyle(color: theme.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                                          content: Column(
                                                            mainAxisSize: MainAxisSize.min,
                                                            children: [
                                                              Text(isEs ? '¿Seguro que quieres cancelar tu cita con el especialista?' : 'Are you sure you want to cancel your appointment with the specialist?', style: TextStyle(color: theme.grey, fontSize: 13)),
                                                              const SizedBox(height: 16),
                                                              TextField(
                                                                controller: motivoController,
                                                                decoration: InputDecoration(
                                                                  labelText: isEs ? 'Motivo de cancelación' : 'Cancellation reason',
                                                                  hintText: isEs ? 'Ej: Ya no quiero la cita' : 'E.g.: No longer want the appointment',
                                                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                                                                  filled: true,
                                                                  fillColor: theme.bg,
                                                                ),
                                                                maxLines: 3,
                                                                minLines: 1,
                                                              ),
                                                            ],
                                                          ),
                                                          actions: [
                                                            TextButton(
                                                              onPressed: isLoading ? null : () => Navigator.pop(ctx),
                                                              child: Text(l10n.cancelButton, style: TextStyle(color: theme.grey)),
                                                            ),
                                                            TextButton(
                                                              onPressed: isLoading
                                                                  ? null
                                                                  : () async {
                                                                      final motivo = motivoController.text.trim();
                                                                      if (motivo.isEmpty) {
                                                                        if (!mounted) return;
                                                                        scaffoldMessenger.showSnackBar(
                                                                          SnackBar(content: Text(isEs ? 'Por favor ingresa un motivo' : 'Please enter a reason')),
                                                                        );
                                                                        return;
                                                                      }
                                                                      setState(() => isLoading = true);
                                                                      final token = context.read<AuthProvider>().token;
                                                                      final specialistProvider = context.read<SpecialistProvider>();
                                                                      final profileProvider = context.read<ProfileProvider>();
                                                                      if (token == null) {
                                                                        if (!mounted) return;
                                                                        setState(() => isLoading = false);
                                                                        return;
                                                                      }
                                                                      final success = await specialistProvider.cancelarCita(
                                                                        token,
                                                                        idCita: idCita,
                                                                        motivoCancelacion: motivo,
                                                                      );
                                                                      if (!mounted) return;
                                                                      if (success) {
                                                                        navigator.pop();
                                                                        await profileProvider.loadAll(token, force: true);
                                                                        if (!mounted) return;
                                                                        scaffoldMessenger.showSnackBar(
                                                                          SnackBar(content: Text(isEs ? 'Cita cancelada correctamente' : 'Appointment cancelled successfully')),
                                                                        );
                                                                      } else {
                                                                        setState(() => isLoading = false);
                                                                        if (!mounted) return;
                                                                        scaffoldMessenger.showSnackBar(
                                                                          SnackBar(content: Text(specialistProvider.errorMessage ?? (isEs ? 'Error al cancelar la cita' : 'Failed to cancel appointment'))),
                                                                        );
                                                                      }
                                                                    },
                                                              child: isLoading
                                                                  ? SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: theme.redText))
                                                                  : Text(isEs ? 'Sí, cancelar' : 'Yes, cancel', style: TextStyle(color: theme.redText, fontWeight: FontWeight.bold)),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                  icon: Icon(Icons.cancel_outlined, color: theme.grey, size: 16),
                                                  label: Text(l10n.profileActiveBookingCancelBtn, style: TextStyle(color: theme.grey, fontSize: 13, fontWeight: FontWeight.w600)),
                                                  style: OutlinedButton.styleFrom(
                                                    side: BorderSide(color: theme.border),
                                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            // Menu Section Below — Only "Pedir cita con el especialista" if no upcoming appointment.
                            // "Mis citas agendadas" is removed completely per user request.
                            if (profile.upcomingAppointment == null) ...[
                              _SectionGroup(
                                title: '',
                                items: [
                                  _MenuItem(
                                    icon: Icons.chat_bubble_outline,
                                    label: l10n.profileMenuBookSpecialist,
                                    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const SpecialistBookingScreen())),
                                    isLast: true,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                            ],
                          ],
                        );
                      }(),
                    ],

                    // ── MIS COSAS ─────────────────────────
                    _SectionGroup(
                      title: l10n.profileSectionMyStuff,
                      items: [
                        _MenuItem(
                          icon: Icons.devices_outlined,
                          label: l10n.profileMenuConnectedApps,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  const ConnectedAppsScreen())),
                        ),
                        _MenuItem(
                          icon: Icons.directions_run_outlined,
                          label: l10n.profileMenuPersonalInfo,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const EditProfileScreen()))
                              .then((_) => _load()),
                        ),
                        _MenuItem(
                          icon: Icons.notifications_outlined,
                          label: l10n.profileMenuNotifications,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const NotificationsScreen()))
                              .then((_) => _load()),
                        ),
                        _MenuItem(
                          icon: Icons.summarize_outlined,
                          label: l10n.profileMenuWeeklyReport,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(
                                  builder: (_) => const ReporteConfigScreen()))
                              .then((_) => _load()),
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── MIS PREFERENCIAS ──────────────────
                    _SectionGroup(
                      title: l10n.profileSectionPreferences,
                      items: [
                        _MenuItem(
                          icon: Icons.tune_outlined,
                          label: l10n.profileMenuGeneral,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  const GeneralSettingsScreen())),
                        ),
                        _MenuItem(
                          icon: Icons.calendar_month_outlined,
                          label: l10n.profileMenuMyPlan,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  const TrainingSettingsScreen())),
                        ),
                        _MenuItem(
                          icon: Icons.assignment_turned_in_outlined,
                          label: l10n.profileMenuMyTests,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  const MyTestsScreen())),
                        ),
                        _MenuItem(
                          icon: Icons.loop_outlined,
                          label: l10n.profileMenuPeriodicEval,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) =>
                                  const PeriodicEvaluationScreen())),
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Redes sociales ────────────────────
                    _SocialRow(),
                    const SizedBox(height: 16),

                    // ── Cuenta ────────────────────────────
                    _SectionGroup(
                      title: l10n.profileSectionAccount,
                      items: [
                        _MenuItem(
                          icon: Icons.credit_card_outlined,
                          label: l10n.profileMenuPaymentMethods,
                          onTap: () => Navigator.push(context,
                              MaterialPageRoute(builder: (_) => const PaymentMethodsScreen())),
                        ),
                        _MenuItem(
                          icon: Icons.delete_outline,
                          label: l10n.profileMenuDeleteAccount,
                          labelColor: theme.redText,
                          onTap: () => _confirmDeleteAccount(context, auth),
                          isLast: true,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // ── Cerrar sesión ─────────────────────
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await auth.logout();
                          if (!context.mounted) return;
                          Navigator.pushNamedAndRemoveUntil(
                              context, AppRoutes.welcome, (_) => false);
                        },
                        icon: Icon(Icons.logout_outlined,
                            color: theme.redText, size: 18),
                        label: Text(l10n.profileButtonLogout,
                            style: TextStyle(
                                color: theme.redText,
                                fontWeight: FontWeight.w600)),
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          side: BorderSide(color: theme.redMid),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // ── Footer legal ──────────────────────
                    _FooterLinks(),
                  ]),
                ),
              ),
          ),
        ]),
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 4),
    );
  }

  void _showSpecialistProfileBottomSheet(BuildContext context, Specialist specialist) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs = Localizations.localeOf(context).languageCode == 'es';

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.bg,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.8,
          minChildSize: 0.5,
          maxChildSize: 0.95,
          expand: false,
          builder: (context, scrollController) {
            return SingleChildScrollView(
              controller: scrollController,
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: theme.border,
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: 36,
                        backgroundColor: theme.primary.withValues(alpha: 0.2),
                        backgroundImage: (specialist.fotoUrl != null && specialist.fotoUrl!.isNotEmpty)
                            ? NetworkImage(specialist.fotoUrl!)
                            : null,
                        child: (specialist.fotoUrl == null || specialist.fotoUrl!.isEmpty)
                            ? const Icon(Icons.person, color: Colors.grey, size: 36)
                            : null,
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              specialist.nombre,
                              style: TextStyle(color: theme.white, fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              specialist.especialidad ?? (isEs ? 'Especialista General' : 'General Specialist'),
                              style: TextStyle(color: theme.primary, fontSize: 13, fontWeight: FontWeight.bold),
                            ),
                            if (specialist.ciudad != null && specialist.ciudad!.isNotEmpty && specialist.ciudad != 'N/A') ...[
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  Icon(Icons.location_on_outlined, color: theme.grey, size: 12),
                                  const SizedBox(width: 4),
                                  Expanded(
                                    child: Text(
                                      '${specialist.ciudad}, ${specialist.pais ?? 'N/A'}',
                                      style: TextStyle(color: theme.grey, fontSize: 11, fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.border),
                        ),
                        child: Column(
                          children: [
                            Text(
                              isEs ? 'Exp' : 'Exp',
                              style: TextStyle(color: theme.grey, fontSize: 10, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${specialist.aniosExperiencia ?? 0} ${isEs ? 'años' : 'years'}',
                              style: TextStyle(color: theme.white, fontSize: 12, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Text(
                    isEs ? 'Acerca de' : 'About',
                    style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    specialist.bio != null && specialist.bio!.trim().isNotEmpty
                        ? specialist.bio!
                        : (isEs
                            ? 'Este especialista no ha proporcionado una biografía detallada.'
                            : 'This specialist has not provided a detailed biography.'),
                    style: TextStyle(color: theme.greyLight, fontSize: 13, height: 1.5),
                  ),
                  const SizedBox(height: 24),
                  if (specialist.disciplinas.isNotEmpty) ...[
                    Text(
                      isEs ? 'Disciplinas Asociadas' : 'Associated Disciplines',
                      style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: specialist.disciplinas.map((d) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.card,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.border),
                        ),
                        child: Text(
                          d,
                          style: TextStyle(color: theme.greyLight, fontSize: 12),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (specialist.certificados != null && specialist.certificados!.isNotEmpty) ...[
                    Text(
                      isEs ? 'Certificaciones' : 'Certificates',
                      style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: specialist.certificados!.map((c) => Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: theme.primary.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: theme.primary.withValues(alpha: 0.3)),
                        ),
                        child: Text(
                          c.toString(),
                          style: TextStyle(color: theme.primary, fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                      )).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],
                  if (specialist.historialLaboral != null && specialist.historialLaboral!.isNotEmpty) ...[
                    Text(
                      isEs ? 'Trayectoria Profesional' : 'Professional Background',
                      style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ...specialist.historialLaboral!.map((item) {
                      final puesto = item['puesto']?.toString() ?? '';
                      final empresa = item['empresa']?.toString() ?? '';
                      final periodo = item['periodo']?.toString() ?? '';
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: theme.card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: theme.border),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Icon(Icons.work_outline, color: theme.primary, size: 16),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(puesto, style: TextStyle(color: theme.white, fontSize: 13, fontWeight: FontWeight.bold)),
                                  const SizedBox(height: 2),
                                  Text(empresa, style: TextStyle(color: theme.greyLight, fontSize: 12)),
                                  if (periodo.isNotEmpty) ...[
                                    const SizedBox(height: 4),
                                    Text(periodo, style: TextStyle(color: theme.grey, fontSize: 11)),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }),
                    const SizedBox(height: 24),
                  ],
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: Text(
                        isEs ? 'Cerrar' : 'Close',
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }





  String _formatAppointmentDateTime(String isoString, AppLocalizations l10n) {
    // Parse ISO string handling timezone correctly:
    // - If string has 'Z' or offset (+00:00, -06:00), parse as UTC and convert to local
    // - If no timezone info, assume it's already in user's local time
    DateTime dt;
    if (isoString.endsWith('Z') || isoString.contains(RegExp(r'[+-]\d{2}:?\d{2}$'))) {
      dt = DateTime.parse(isoString).toLocal();
    } else {
      dt = DateTime.parse(isoString); // assume local
    }
    final isEs = Localizations.localeOf(context).languageCode == 'es';

    String month;
    if (isEs) {
      final monthsEs = ['ene', 'feb', 'mar', 'abr', 'may', 'jun', 'jul', 'ago', 'sep', 'oct', 'nov', 'dic'];
      month = monthsEs[dt.month - 1];
    } else {
      final monthsEn = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
      month = monthsEn[dt.month - 1];
    }

    final day = dt.day;
    final year = dt.year;
    final hour = dt.hour;
    final minute = dt.minute.toString().padLeft(2, '0');

    if (isEs) {
      return '$day $month $year · $hour:$minute';
    } else {
      final period = hour < 12 ? 'AM' : 'PM';
      final hour12 = hour % 12 == 0 ? 12 : hour % 12;
      return '$month $day, $year · $hour12:$minute $period';
    }
  }

  void _confirmDeleteAccount(BuildContext ctx, AuthProvider auth) {
    final theme = Theme.of(ctx).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(ctx);
    showDialog(
      context: ctx,
      builder: (_) => AlertDialog(
        backgroundColor: theme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text(l10n.profileConfirmDeleteTitle,
            style: TextStyle(color: theme.white, fontSize: 16,
                fontWeight: FontWeight.w700)),
        content: Text(
          l10n.profileConfirmDeleteDesc,
          style: TextStyle(color: theme.grey, fontSize: 13, height: 1.5)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(l10n.profileConfirmDeleteCancel,
                style: TextStyle(color: theme.grey))),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx); // Close confirmation dialog
              
              // Show loading dialog
              showDialog(
                context: ctx,
                barrierDismissible: false,
                builder: (loadingCtx) => PopScope(
                  canPop: false,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        color: Colors.transparent,
                      ),
                      child: const CircularProgressIndicator(color: Colors.orange),
                    ),
                  ),
                ),
              );

              try {
                await auth.deleteAccount();
                if (ctx.mounted) {
                  Navigator.pop(ctx); // Close loading dialog
                  Navigator.pushNamedAndRemoveUntil(
                      ctx, AppRoutes.welcome, (_) => false);
                }
              } catch (e) {
                if (ctx.mounted) {
                  Navigator.pop(ctx); // Close loading dialog
                  ScaffoldMessenger.of(ctx).showSnackBar(
                    SnackBar(
                      content: Text(e.toString().replaceAll('Exception: ', '')),
                      backgroundColor: Colors.red,
                    ),
                  );
                }
              }
            },
            child: Text(l10n.profileConfirmDeleteConfirm,
                style: TextStyle(color: theme.redText,
                    fontWeight: FontWeight.w700))),
        ],
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ═══════════════════════════════════════════════════════════════
// PREMIUM BANNER
// ═══════════════════════════════════════════════════════════════
class _PremiumBanner extends StatelessWidget {
  final String nombre;
  final Usuario? user;
  const _PremiumBanner({required this.nombre, this.user});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final l10n  = AppLocalizations.of(context);
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    final profileProvider = context.watch<ProfileProvider>();
    final planes = profileProvider.planes;

    final tienePlan = user?.tienePlanActivo == true;
    final planNombre = user?.nombrePlanActivo ?? '';

    final titleText = tienePlan
        ? 'Membresía Activa: ${planNombre.toUpperCase()}'
        : l10n.profilePremiumTitle(nombre);

    String? planDesc;
    if (tienePlan && planes != null) {
      try {
        final activePlanData = planes.firstWhere(
          (p) => p['nombre']?.toString().toLowerCase() == planNombre.toLowerCase(),
          orElse: () => null,
        );
        if (activePlanData != null) {
          planDesc = activePlanData['descripcion'] as String?;
        }
      } catch (_) {}
    }

    if (planDesc == null || planDesc.isEmpty) {
      if (user?.isElite == true) {
        planDesc = 'Plan premium completo con acompañamiento de deportólogo, nutricionista y entrenador de cabecera.';
      } else if (user?.isPro == true) {
        planDesc = 'Plan de entrenamiento inteligente con planes de alimentación e hidratación personalizados.';
      } else {
        planDesc = 'Plan de entrenamiento adaptativo 100% inteligente generado por IA.';
      }
    }

    final descText = tienePlan
        ? planDesc
        : l10n.profilePremiumDesc;

    final buttonText = tienePlan
        ? 'CAMBIAR'
        : l10n.profilePremiumSubscribe.toUpperCase();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        gradient: LinearGradient(
          colors: isDarkMode
              ? const [Color(0xFF1A4A2E), Color(0xFF3A1A0A)]
              : const [Color(0xFFE8F5E9), Color(0xFFFFE0B2)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        border: Border.all(color: theme.primary.withValues(alpha: 0.3)),
      ),
      child: Row(children: [
        Expanded(
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(titleText,
                style: TextStyle(
                    color: theme.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 6),
            Text(
              descText,
              style: TextStyle(
                  color: isDarkMode ? const Color(0xFFBBBBBB) : theme.greyLight,
                  fontSize: 12,
                  height: 1.4)),
            const SizedBox(height: 12),
            Row(children: [
              GestureDetector(
                onTap: () => Navigator.push(context,
                    MaterialPageRoute(builder: (_) => const MembershipScreen())),
                child: Text(buttonText,
                    style: TextStyle(
                        color: theme.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w700)),
              ),
            ]),
          ]),
        ),
        const SizedBox(width: 12),
        const Text('👑', style: TextStyle(fontSize: 40)),
      ]),
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// SECTION GROUP
// ═══════════════════════════════════════════════════════════════
class _SectionGroup extends StatelessWidget {
  final String title;
  final List<_MenuItem> items;
  const _SectionGroup({required this.title, required this.items});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (title.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(left: 4, bottom: 8),
            child: Text(title,
                style: TextStyle(
                    color: theme.grey,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.8)),
          ),
        Container(
          decoration: BoxDecoration(
            color: theme.card,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: theme.border),
          ),
          child: Column(children: items),
        ),
      ],
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// MENU ITEM ROW
// ═══════════════════════════════════════════════════════════════
class _MenuItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color? labelColor;
  final VoidCallback onTap;
  final bool isLast;
  const _MenuItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.labelColor,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(children: [
              Icon(icon, color: labelColor ?? theme.greyLight, size: 20),
              const SizedBox(width: 14),
              Expanded(
                child: Text(label,
                    style: TextStyle(
                        color: labelColor ?? theme.white,
                        fontSize: 15)),
              ),
              Icon(Icons.chevron_right, color: theme.grey, size: 20),
            ]),
          ),
        ),
        if (!isLast) Divider(
            color: theme.border, height: 1, indent: 50, endIndent: 0),
      ],
    );
  }
}


// ═══════════════════════════════════════════════════════════════
// SOCIAL ROW
// ═══════════════════════════════════════════════════════════════
class _SocialRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final socials = [
      (const SocialSvgIcon(svgData: SocialSvgIcons.facebook, size: 22), 'FACEBOOK',  () => _launch('https://www.facebook.com/profile.php?id=61593229000325&mibextid=wwXIfr&rdid=sTyvzMS3lpiXv5Ul&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1MMtubbg3W%2F%3Fmibextid%3DwwXIfr#')),
      (const SocialSvgIcon(svgData: SocialSvgIcons.instagram, size: 22), 'INSTAGRAM', () => _launch('https://instagram.com/fitnflai')),
      (const SocialSvgIcon(svgData: SocialSvgIcons.tiktok, size: 20),  'TIKTOK',     () => _launch('https://www.tiktok.com/@fit.n.flai?_r=1&_t=ZS-9A7asfhayHM')),
      (Icon(Icons.headset_mic_outlined, color: theme.white, size: 22), 'SOPORTE',   () => Navigator.push(context,
          MaterialPageRoute(builder: (_) => const SupportScreen()))),
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: theme.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: socials.map((s) => GestureDetector(
          onTap: s.$3,
          child: Column(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: theme.cardDark,
                shape: BoxShape.circle,
                border: Border.all(color: theme.border),
              ),
              child: Center(
                child: s.$1),
            ),
            const SizedBox(height: 6),
            Text(s.$2,
                style: TextStyle(
                    color: theme.grey,
                    fontSize: 9,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.3)),
          ]),
        )).toList(),
      ),
    );
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

// ═══════════════════════════════════════════════════════════════
// FOOTER LINKS
// ═══════════════════════════════════════════════════════════════
class _FooterLinks extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>() ?? AppThemeExtension.dark;
    final isEs = Localizations.localeOf(context).languageCode == 'es';

    final links = [
      (
        isEs ? 'TÉRMINOS Y CONDICIONES' : 'TERMS & CONDITIONS',
        () => Navigator.pushNamed(context, AppRoutes.termsConditions),
      ),
      (
        isEs ? 'POLÍTICA DE PRIVACIDAD' : 'PRIVACY POLICY',
        () => Navigator.pushNamed(context, AppRoutes.privacyPolicy),
      ),
      (
        isEs ? 'EMPLEO' : 'CAREERS',
        () async {
          final emailUri = Uri(
            scheme: 'mailto',
            path: 'legal@fitnflai.com',
            query: 'subject=${Uri.encodeComponent(isEs ? 'Empleo FITNFLAI' : 'Careers FITNFLAI')}',
          );
          if (await canLaunchUrl(emailUri)) {
            await launchUrl(emailUri, mode: LaunchMode.externalApplication);
          }
        },
      ),
    ];

    return Column(children: [
      Divider(color: theme.border),
      const SizedBox(height: 8),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 8,
        children: links.map((item) => GestureDetector(
          onTap: item.$2,
          child: Text(
            item.$1,
            style: TextStyle(
                color: theme.grey,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.3),
          ),
        )).toList(),
      ),
      const SizedBox(height: 12),
      Text('v1.0.0',
          style: TextStyle(color: theme.border, fontSize: 11)),
      const SizedBox(height: 8),
    ]);
  }
}
