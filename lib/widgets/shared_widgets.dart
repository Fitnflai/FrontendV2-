import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import '../services/cached_http.dart';
import '../config/app_theme_extension.dart';
import '../config/app_routes.dart';
import '../l10n/app_localizations.dart';
import '../providers/auth_provider.dart';
import '../providers/notification_provider.dart';

import '../providers/theme_provider.dart';

// ─── Logo ──────────────────────────────────────────────────────
class FitnflaiLogo extends StatelessWidget {
  final double fontSize;
  const FitnflaiLogo({super.key, this.fontSize = 34});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Image.asset(
      'assets/images/logo.png',
      height: fontSize * 1.1,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Text(
        'Fitnflai',
        style: TextStyle(
          color: theme.orange,
          fontSize: fontSize,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

// ─── Primary Button ────────────────────────────────────────────
class PrimaryButton extends StatelessWidget {
  final Widget labelWidget;
  final VoidCallback? onTap;
  final Widget? leading;
  final bool enabled;
  const PrimaryButton({
    super.key,
    required this.labelWidget,
    this.onTap,
    this.leading,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? theme.orange : theme.disabledBg,
          disabledBackgroundColor: theme.disabledBg,
          foregroundColor: theme.white,
          disabledForegroundColor: theme.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: enabled
                ? BorderSide.none
                : BorderSide(color: theme.border),
          ),
          elevation: 0,
        ),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          if (leading != null) ...[leading!, const SizedBox(width: 10)],
          labelWidget,
          const SizedBox(width: 8),
          const Icon(Icons.chevron_right, size: 20),
        ]),
      ),
    );
  }
}

// ─── Social Button ─────────────────────────────────────────────
class SocialButton extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;
  const SocialButton({super.key, required this.label, required this.icon, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: OutlinedButton(
        onPressed: onTap,
        style: OutlinedButton.styleFrom(
          backgroundColor: theme.card,
          foregroundColor: theme.greyLight,
          side: BorderSide(color: theme.border),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
          padding: const EdgeInsets.symmetric(horizontal: 18),
          alignment: Alignment.centerLeft,
        ),
        child: Row(children: [
          icon,
          const SizedBox(width: 14),
          Text(label,
              style: TextStyle(
                  color: theme.greyLight,
                  fontSize: 15,
                  fontWeight: FontWeight.w500)),
          const Spacer(),
          Icon(Icons.chevron_right, color: theme.grey, size: 20),
        ]),
      ),
    );
  }
}

// ─── Text Field ────────────────────────────────────────────────
class AppTextField extends StatefulWidget {
  final String hint;
  final bool obscure;
  final TextInputType keyboardType;
  final TextEditingController? controller;
  final String? Function(String?)? validator;
  final Widget? prefixIcon;
  const AppTextField({
    required this.hint,
    this.obscure = false,
    this.keyboardType = TextInputType.text,
    this.controller,
    this.validator,
    this.prefixIcon,
    super.key,
  });
  @override State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _vis = false;
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.obscure && !_vis,
      keyboardType: widget.keyboardType,
      validator: widget.validator,
      style: TextStyle(color: theme.text, fontSize: 15),
      decoration: InputDecoration(
        hintText: widget.hint,
        hintStyle: TextStyle(color: theme.textMuted, fontSize: 15),
        prefixIcon: widget.prefixIcon,
        suffixIcon: widget.obscure
            ? IconButton(
                icon: Icon(_vis ? Icons.visibility_off : Icons.visibility,
                    color: theme.textMuted, size: 20),
                onPressed: () => setState(() => _vis = !_vis))
            : null,
        filled: true,
        fillColor: theme.card,
        contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.border)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.border)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.orange, width: 1.5)),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.errorText, width: 1.5)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: theme.errorText, width: 1.5)),
        errorStyle: TextStyle(color: theme.errorText, fontSize: 12),
      ),
    );
  }
}

// ─── Check Icon ────────────────────────────────────────────────
class CheckIcon extends StatelessWidget {
  final bool checked;
  const CheckIcon({super.key, required this.checked});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      width: 24, height: 24,
      decoration: BoxDecoration(
        color: checked ? theme.orange : Colors.transparent,
        shape: BoxShape.circle,
        border: Border.all(
            color: checked ? theme.orange : theme.border, width: 1.5),
      ),
      child: checked ? Icon(Icons.check, color: theme.white, size: 14) : null,
    );
  }
}

