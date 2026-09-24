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
import 'mis_citas_screen.dart';
import 'payment_methods_screen.dart'; // Import the new screen
import '../../l10n/app_localizations.dart';
import '../../models/usuario.dart';

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

  void _load() {
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      context.read<ProfileProvider>().loadAll(token);
      _loadUserData(token);
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
                                  style: TextStyle(
                                      color: theme.white,
                                      fontSize: 18, // Changed from 20 to 18
                                      fontWeight: FontWeight.w800)),
                              const SizedBox(height: 2), // Reduced spacing
                              // Email Text
                              if (user.email.isNotEmpty)
                                Text(user.email,
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
                                        Text(user.ciudad!, style: TextStyle(color: theme.grey, fontSize: 12)),
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
                                      Text(user.nombreDisciplina!, style: TextStyle(color: theme.primary, fontSize: 12)),
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
                      if (profile.upcomingAppointment != null) ...[
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
                        Card(
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
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 20,
                                      backgroundColor: theme.primary.withValues(alpha: 0.2),
                                      backgroundImage: (profile.upcomingAppointment!['especialista']?['foto_url'] != null && profile.upcomingAppointment!['especialista']?['foto_url']!.isNotEmpty)
                                          ? NetworkImage(profile.upcomingAppointment!['especialista']!['foto_url']!)
                                          : null,
                                      child: (profile.upcomingAppointment!['especialista']?['foto_url'] == null || profile.upcomingAppointment!['especialista']?['foto_url']!.isEmpty)
                                          ? const Text('👩‍⚕️', style: TextStyle(fontSize: 20))
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            profile.upcomingAppointment!['especialista']?['nombre_especialista'] ?? l10n.specialistBookingDefaultName,
                                            style: TextStyle(color: theme.white, fontSize: 14, fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            profile.upcomingAppointment!['especialista']?['especialidad'] ?? l10n.specialistBookingCheckoutSummary,
                                            style: TextStyle(color: theme.grey, fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
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
                                    OutlinedButton.icon(
                                      onPressed: () {
                                        // This button should ideally trigger a cancellation flow.
                                        // For now, it will just show an alert.
                                        showDialog(
                                          context: context,
                                          builder: (ctx) => AlertDialog(
                                            backgroundColor: theme.card,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                            title: Text(l10n.profileActiveBookingCancelBtn, style: TextStyle(color: theme.white, fontSize: 16, fontWeight: FontWeight.bold)),
                                            content: Text(isEs ? '¿Seguro que quieres cancelar tu cita con el especialista?' : 'Are you sure you want to cancel your appointment with the specialist?', style: TextStyle(color: theme.grey, fontSize: 13)),
                                            actions: [
                                              TextButton(
                                                onPressed: () => Navigator.pop(ctx),
                                                child: Text(l10n.connectedAppsCancel, style: TextStyle(color: theme.grey)),
                                              ),
                                              TextButton(
                                                onPressed: () { Navigator.pop(ctx); }, // Placeholder for actual cancellation logic
                                                child: Text(l10n.competitionsDelete, style: TextStyle(color: theme.redText, fontWeight: FontWeight.bold)),
                                              ),
                                            ],
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
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                      ] else ...[
                        _SectionGroup(
                          title: l10n.profileSectionSpecialist,
                          items: [
                            _MenuItem(
                              icon: Icons.calendar_today_outlined,
                              label: isEs ? 'Mis citas agendadas' : 'My scheduled appointments',
                              onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const MisCitasScreen())),
                            ),
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





  String _formatAppointmentDateTime(String isoString, AppLocalizations l10n) {
    final dt = DateTime.parse(isoString).toLocal();
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
            onPressed: () => Navigator.pop(ctx),
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

    final tienePlan = user?.tienePlanActivo == true;
    final planNombre = user?.nombrePlanActivo ?? '';

    final titleText = tienePlan
        ? 'Membresía Activa: ${planNombre.toUpperCase()}'
        : l10n.profilePremiumTitle(nombre);

    final descText = tienePlan
        ? 'Disfrutás del acceso completo a todos los entrenamientos y beneficios de tu plan.'
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
              if (!tienePlan) ...[
                const SizedBox(width: 14),
                GestureDetector(
                  onTap: () {},
                  child: Text(l10n.profilePremiumRestore,
                      style: TextStyle(
                          color: theme.primary.withValues(alpha: 0.6),
                          fontSize: 12,
                          fontWeight: FontWeight.w700)),
                ),
              ],
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
      (const SocialSvgIcon(svgData: SocialSvgIcons.facebook, size: 22), 'FACEBOOK',  () => _launch('https://facebook.com/fitnflai')),
      (const SocialSvgIcon(svgData: SocialSvgIcons.instagram, size: 22), 'INSTAGRAM', () => _launch('https://instagram.com/fitnflai')),
      (const SocialSvgIcon(svgData: SocialSvgIcons.x, size: 20),  'X',         () => _launch('https://x.com/fitnflai')),
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
    return Column(children: [
      Divider(color: theme.border),
      const SizedBox(height: 8),
      Wrap(
        alignment: WrapAlignment.center,
        spacing: 20,
        runSpacing: 8,
        children: [
          'TÉRMINOS Y CONDICIONES',
          'POLÍTICA DE PRIVACIDAD',
          'EMPLEO',
        ].map((t) => GestureDetector(
          onTap: () {},
          child: Text(t,
              style: TextStyle(
                  color: theme.grey,
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.3)),
        )).toList(),
      ),
      const SizedBox(height: 12),
      Text('v1.0.0',
          style: TextStyle(color: theme.border, fontSize: 11)),
      const SizedBox(height: 8),
    ]);
  }
}
