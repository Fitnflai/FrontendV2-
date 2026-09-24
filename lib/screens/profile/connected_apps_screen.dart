import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../services/cached_http.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';
import 'package:fitnflaifrontendv2/providers/health_provider.dart';
import 'package:fitnflaifrontendv2/services/health/health_repository.dart';
import 'package:flutter_svg/flutter_svg.dart';


class ConnectedAppsScreen extends StatefulWidget {
  const ConnectedAppsScreen({super.key});
  @override
  State<ConnectedAppsScreen> createState() => _ConnectedAppsScreenState();
}

class _ConnectedAppsScreenState extends State<ConnectedAppsScreen> with WidgetsBindingObserver {
  bool _stravaConnected = false;
  bool _loading         = true;
  bool _stravaLoading   = false;
  bool _isSyncingStrava = false;
  bool _isConnectingStrava = false;
  String? _userId;

  static const _base = 'https://apifitnflai.com';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadStatus());
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      CachedHttp.clearCache();
      _loadStatus();
    }
  }

  Future<void> _loadStatus() async {
    final token = context.read<AuthProvider>().token ?? '';
    try {
      final res = await CachedHttp.get(
        Uri.parse('$_base/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200 && mounted) {
        final d = jsonDecode(res.body) as Map<String, dynamic>;
        final previouslyConnected = _stravaConnected;
        setState(() {
          _stravaConnected = (d['strava_access_token'] as String?)?.isNotEmpty == true;
          _userId          = d['id_usuario'] as String?;
        });
        if (_stravaConnected && !previouslyConnected && _isConnectingStrava) {
          _isConnectingStrava = false;
          // Use a post-frame callback to ensure the dialog is shown after the current build cycle
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted) {
              _showSyncConfirmationDialog();
            }
          });
        }
      }
    } catch (e) {
      debugPrint('CONNECTED APPS LOAD ERROR: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _connectStrava() async {
    final token = context.read<AuthProvider>().token ?? '';
    setState(() => _stravaLoading = true);
    try {
      debugPrint('STRAVA AUTH-URL CALL');
      final res = await CachedHttp.get(
        Uri.parse('$_base/webhooks/strava/auth-url?id_usuario=$_userId'),
        headers: {'Authorization': 'Bearer $token'},
      );
      debugPrint('STRAVA STATUS: ${res.statusCode} | BODY: ${res.body}');
      if (res.statusCode == 200) {
        final body = jsonDecode(res.body);
        final url = body is String ? body : (body as Map<String,dynamic>?)?['url'] as String?;
        debugPrint('STRAVA URL: $url');
        if (url != null) {
          setState(() => _isConnectingStrava = true);
          await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }
    } catch (e) {
      debugPrint('STRAVA CONNECT ERROR: $e');
    } finally {
      if (mounted) setState(() => _stravaLoading = false);
    }
  }

  Future<void> _disconnectStrava() async {
    final token = context.read<AuthProvider>().token ?? '';
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    setState(() => _stravaConnected = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(l10n.connectedAppsDisconnectedToast('Strava')),
      backgroundColor: theme.redMid,
    ));
    try {
      await CachedHttp.delete(
        Uri.parse('$_base/webhooks/strava/disconnect?id_usuario=$_userId'),
        headers: {'Authorization': 'Bearer $token'},
      );
    } catch (e) {
      debugPrint('STRAVA DISCONNECT ERROR: $e');
    }
  }

  Future<void> _syncStrava() async {
    if (_userId == null) return;
    final token = context.read<AuthProvider>().token ?? '';
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    setState(() => _isSyncingStrava = true);
    try {
      final res = await CachedHttp.post(
        Uri.parse('$_base/webhooks/strava/sync-plan'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
          'accept': 'application/json',
        },
        body: '',
      );
      if (mounted) {
        final isSuccess = res.statusCode == 200 || res.statusCode == 201;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(isSuccess
              ? l10n.connectedAppsStravaSynced : l10n.connectedAppsStravaSyncError),
          backgroundColor: isSuccess
              ? theme.successBorder : theme.redMid,
        ));
      }
      } catch (e) {
        debugPrint('STRAVA SYNC ERROR: $e');
      } finally {
        if (mounted) setState(() => _isSyncingStrava = false);
      }
  }

  void _showSyncConfirmationDialog() {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: theme.card,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('Strava', style: TextStyle(
            color: theme.text, fontSize: 16, fontWeight: FontWeight.w700)),
        content: Text(
          l10n.connectedAppsStravaSyncPrompt,
          style: TextStyle(color: theme.textMuted, fontSize: 13),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              l10n.connectedAppsSkip,
              style: TextStyle(color: theme.textMuted),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _syncStrava();
            },
            child: Text(
              l10n.connectedAppsAccept,
              style: TextStyle(
                color: theme.primary,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _handleStrava() {
    debugPrint('HANDLE STRAVA: connected=$_stravaConnected loading=$_stravaLoading');
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    if (_userId == null) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(l10n.connectedAppsNullUserError),
        backgroundColor: theme.redMid,
      ));
      return;
    }
    if (_stravaLoading || _isSyncingStrava) {
      debugPrint('Strava action already in progress. Ignoring tap.');
      return;
    }
    if (_stravaConnected) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text('Strava', style: TextStyle(
              color: theme.text, fontSize: 16, fontWeight: FontWeight.w700)),
          content: Text(l10n.connectedAppsActionPrompt,
              style: TextStyle(color: theme.textMuted, fontSize: 13)),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context),
                child: Text(l10n.connectedAppsCancel,
                    style: TextStyle(color: theme.textMuted))),
            TextButton(
              onPressed: () { Navigator.pop(context); _showSyncConfirmationDialog(); },
              child: Text(l10n.connectedAppsSync,
                  style: TextStyle(color: theme.primary,
                      fontWeight: FontWeight.w700)),
            ),
            TextButton(
              onPressed: () { Navigator.pop(context); _disconnectStrava(); },
              child: Text(l10n.connectedAppsDisconnect,
                  style: TextStyle(color: theme.errorText,
                      fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
    } else {
      _connectStrava();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    final isEs = Localizations.localeOf(context).languageCode == 'es';
    if (_loading) {
      return Scaffold(
        backgroundColor: theme.bg,
        appBar: FitnflaiAppBar(title: l10n.connectedAppsTitle),
        body: Center(child: CircularProgressIndicator(color: theme.primary)),
      );
    }
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: l10n.connectedAppsTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            l10n.connectedAppsDesc,
            style: TextStyle(color: theme.textSecondary, fontSize: 14, height: 1.5),
          ),
          const SizedBox(height: 24),

          _SectionLabel(isEs ? 'APLICACIONES DE DEPORTE' : 'SPORTS APPS'),
          _NavGroup(items: [
            _NavItem(
              icon: Image.asset(
                Theme.of(context).brightness == Brightness.dark
                    ? 'assets/images/garmin_white.png'
                    : 'assets/images/garmin_black.png',
                fit: BoxFit.contain,
                height: 26,
              ),
              label: '',
              subtitle: null,
              badgeConnected: false,
              showInfo: true,
              onTap: () {
                final themeColors = context.themeColors;
                showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    backgroundColor: themeColors.card,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                    title: Row(
                      children: [
                        Image.asset(
                          Theme.of(context).brightness == Brightness.dark
                              ? 'assets/images/garmin_white.png'
                              : 'assets/images/garmin_black.png',
                          fit: BoxFit.contain,
                          height: 22,
                        ),
                      ],
                    ),
                    content: Text(
                      isEs
                          ? 'Estamos trabajando en la integración con Garmin para que puedas sincronizar tus entrenamientos automáticamente.\n\n¡Próximamente disponible!'
                          : 'We are working on the Garmin integration so you can sync your workouts automatically.\n\nComing soon!',
                      style: TextStyle(color: themeColors.textSecondary, fontSize: 13, height: 1.5),
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          isEs ? 'Entendido' : 'Understood',
                          style: TextStyle(
                            color: themeColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            _NavItem(
              icon: Image.asset(
                'assets/images/strava.png',
                fit: BoxFit.contain,
                height: 34,
              ),
              label: '',
              subtitle: _stravaConnected ? l10n.connectedAppsConnected : null,
              badgeConnected: _stravaConnected,
              showInfo: true,
              loading: _stravaLoading || _isSyncingStrava,
              enabled: _userId != null,
              onTap: _handleStrava,
            ),
          ]),
          const SizedBox(height: 24),
          _SectionLabel(isEs ? 'APLICACIONES DE SALUD Y SEGUIMIENTO' : 'HEALTH & TRACKING APPS'),
          Consumer<HealthProvider>(
            builder: (context, healthProvider, child) {
              final isHealthConnectConnected =
                  healthProvider.connectedProvider == HealthProviderType.healthConnect;
              final isHealthKitConnected =
                  healthProvider.connectedProvider == HealthProviderType.healthKit;
              final isHuaweiHealthConnected =
                  healthProvider.connectedProvider == HealthProviderType.huaweiHealth;
              final isLoadingHealthConnect =
                  healthProvider.isLoading && healthProvider.connectedProvider == HealthProviderType.healthConnect;
              final isLoadingHealthKit =
                  healthProvider.isLoading && healthProvider.connectedProvider == HealthProviderType.healthKit;
              final isLoadingHuaweiHealth =
                  healthProvider.isLoading && healthProvider.connectedProvider == HealthProviderType.huaweiHealth;

              final healthApps = <_NavItem>[
                _NavItem(
                  icon: SvgPicture.asset(
                    'assets/images/health_connect.svg',
                    width: 28,
                    height: 28,
                    colorFilter: const ColorFilter.mode(Color(0xFF00C897), BlendMode.srcIn),
                  ),
                  label: 'Health Connect',
                  subtitle: isHealthConnectConnected ? l10n.connectedAppsConnected : null,
                  badgeConnected: isHealthConnectConnected,
                  showInfo: true,
                  loading: isLoadingHealthConnect,
                  onTap: () => _handleHealthConnection(HealthProviderType.healthConnect),
                ),
                _NavItem(
                  icon: SvgPicture.asset(
                    'assets/images/apple_health.svg',
                    width: 26,
                    height: 26,
                    colorFilter: const ColorFilter.mode(Color(0xFFFF2D55), BlendMode.srcIn),
                  ),
                  label: 'Apple HealthKit',
                  subtitle: isHealthKitConnected ? l10n.connectedAppsConnected : null,
                  badgeConnected: isHealthKitConnected,
                  showInfo: true,
                  loading: isLoadingHealthKit,
                  onTap: () => _handleHealthConnection(HealthProviderType.healthKit),
                ),
                _NavItem(
                  icon: Image.asset(
                    'assets/images/huawei_health.png',
                    width: 26,
                    height: 26,
                    fit: BoxFit.contain,
                  ),
                  label: 'Huawei Health',
                  subtitle: isHuaweiHealthConnected ? l10n.connectedAppsConnected : null,
                  badgeConnected: isHuaweiHealthConnected,
                  showInfo: true,
                  isLast: true,
                  loading: isLoadingHuaweiHealth,
                  onTap: () => _handleHealthConnection(HealthProviderType.huaweiHealth),
                ),
              ];
              return _NavGroup(items: healthApps);
            },
          ),
        ]),
      ),
    );
  }

  Future<void> _handleHealthConnection(HealthProviderType providerType) async {
    final healthProvider = context.read<HealthProvider>();
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);

    if (healthProvider.connectedProvider == providerType) {
      // If currently connected to this provider, offer to disconnect
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: theme.card,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text(l10n.connectedAppsDisconnectTitle(providerType.id),
              style: TextStyle(
                  color: theme.text, fontSize: 16, fontWeight: FontWeight.w700)),
          content: Text(l10n.connectedAppsDisconnectDesc(providerType.id),
              style: TextStyle(color: theme.textMuted, fontSize: 13)),
          actions: [
            TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text(l10n.connectedAppsCancel,
                    style: TextStyle(color: theme.textMuted))),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                healthProvider.disconnectProvider();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        l10n.connectedAppsDisconnectedToast(providerType.id)),
                    backgroundColor: theme.redMid));
              },
              child: Text(l10n.connectedAppsDisconnect,
                  style:
                      TextStyle(color: theme.errorText, fontWeight: FontWeight.w700)),
            ),
          ],
        ),
      );
    } else if (healthProvider.connectedProvider != HealthProviderType.none) {
      // If another health provider is connected, inform user to disconnect it first
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Desconectá primero ${healthProvider.connectedProvider.id} para poder conectar este proveedor.'),
          backgroundColor: theme.redMid,
          duration: const Duration(seconds: 3)));
    } else {
      // Not connected to any health provider, attempt to connect to this one
      bool isAvailable = true; // Permite intentar conectar y guiar al usuario
      if (providerType == HealthProviderType.healthConnect || providerType == HealthProviderType.huaweiHealth) {
        isAvailable = await healthProvider.checkAvailability(providerType);
      }
      if (mounted) {
        if (isAvailable) {
          await healthProvider.connectProvider(providerType);
          if (!mounted) return;
          if (healthProvider.connectedProvider == providerType) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(l10n.connectedAppsConnectedToast(providerType.id)),
                backgroundColor: theme.successBorder,
                duration: const Duration(seconds: 2)));
          } else {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: const Text('Permisos de salud rechazados por el usuario.'),
                backgroundColor: theme.redMid,
                duration: const Duration(seconds: 3)));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: const Text('El servicio no está disponible en este dispositivo.'),
              backgroundColor: theme.redMid,
              duration: const Duration(seconds: 3)));
        }
      }
    }
  }
}

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(text, style: TextStyle(color: theme.textMuted,
          fontSize: 11, fontWeight: FontWeight.w700, letterSpacing: 0.8)),
    );
  }
}