// ─── Section Card ──────────────────────────────────────────────
class SectionCard extends StatelessWidget {
  final Widget child;
  const SectionCard({super.key, required this.child});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 14),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
          color: theme.card, borderRadius: BorderRadius.circular(14)),
      child: child,
    );
  }
}

// ─── Badge ─────────────────────────────────────────────────────
class AppBadge extends StatelessWidget {
  final String label;
  final Color bg;
  final Color textColor;
  final bool dot;
  const AppBadge({
    required this.label,
    required this.bg,
    required this.textColor,
    this.dot = true,
    super.key,
  });
  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
    decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
    child: Row(mainAxisSize: MainAxisSize.min, children: [
      if (dot) ...[CircleAvatar(radius: 3, backgroundColor: textColor), const SizedBox(width: 5)],
      Text(label, style: TextStyle(color: textColor, fontSize: 11, fontWeight: FontWeight.w600)),
    ]),
  );
}

// ─── Sel Chip ──────────────────────────────────────────────────
class SelChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  const SelChip({required this.label, required this.selected, required this.onTap, super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? theme.orange : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: selected ? theme.orange : theme.border, width: 1.5),
        ),
        child: Text(label,
            style: TextStyle(
                color: selected ? theme.white : theme.greyLight,
                fontSize: 13,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w400)),
      ),
    );
  }
}

// ─── App Bar ───────────────────────────────────────────────────
class FitnflaiAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final VoidCallback? onBack;
  const FitnflaiAppBar({required this.title, this.onBack, super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return AppBar(
      backgroundColor: theme.bg,
      elevation: 0,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: theme.border)),
          child: Icon(Icons.arrow_back_ios_new, color: theme.white, size: 16),
        ),
        onPressed: onBack ?? () => Navigator.pop(context),
      ),
      title: Text(title,
          style: TextStyle(
              color: theme.white, fontSize: 16, fontWeight: FontWeight.w600)),
      centerTitle: true,
    );
  }
}

// ─── Step Header ───────────────────────────────────────────────
class StepHeader extends StatelessWidget {
  final String stepLabel;
  const StepHeader({required this.stepLabel, super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(children: [
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
                color: theme.card,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: theme.border)),
            child: Icon(Icons.arrow_back_ios_new, color: theme.orange, size: 16),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        const Spacer(),
        Text(stepLabel,
            style: TextStyle(
                color: theme.greyLight,
                fontSize: 14,
                fontWeight: FontWeight.w500)),
      ]),
    );
  }
}

// ─── Social icons ──────────────────────────────────────────────
Widget googleIcon() => const SocialSvgIcon(svgData: SocialSvgIcons.google, size: 24);

Widget appleIcon() => const SocialSvgIcon(svgData: SocialSvgIcons.apple, size: 24);

// ─── Auth Divider ──────────────────────────────────────────────
class AuthDivider extends StatelessWidget {
  const AuthDivider({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Row(children: [
      Expanded(child: Divider(color: theme.border)),
      Padding(padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text(AppLocalizations.of(context).authDividerOr, style: TextStyle(color: theme.grey, fontSize: 13))),
      Expanded(child: Divider(color: theme.border)),
    ]);
  }
}

// ─── Field Label ───────────────────────────────────────────────
class FieldLabel extends StatelessWidget {
  final String text;
  const FieldLabel({required this.text, super.key});
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Text(text,
        style: TextStyle(
            color: theme.greyLight, fontSize: 13, fontWeight: FontWeight.w600));
  }
}

