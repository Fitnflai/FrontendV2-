import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../providers/notification_provider.dart';
import '../../l10n/app_localizations.dart';
import '../../models/notification.dart' as notif_model; // Alias for custom Notification model

class NotificationsPanelScreen extends StatefulWidget {
  const NotificationsPanelScreen({super.key});

  @override
  State<NotificationsPanelScreen> createState() => _NotificationsPanelScreenState();
}

class _NotificationsPanelScreenState extends State<NotificationsPanelScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProvider = context.read<AuthProvider>();
      if (authProvider.token != null) {
        context.read<NotificationProvider>().loadNotifications(authProvider.token!); // Load notifications when screen initializes
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final provider = context.watch<NotificationProvider>();
    final List<notif_model.Notification> notifs   = provider.all;

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: AppBar(
        backgroundColor: theme.card,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios_new,
              color: theme.orange, size: 18),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(AppLocalizations.of(context).notificationsPanelTitle,
            style: TextStyle(color: theme.text,
                fontSize: 16, fontWeight: FontWeight.w700)),
        actions: [
          if (provider.hasUnread)
            TextButton(
                            onPressed: () {
                final authProvider = context.read<AuthProvider>();
                if (authProvider.token != null) {
                  provider.marcarTodasLeidas(authProvider.token!);  
                }
              },
              child: Text(AppLocalizations.of(context).notificationsPanelMarkAll,
                  style: TextStyle(color: theme.orange,
                      fontSize: 12, fontWeight: FontWeight.w600)),
            ),
        ],
      ),
      body: notifs.isEmpty
          ? const _EmptyNotifications()
          : ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: notifs.length,
              separatorBuilder: (_, __) => const SizedBox(height: 8),
              itemBuilder: (_, i) => _NotificationTile(
                notif: notifs[i],
                onTap: () => provider.marcarLeida(notifs[i].id),
                onDismiss: () => provider.eliminar(notifs[i].id),
              ),
            ),
    );
  }
}

// ── Empty state ───────────────────────────────────────────────
class _EmptyNotifications extends StatelessWidget {
  const _EmptyNotifications();
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Center(
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('🔔', style: TextStyle(fontSize: 48)),
        const SizedBox(height: 12),
        Text(AppLocalizations.of(context).notificationsPanelEmptyTitle,
            style: TextStyle(color: theme.text, fontSize: 18,
                fontWeight: FontWeight.w700)),
        const SizedBox(height: 6),
        Text(AppLocalizations.of(context).notificationsPanelEmptyDesc,
            style: TextStyle(color: theme.textMuted, fontSize: 13)),
      ]),
    );
  }
}

// ── Notification Tile ─────────────────────────────────────────
class _NotificationTile extends StatelessWidget {
  final notif_model.Notification notif; // Changed to new Notification model
  final VoidCallback onTap, onDismiss;
  const _NotificationTile({
    required this.notif,
    required this.onTap,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Dismissible(
      key: Key(notif.id),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => onDismiss(),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: theme.redMid,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_outline, color: Colors.white),
      ),
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: notif.read ? theme.card : (Theme.of(context).brightness == Brightness.dark ? const Color(0xFF1A1208) : const Color(0xFFFFF5EA)),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: notif.read ? theme.border : theme.orange.withValues(alpha: 0.4),
            ),
          ),
          child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            // Ícono tipo
            Container(
              width: 38, height: 38,
              decoration: BoxDecoration(
                color: _tipoColor(notif.type, theme).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(child: Text(_tipoIcon(notif.type),
                  style: const TextStyle(fontSize: 18))),
            ),
            const SizedBox(width: 12),
            // Contenido
            Expanded(child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(children: [
                  Expanded(child: Text(notif.title,
                      style: TextStyle(
                          color: notif.read
                              ? theme.textSecondary : theme.text,
                          fontSize: 13,
                          fontWeight: notif.read
                              ? FontWeight.w500 : FontWeight.w700))),
                  if (!notif.read)
                    Container(
                      width: 8, height: 8,
                      decoration: BoxDecoration(
                          color: theme.orange, shape: BoxShape.circle),
                    ),
                ]),
                const SizedBox(height: 3),
                Text(notif.body,
                    style: TextStyle(color: theme.textMuted,
                        fontSize: 12, height: 1.4)),
                const SizedBox(height: 6),
                Text(_timeAgo(notif.createdAt, context),
                    style: TextStyle(color: theme.border,
                        fontSize: 10)),
              ],
            )),
          ]),
        ),
      ),
    );
  }
}

Color _tipoColor(String tipo, AppThemeExtensionWrapper theme) {
  switch (tipo) {
    case 'entrenamiento': return theme.orange;
    case 'logro':         return const Color(0xFFFFD700);
    case 'plan':          return const Color(0xFF4A90D9);
    default:              return theme.textMuted;
  }
}

String _tipoIcon(String tipo) {
  switch (tipo) {
    case 'entrenamiento': return '🏃';
    case 'logro':         return '🏆';
    case 'plan':          return '📋';
    default:              return '🔔';
  }
}

String _timeAgo(DateTime dt, BuildContext context) {
  final diff = DateTime.now().difference(dt);
  final l10n = AppLocalizations.of(context);
  if (diff.inMinutes < 1) return l10n.timeAgoJustNow;
  if (diff.inMinutes < 60) return l10n.timeAgoMinutes(diff.inMinutes);
  if (diff.inHours   < 24) return l10n.timeAgoHours(diff.inHours);
  if (diff.inDays    == 1) return l10n.timeAgoDays(1);
  return l10n.timeAgoDaysPlural(diff.inDays);
}