class _NavGroup extends StatelessWidget {
  final List<_NavItem> items;
  const _NavGroup({required this.items});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Container(
      decoration: BoxDecoration(color: theme.card,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: theme.border)),
      child: Column(children: items),
    );
  }
}

class _NavItem extends StatelessWidget {
  final dynamic icon;
  final String label;
  final String? subtitle;
  final bool badgeConnected, showInfo, isLast, loading, enabled;
  final VoidCallback onTap;
  const _NavItem({required this.icon, required this.label, required this.onTap,
      this.subtitle, this.badgeConnected = false,
      this.showInfo = false, this.isLast = false, this.loading = false,
      this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;

    Widget iconWidget;
    if (icon is Widget) {
      iconWidget = Container(
        constraints: const BoxConstraints(
          maxHeight: 38,
          maxWidth: 120,
        ),
        child: icon as Widget,
      );
    } else if (icon is String) {
      iconWidget = Text(icon as String, style: const TextStyle(fontSize: 22));
    } else {
      iconWidget = const SizedBox(width: 24, height: 24);
    }

    return Opacity(
      opacity: enabled ? 1.0 : 0.5,
      child: Column(children: [
      InkWell(
        onTap: onTap,
        borderRadius: isLast
            ? const BorderRadius.vertical(bottom: Radius.circular(13))
            : BorderRadius.zero,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(children: [
            iconWidget,
            const SizedBox(width: 14),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (label.isNotEmpty)
                  Text(label, style: TextStyle(color: theme.text, fontSize: 15)),
                if (subtitle != null)
                  Text(subtitle!, style: TextStyle(
                      color: theme.greenText, fontSize: 12)),
              ])),
            if (showInfo) ...[
              Icon(Icons.info_outline, color: theme.textMuted, size: 16),
              const SizedBox(width: 8),
            ],
            if (loading)
              SizedBox(width: 20, height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: theme.primary))
            else if (badgeConnected)
              Container(width: 8, height: 8,
                  decoration: BoxDecoration(
                      color: theme.greenText, shape: BoxShape.circle))
            else
              Icon(Icons.chevron_right, color: theme.textMuted, size: 20),
          ]),
        ),
      ),
      if (!isLast) Divider(color: theme.border, height: 1, indent: 52),
    ]));
  }
}