// ─── Continue Button (dual state) ──────────────────────────────
class ContinueButton extends StatelessWidget {
  final bool enabled;
  final VoidCallback? onTap;
  final String activeLabel;
  final String inactiveLabel;
  const ContinueButton({
    required this.enabled,
    this.onTap,
    this.activeLabel = 'Continuar',
    this.inactiveLabel = 'Responde todas las preguntas para continuar',
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: enabled ? onTap : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? theme.orange : theme.disabledBg,
          disabledBackgroundColor: theme.disabledBg,
          foregroundColor: theme.white,
          disabledForegroundColor: theme.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
            side: enabled
                ? BorderSide.none
                : BorderSide(color: theme.border),
          ),
          elevation: 0,
        ),
        child: Text(
          enabled ? activeLabel : inactiveLabel,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: enabled ? 16 : 13,
            fontWeight: enabled ? FontWeight.w700 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
// ─── App Header (global) ───────────────────────────────────────
class AppHeader extends StatefulWidget {
  final String section;
  final bool showGreeting;
  final String? subtitle;

  const AppHeader({
    required this.section,
    this.showGreeting = false,
    this.subtitle,
    super.key,
  });

  @override
  State<AppHeader> createState() => _AppHeaderState();
}

class _AppHeaderState extends State<AppHeader> {

  String? _avatarUrl;
  String? _apodo;
  String? _disciplina;

  @override
  void initState() {
    super.initState();
    // Only load user data if not in test mode
    if (!CachedHttp.inTestMode) { // Use the static flag from CachedHttp
      Future.microtask(() => _loadUser());
    }
  }

  Future<void> _loadUser() async {
    final token = context.read<AuthProvider>().token;
    if (token == null) return;
    try {
      final res = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/users/me'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200 && mounted) {
        final d = jsonDecode(res.body) as Map<String, dynamic>;
        setState(() {
          _avatarUrl  = d['foto_avatar_url']  as String?;
          _apodo      = d['apodo']             as String?;
          _disciplina = d['nombre_disciplina'] as String?;
        });
        debugPrint('HEADER → avatarUrl: $_avatarUrl | apodo: $_apodo | disciplina: $_disciplina');
      }
    } catch (e) {
      debugPrint('HEADER LOAD ERROR: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final user    = context.watch<AuthProvider>().user;
    final themeProvider = context.watch<ThemeProvider>();

    final nombre  = _apodo ?? user?.apodo ?? user?.nombre ?? '';
    final inicial = nombre.isNotEmpty ? nombre[0].toUpperCase() : 'U';
    final sub     = widget.subtitle ?? _defaultSubtitle();
    final theme   = Theme.of(context).extension<AppThemeExtension>()!;

    final isEs = Localizations.localeOf(context).languageCode == 'es';
    final greeting = isEs ? 'Hola, ' : 'Hello, ';
    final prefix = isEs ? 'Mi ' : 'My ';

    return Container(
      padding: const EdgeInsets.fromLTRB(16, 5, 16, 10),
      decoration: BoxDecoration(
        color: theme.card,
        border: Border(bottom: BorderSide(color: theme.border)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Texto izquierda
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (widget.showGreeting) ...[
                  Row(children: [
                    Text(greeting,
                        style: TextStyle(
                            color: theme.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.1)),
                    Flexible(child: Text(nombre,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                            color: theme.primary,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            height: 1.1))),
                  ]),
                ] else
                  Text('$prefix${widget.section}',
                      style: TextStyle(
                          color: theme.white,
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          height: 1.1)),
                Text(sub,
                    style: TextStyle(color: theme.grey, fontSize: 11)),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // ── Columna: 3 puntos arriba, avatar+campana abajo ───
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ··· tres puntos (más grandes)
              SizedBox(
                height: 24,
                child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_horiz,
                    color: theme.grey, size: 26),
                color: theme.card,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                  side: BorderSide(color: theme.border),
                ),
                offset: const Offset(-8, 32),
                onSelected: (val) {
                  if (val == 'dark') {
                    themeProvider.toggleTheme(true);
                  } else if (val == 'light') {
                    themeProvider.toggleTheme(false);
                  } else if (val == 'config') {
                    if (!mounted) return;
                    Navigator.pushNamed(context, AppRoutes.reporteConfig);
                  }
                },
                itemBuilder: (_) => [

                  PopupMenuItem(
                    enabled: false, height: 32,
                    child: Text('MODO', style: TextStyle(
                        color: theme.primary, fontSize: 11,
                        fontWeight: FontWeight.w700, letterSpacing: 0.6)),
                  ),
                  PopupMenuItem(
                    value: 'dark', height: 44,
                    child: Row(children: [
                      Icon(Icons.dark_mode_outlined,
                          color: theme.grey, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text('Oscuro',
                          style: TextStyle(color: theme.white, fontSize: 14))),
                      if (themeProvider.isDarkMode)
                        Icon(Icons.check, color: theme.primary, size: 16),
                    ]),
                  ),
                  PopupMenuItem(
                    value: 'light', height: 44,
                    child: Row(children: [
                      Icon(Icons.light_mode_outlined,
                          color: theme.grey, size: 18),
                      const SizedBox(width: 10),
                      Expanded(child: Text('Claro',
                          style: TextStyle(color: theme.white, fontSize: 14))),
                      if (!themeProvider.isDarkMode)
                        Icon(Icons.check, color: theme.primary, size: 16),
                    ]),
                  ),
                  const PopupMenuDivider(),
                  PopupMenuItem(
                    value: 'config', height: 44,
                    child: Row(children: [
                      Icon(Icons.settings_outlined, color: theme.grey, size: 18),
                      const SizedBox(width: 10),
                      Text('Configuración',
                          style: TextStyle(color: theme.white, fontSize: 14)),
                    ]),
                  ),
                ],
              ),
              ),
              // Avatar + campana
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 38, height: 38,
                    decoration: BoxDecoration(
                        color: theme.primary,
                        shape: BoxShape.circle,
                        image: (_avatarUrl != null && _avatarUrl!.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(_avatarUrl!),
                                fit: BoxFit.cover)
                            : null),
                    child: (_avatarUrl == null || _avatarUrl!.isEmpty)
                        ? Center(child: Text(inicial,
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w700)))
                        : null,
                  ),
                  Positioned(
                    right: -4, bottom: -4,
                    child: Consumer<NotificationProvider>(
                      builder: (ctx, prov, __) => PopupMenuButton<String>(
                        padding: EdgeInsets.zero,
                        offset: const Offset(0, 32),
                        color: theme.card,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                          side: BorderSide(color: theme.border),
                        ),
                        onSelected: (val) {
                          final token = ctx.read<AuthProvider>().token;
                          if (val == 'read_all' && token != null) {
                            prov.marcarTodasLeidas(token);
                          }
                          if (val == 'view_all' || val.startsWith('notif_')) {
                            if (val.startsWith('notif_')) {
                              prov.marcarLeida(val.replaceFirst('notif_', ''));
                            }
                            Navigator.pushNamed(ctx, '/notifications');
                          }
                        },
                        itemBuilder: (_) {
                          final notifs = prov.all.take(3).toList();
                          return [
                            PopupMenuItem(
                              enabled: false, height: 36,
                              child: Row(children: [
                                Expanded(child: Text('Notificaciones',
                                    style: TextStyle(color: theme.white,
                                        fontSize: 13, fontWeight: FontWeight.w700))),
                                if (prov.hasUnread)
                                  GestureDetector(
                                    onTap: () {
                                      final token = ctx.read<AuthProvider>().token;
                                      if (token != null) {
                                        prov.marcarTodasLeidas(token);
                                      }
                                    },
                                    child: Text('Marcar todas',
                                        style: TextStyle(color: theme.primary,
                                            fontSize: 11, fontWeight: FontWeight.w600)),
                                  ),
                              ]),
                            ),
                            const PopupMenuDivider(),
                            if (notifs.isEmpty)
                              PopupMenuItem(
                                enabled: false, height: 44,
                                child: Row(children: [
                                  const Text('🔔', style: TextStyle(fontSize: 16)),
                                  const SizedBox(width: 8),
                                  Text('Sin notificaciones nuevas',
                                      style: TextStyle(color: theme.grey,
                                          fontSize: 12)),
                                ]),
                              )
                            else
                              ...notifs.map((n) => PopupMenuItem<String>(
                                value: 'notif_${n.id}',
                                height: 52,
                                child: Row(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                  Text(n.tipo == 'entrenamiento' ? '🏃'
                                      : n.tipo == 'logro' ? '🏆'
                                      : n.tipo == 'plan' ? '📋' : '🔔',
                                      style: const TextStyle(fontSize: 16)),
                                  const SizedBox(width: 8),
                                  Expanded(child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                    Text(n.titulo, maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: n.leida ? theme.greyLight
                                                : theme.white,
                                            fontSize: 12,
                                            fontWeight: n.leida
                                                ? FontWeight.w400 : FontWeight.w600)),
                                    Text(n.cuerpo, maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: theme.grey, fontSize: 11)),
                                  ])),
                                  if (!n.leida)
                                    Container(width: 7, height: 7,
                                        margin: const EdgeInsets.only(top: 4, left: 4),
                                        decoration: BoxDecoration(
                                            color: theme.primary,
                                            shape: BoxShape.circle)),
                                ]),
                              )),
                            const PopupMenuDivider(),
                            PopupMenuItem<String>(
                              value: 'view_all', height: 40,
                              child: Center(child: Text(
                                  'Ver todas las notificaciones',
                                  style: TextStyle(color: theme.primary,
                                      fontSize: 13, fontWeight: FontWeight.w600))),
                            ),
                          ];
                        },
                        child: Stack(clipBehavior: Clip.none, children: [
                          const Text('🔔', style: TextStyle(fontSize: 14)),
                          if (prov.hasUnread)
                            Positioned(
                              right: -2, top: -2,
                              child: Container(
                                width: 7, height: 7,
                                decoration: BoxDecoration(
                                    color: theme.redText,
                                    shape: BoxShape.circle),
                              ),
                            ),
                        ]),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _defaultSubtitle() {
    final user       = context.read<AuthProvider>().user;
    final disciplina = (_disciplina?.isNotEmpty == true)
        ? _disciplina!
        : (user?.nombreDisciplina?.isNotEmpty == true)
            ? user!.nombreDisciplina!
            : (user?.objetivoPrincipal?.isNotEmpty == true)
                ? user!.objetivoPrincipal!
                : '';

    final fechaStr = user?.fechaInicioPreferida;
    String activo  = '';
    if (fechaStr != null && fechaStr.isNotEmpty) {
      try {
        final inicio = DateTime.parse(fechaStr);
        final diff   = DateTime.now().difference(inicio).inDays;
        if (diff < 0) {
          final faltan = diff.abs();
          activo = faltan == 1 ? 'Empieza mañana' : 'Empieza en $faltan días';
        } else if (diff == 0) {
          activo = '¡Hoy empieza!';
        } else if (diff < 7) {
          activo = 'Día ${diff + 1}';
        } else {
          final sem = (diff / 7).floor();
          activo = 'Semana $sem';
        }
      } catch (_) {}
    }

    if (disciplina.isNotEmpty && activo.isNotEmpty) return '$disciplina / $activo';
    if (disciplina.isNotEmpty) return disciplina;
    if (activo.isNotEmpty) return activo;
    return '';
  }
}
class CoachCommentCard extends StatelessWidget {
  final String comentario;
  final String tipo;
  final bool isElite;
  const CoachCommentCard({
    super.key,
    required this.comentario,
    required this.tipo,
    required this.isElite,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<AppThemeExtension>()!;

    final bool isRestDay = tipo.toLowerCase() == 'descanso';

    final Color cardBg = isRestDay ? theme.vuelta.bg : theme.primary.withValues(alpha: 0.08);
    final Border cardBorder = isRestDay
        ? Border.all(color: theme.vuelta.border, width: 1.2)
        : Border.all(color: theme.primary.withValues(alpha: 0.25), width: 1.0);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(16),
        border: cardBorder,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar del coach
          if (isElite)
            Container(
              width: 46, height: 46,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Color(0xFFF1A80A),
                    Color(0xFFE8622A),
                    Color(0xFFD62A8A),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              alignment: Alignment.center,
              child: Container(
                width: 42, height: 42, // Inner circle for background
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: theme.cardDark,
                ),
                child: Icon(Icons.person, color: theme.primary, size: 24),
              ),
            )
          else
            ClipRRect(
              borderRadius: BorderRadius.circular(23),
              child: Image.asset(
                'assets/images/favicon.png',
                width: 46, height: 46,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  width: 46, height: 46,
                  color: theme.cardDark,
                  child: Icon(Icons.fitness_center, color: theme.primary, size: 24),
                ),
              ),
            ),
          const SizedBox(width: 16),

          // Mensaje del coach
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "COACH FITNFLAI".toUpperCase(),
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: theme.primary,
                    letterSpacing: 0.8,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  comentario,
                  style: TextStyle(
                    fontSize: 13,
                    color: theme.greyLight,
                    height: 1.45,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class SocialSvgIcons {
  static const String facebook = r'''<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_17_24)">
<path d="M48 24C48 10.7453 37.2547 0 24 0C10.7453 0 0 10.7453 0 24C0 35.255 7.74912 44.6995 18.2026 47.2934V31.3344H13.2538V24H18.2026V20.8397C18.2026 12.671 21.8995 8.8848 29.9194 8.8848C31.44 8.8848 34.0637 9.18336 35.137 9.48096V16.129C34.5706 16.0694 33.5866 16.0397 32.3645 16.0397C28.4294 16.0397 26.9088 17.5306 26.9088 21.4061V24H34.7482L33.4013 31.3344H26.9088V47.8243C38.7926 46.3891 48.001 36.2707 48.001 24H48Z" fill="#0866FF"/>
<path d="M33.4003 31.3344L34.7472 24H26.9078V21.4061C26.9078 17.5306 28.4285 16.0397 32.3635 16.0397C33.5856 16.0397 34.5696 16.0694 35.136 16.129V9.48096C34.0627 9.1824 31.439 8.8848 29.9184 8.8848C21.8986 8.8848 18.2016 12.671 18.2016 20.8397V24H13.2528V31.3344H18.2016V47.2934C20.0582 47.7542 22.0003 48 23.999 48C24.983 48 25.9536 47.9395 26.9069 47.8243V31.3344H33.3994H33.4003Z" fill="white"/>
</g>
<defs>
<clipPath id="clip0_17_24">
<rect width="48" height="48" fill="white"/>
</clipPath>
</defs>
</svg>''';

  static const String x = r'''<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
<path d="M36.6526 3.80782H43.3995L28.6594 20.6548L46 43.5798H32.4225L21.7881 29.6759L9.61989 43.5798H2.86886L18.6349 25.56L2 3.80782H15.9222L25.5348 16.5165L36.6526 3.80782ZM34.2846 39.5414H38.0232L13.8908 7.63408H9.87892L34.2846 39.5414Z" fill="white"/>
</svg>''';

  static const String instagram = r'''<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_17_27)">
<path d="M24 4.32187C30.4125 4.32187 31.1719 4.35 33.6938 4.4625C36.0375 4.56562 37.3031 4.95938 38.1469 5.2875C39.2625 5.71875 40.0688 6.24375 40.9031 7.07812C41.7469 7.92188 42.2625 8.71875 42.6938 9.83438C43.0219 10.6781 43.4156 11.9531 43.5188 14.2875C43.6313 16.8187 43.6594 17.5781 43.6594 23.9813C43.6594 30.3938 43.6313 31.1531 43.5188 33.675C43.4156 36.0188 43.0219 37.2844 42.6938 38.1281C42.2625 39.2438 41.7375 40.05 40.9031 40.8844C40.0594 41.7281 39.2625 42.2438 38.1469 42.675C37.3031 43.0031 36.0281 43.3969 33.6938 43.5C31.1625 43.6125 30.4031 43.6406 24 43.6406C17.5875 43.6406 16.8281 43.6125 14.3063 43.5C11.9625 43.3969 10.6969 43.0031 9.85313 42.675C8.7375 42.2438 7.93125 41.7188 7.09688 40.8844C6.25313 40.0406 5.7375 39.2438 5.30625 38.1281C4.97813 37.2844 4.58438 36.0094 4.48125 33.675C4.36875 31.1438 4.34063 30.3844 4.34063 23.9813C4.34063 17.5688 4.36875 16.8094 4.48125 14.2875C4.58438 11.9437 4.97813 10.6781 5.30625 9.83438C5.7375 8.71875 6.2625 7.9125 7.09688 7.07812C7.94063 6.23438 8.7375 5.71875 9.85313 5.2875C10.6969 4.95938 11.9719 4.56562 14.3063 4.4625C16.8281 4.35 17.5875 4.32187 24 4.32187ZM24 0C17.4844 0 16.6688 0.028125 14.1094 0.140625C11.5594 0.253125 9.80625 0.665625 8.2875 1.25625C6.70312 1.875 5.3625 2.69062 4.03125 4.03125C2.69063 5.3625 1.875 6.70313 1.25625 8.27813C0.665625 9.80625 0.253125 11.55 0.140625 14.1C0.028125 16.6687 0 17.4844 0 24C0 30.5156 0.028125 31.3312 0.140625 33.8906C0.253125 36.4406 0.665625 38.1938 1.25625 39.7125C1.875 41.2969 2.69063 42.6375 4.03125 43.9688C5.3625 45.3 6.70313 46.125 8.27813 46.7344C9.80625 47.325 11.55 47.7375 14.1 47.85C16.6594 47.9625 17.475 47.9906 23.9906 47.9906C30.5063 47.9906 31.3219 47.9625 33.8813 47.85C36.4313 47.7375 38.1844 47.325 39.7031 46.7344C41.2781 46.125 42.6188 45.3 43.95 43.9688C45.2812 42.6375 46.1063 41.2969 46.7156 39.7219C47.3063 38.1938 47.7188 36.45 47.8313 33.9C47.9438 31.3406 47.9719 30.525 47.9719 24.0094C47.9719 17.4938 47.9438 16.6781 47.8313 14.1188C47.7188 11.5688 47.3063 9.81563 46.7156 8.29688C46.125 6.70312 45.3094 5.3625 43.9688 4.03125C42.6375 2.7 41.2969 1.875 39.7219 1.26562C38.1938 0.675 36.45 0.2625 33.9 0.15C31.3313 0.028125 30.5156 0 24 0Z" fill="white"/>
<path d="M24 11.6719C17.1938 11.6719 11.6719 17.1938 11.6719 24C11.6719 30.8062 17.1938 36.3281 24 36.3281C30.8062 36.3281 36.3281 30.8062 36.3281 24C36.3281 17.1938 30.8062 11.6719 24 11.6719ZM24 31.9969C19.5844 31.9969 16.0031 28.4156 16.0031 24C16.0031 19.5844 19.5844 16.0031 24 16.0031C28.4156 16.0031 31.9969 19.5844 31.9969 24C31.9969 28.4156 28.4156 31.9969 24 31.9969Z" fill="white"/>
<path d="M39.6937 11.1844C39.6937 12.7782 38.4 14.0625 36.8156 14.0625C35.2219 14.0625 33.9375 12.7688 33.9375 11.1844C33.9375 9.59065 35.2313 8.30627 36.8156 8.30627C38.4 8.30627 39.6937 9.60003 39.6937 11.1844Z" fill="white"/>
</g>
<defs>
<clipPath id="clip0_17_27">
<rect width="48" height="48" fill="white"/>
</clipPath>
</defs>
</svg>''';

  static const String linkedin = r'''<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_17_32)">
<path d="M44.4567 0H3.54333C2.60358 0 1.70232 0.373315 1.03782 1.03782C0.373315 1.70232 0 2.60358 0 3.54333V44.4567C0 45.3964 0.373315 46.2977 1.03782 46.9622C1.70232 47.6267 2.60358 48 3.54333 48H44.4567C45.3964 48 46.2977 47.6267 46.9622 46.9622C47.6267 46.2977 48 45.3964 48 44.4567V3.54333C48 2.60358 47.6267 1.70232 46.9622 1.03782C46.2977 0.373315 45.3964 0 44.4567 0ZM14.3067 40.89H7.09V17.9667H14.3067V40.89ZM10.6933 14.79C9.87473 14.7854 9.07583 14.5384 8.39747 14.0802C7.71911 13.622 7.19168 12.9731 6.88175 12.2154C6.57183 11.4577 6.4933 10.6252 6.65606 9.82291C6.81883 9.02063 7.2156 8.28455 7.79631 7.70756C8.37702 7.13057 9.11563 6.73853 9.91893 6.58092C10.7222 6.42331 11.5542 6.50719 12.3099 6.82197C13.0656 7.13675 13.7111 7.66833 14.1649 8.34962C14.6188 9.03092 14.8606 9.83138 14.86 10.65C14.8677 11.1981 14.765 11.7421 14.558 12.2496C14.351 12.7571 14.044 13.2178 13.6551 13.6041C13.2663 13.9905 12.8037 14.2946 12.2948 14.4983C11.786 14.702 11.2413 14.8012 10.6933 14.79ZM40.9067 40.91H33.6933V28.3867C33.6933 24.6933 32.1233 23.5533 30.0967 23.5533C27.9567 23.5533 25.8567 25.1667 25.8567 28.48V40.91H18.64V17.9833H25.58V21.16H25.6733C26.37 19.75 28.81 17.34 32.5333 17.34C36.56 17.34 40.91 19.73 40.91 26.73L40.9067 40.91Z" fill="#0A66C2"/>
</g>
<defs>
<clipPath id="clip0_17_32">
<rect width="48" height="48" fill="white"/>
</clipPath>
</defs>
</svg>''';

  static const String telegram = r'''<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
<g clip-path="url(#clip0_318_61)">
<path d="M24 48C37.2548 48 48 37.2548 48 24C48 10.7452 37.2548 0 24 0C10.7452 0 0 10.7452 0 24C0 37.2548 10.7452 48 24 48Z" fill="url(#paint0_linear_318_61)"/>
<path fill-rule="evenodd" clip-rule="evenodd" d="M10.8638 23.7466C17.8603 20.6984 22.5257 18.6888 24.8601 17.7179C31.5251 14.9456 32.91 14.4641 33.8127 14.4482C34.0113 14.4447 34.4552 14.4939 34.7427 14.7272C34.9855 14.9242 35.0523 15.1904 35.0843 15.3771C35.1163 15.5639 35.1561 15.9895 35.1244 16.3219C34.7633 20.1169 33.2004 29.3263 32.4053 33.5767C32.0689 35.3752 31.4065 35.9783 30.7652 36.0373C29.3714 36.1655 28.3131 35.1162 26.9632 34.2313C24.8509 32.8467 23.6576 31.9847 21.6072 30.6336C19.2377 29.0721 20.7738 28.2139 22.1242 26.8113C22.4776 26.4442 28.6183 20.8587 28.7372 20.352C28.7521 20.2886 28.7659 20.0524 28.6255 19.9277C28.4852 19.803 28.2781 19.8456 28.1286 19.8795C27.9168 19.9276 24.5423 22.158 18.0053 26.5707C17.0475 27.2284 16.1799 27.5489 15.4026 27.5321C14.5457 27.5135 12.8973 27.0475 11.6719 26.6492C10.1689 26.1606 8.97432 25.0726 9.07834 25.0726C9.13252 24.6404 9.72767 24.1984 10.8638 23.7466Z" fill="white"/>
  </g>
  <defs>
  <linearGradient id="paint0_linear_318_61" x1="24" y1="0" x2="24" y2="47.644" gradientUnits="userSpaceOnUse">
  <stop stop-color="#2AABEE"/>
  <stop offset="1" stop-color="#229ED9"/>
  </linearGradient>
  <clipPath id="clip0_318_61">
  <rect width="48" height="48" fill="white"/>
  </clipPath>
  </defs>
  </svg>''';

  static const String google = r'''<svg width="48" height="48" viewBox="0 0 48 48" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M44.5 24.57c0-1.57-.14-3.08-.4-4.57H24v8.65h11.51c-.5 2.67-1.99 4.93-4.25 6.44v5.35h6.88C42.17 36.65 44.5 31.24 44.5 24.57z" fill="#4285F4"/>
  <path d="M24 45.43c5.81 0 10.68-1.92 14.24-5.21l-6.88-5.35c-1.91 1.28-4.35 2.04-7.36 2.04-5.66 0-10.45-3.82-12.16-8.96H4.72v5.53C8.28 40.56 15.64 45.43 24 45.43z" fill="#34A853"/>
  <path d="M11.84 27.95c-.44-1.28-.69-2.65-.69-4.07s.25-2.79.69-4.07v-5.53H4.72C3.19 17.31 2.33 20.5 2.33 23.88s.86 6.57 2.39 9.61l7.12-5.54z" fill="#FBBC05"/>
  <path d="M24 10.96c3.16 0 5.99 1.09 8.22 3.22l6.16-6.16C34.67 4.7 29.81 2.33 24 2.33 15.64 2.33 8.28 7.2 4.72 14.28l7.12 5.54c1.71-5.14 6.5-8.96 12.16-8.96z" fill="#EA4335"/>
</svg>''';

  static const String apple = r'''<svg width="24" height="24" viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg">
  <path d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 2.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M15.97 4.17c.66-.81 1.11-1.93.99-3.06-1 .04-2.21.67-2.93 1.49-.62.69-1.16 1.84-1.01 2.96 1.12.09 2.27-.57 2.95-1.39z" fill="white"/>
</svg>''';
}

class SocialSvgIcon extends StatelessWidget {
  final String svgData;
  final double size;
  const SocialSvgIcon({super.key, required this.svgData, this.size = 20});

  @override
  Widget build(BuildContext context) {
    return SvgPicture.string(
      svgData,
      width: size,
      height: size,
    );
  }
}
