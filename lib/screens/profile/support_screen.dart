import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme_extension.dart';
import '../../widgets/shared_widgets.dart';

class SupportScreen extends StatefulWidget {
  final String? initialSubject;
  const SupportScreen({super.key, this.initialSubject});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> with WidgetsBindingObserver {
  int? _openFaq;
  bool _waitingForEmailReturn = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (widget.initialSubject != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showSupportForm(context);
      });
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed && _waitingForEmailReturn) {
      _waitingForEmailReturn = false;
      _showSuccessDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = context.themeColors;
    final faqs = [
      (l10n.supportFaqQ1, l10n.supportFaqA1),
      (l10n.supportFaqQ2, l10n.supportFaqA2),
      (l10n.supportFaqQ3, l10n.supportFaqA3),
      (l10n.supportFaqQ4, l10n.supportFaqA4),
      (l10n.supportFaqQ5, l10n.supportFaqA5),
      (l10n.supportFaqQ6, l10n.supportFaqA6),
    ];

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: l10n.supportTitle),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [

          // ── Hero ────────────────────────────────────────────────
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.card,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: theme.border),
            ),
            child: Column(children: [
              const Text('🎧', style: TextStyle(fontSize: 40)),
              const SizedBox(height: 12),
              Text(l10n.supportHelpHeader,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.text, fontSize: 20,
                      fontWeight: FontWeight.w800)),
              const SizedBox(height: 6),
              Text(l10n.supportHelpSub,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: theme.textMuted, fontSize: 13, height: 1.5)),
            ]),
          ),
          const SizedBox(height: 24),

          // ── Contacto directo ─────────────────────────────────────
          _sectionLabel(l10n.supportContact),
          const SizedBox(height: 10),
          _ContactCard(
            icon: Icons.email_outlined,
            title: l10n.supportEmail,
            subtitle: 'info@fitnflai.com',
            badge: '24–48h',
            badgeColor: theme.orange,
            onTap: () => _showSupportForm(context),
          ),
          const SizedBox(height: 24),

          // ── FAQ ───────────────────────────────────────────────────
          _sectionLabel(l10n.supportFaqs),
          const SizedBox(height: 10),
          ...faqs.asMap().entries.map((e) => _FaqTile(
            index:    e.key,
            question: e.value.$1,
            answer:   e.value.$2,
            isOpen:   _openFaq == e.key,
            isLast:   e.key == faqs.length - 1,
            onTap:    () => setState(() =>
                _openFaq = _openFaq == e.key ? null : e.key),
          )),
          const SizedBox(height: 24),

          // ── Redes sociales ────────────────────────────────────────
          _sectionLabel(l10n.supportFollowUs),
          const SizedBox(height: 10),
          Row(children: [
            Expanded(child: _SocialBtn(
              icon: const SocialSvgIcon(svgData: SocialSvgIcons.facebook, size: 22), label: 'Facebook',
              onTap: () => _launch('https://www.facebook.com/profile.php?id=61593229000325&mibextid=wwXIfr&rdid=sTyvzMS3lpiXv5Ul&share_url=https%3A%2F%2Fwww.facebook.com%2Fshare%2F1MMtubbg3W%2F%3Fmibextid%3DwwXIfr#'),
            )),
            const SizedBox(width: 10),
            Expanded(child: _SocialBtn(
              icon: const SocialSvgIcon(svgData: SocialSvgIcons.instagram, size: 22), label: 'Instagram',
              onTap: () => _launch('https://instagram.com/fitnflai'),
            )),
            const SizedBox(width: 10),
            Expanded(child: _SocialBtn(
              icon: const SocialSvgIcon(svgData: SocialSvgIcons.tiktok, size: 20), label: 'TikTok',
              onTap: () => _launch('https://www.tiktok.com/@fit.n.flai?_r=1&_t=ZS-9A7asfhayHM'),
            )),
          ]),
          const SizedBox(height: 24),

          // ── Versión ───────────────────────────────────────────────
          Center(
            child: Column(children: [
              Text('Fitnflai',
                  style: TextStyle(color: theme.textMuted, fontSize: 13,
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 2),
              Text(l10n.supportVersion('1.0.0'),
                  style: TextStyle(color: theme.border, fontSize: 11)),
            ]),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }

  Widget _sectionLabel(String text) {
    final theme = context.themeColors;
    return Text(text,
        style: TextStyle(color: theme.textMuted, fontSize: 11,
            fontWeight: FontWeight.w700, letterSpacing: 0.8));
  }

  Future<void> _launch(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) launchUrl(uri);
  }

  void _showSupportForm(BuildContext context) {
    final theme = context.themeColors;
    final authProvider = context.read<AuthProvider>();
    final user = authProvider.user;

    final nombre = user?.nombre ?? 'No especificado';
    final email = user?.email ?? 'No especificado';
    final membresia = user?.nombrePlanActivo ?? 'Ninguna / TRIAL';
    final userId = user?.id ?? 'No especificado';

    String? selectedSubject = widget.initialSubject ?? 'Problemas con mi entrenamiento';
    final messageController = TextEditingController();

    final List<String> subjects = [
      'Problemas con mi entrenamiento',
      'Problemas con mi especialista',
      'Problemas con mi perfil',
      'Reembolso',
      'Otros',
    ];

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setDialogState) {
            return AlertDialog(
              backgroundColor: theme.card,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: BorderSide(color: theme.border),
              ),
              title: Row(
                children: [
                  Icon(Icons.email_outlined, color: theme.orange, size: 24),
                  const SizedBox(width: 8),
                  const Text(
                    'Formulario de Soporte',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Asunto:',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      decoration: BoxDecoration(
                        color: theme.cardDark,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: theme.border),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: selectedSubject,
                          dropdownColor: theme.cardDark,
                          icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white70),
                          isExpanded: true,
                          style: const TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600),
                          items: subjects.map((s) {
                            return DropdownMenuItem<String>(
                              value: s,
                              child: Text(s),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setDialogState(() {
                                selectedSubject = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'Mensaje:',
                      style: TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: messageController,
                      maxLines: 6,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: theme.cardDark,
                        hintText: 'Coloque su mensaje aquí...',
                        hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: theme.border),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: theme.border),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                          borderSide: BorderSide(color: theme.orange),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(
                    'Cancelar',
                    style: TextStyle(color: theme.grey, fontWeight: FontWeight.w600),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.orange,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  onPressed: () async {
                    final msg = messageController.text.trim();
                    if (msg.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Text('Por favor, ingrese un mensaje.'),
                          backgroundColor: theme.redMid,
                        ),
                      );
                      return;
                    }

                    // Construir el correo electrónico
                    final String emailBody =
                        'Asunto de soporte: $selectedSubject\n\n'
                        'Mensaje:\n$msg\n\n'
                        '----------------------------------------\n'
                        'Información de Soporte:\n'
                        '- Nombre del usuario: $nombre\n'
                        '- Correo electrónico del usuario: $email\n'
                        '- Tipo de membresía: $membresia\n'
                        '- ID de usuario: $userId\n'
                        '----------------------------------------';

                    final Uri emailUri = Uri(
                      scheme: 'mailto',
                      path: 'info@fitnflai.com',
                      query: 'subject=${Uri.encodeComponent('soporteAPP')}&body=${Uri.encodeComponent(emailBody)}',
                    );

                    // Lanzar el cliente de correo
                    try {
                      final launched = await launchUrl(emailUri, mode: LaunchMode.externalApplication);
                      if (launched) {
                        _waitingForEmailReturn = true;
                      }
                    } catch (e) {
                      debugPrint('🚨 Error abriendo el cliente de correo: $e');
                    }

                    // Cerrar el diálogo del formulario
                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text('Enviar', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showSuccessDialog() {
    if (!mounted) return;
    final theme = context.themeColors;
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: theme.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(color: theme.border),
          ),
          title: Row(
            children: [
              Icon(Icons.check_circle_outline, color: theme.greenText, size: 24),
              const SizedBox(width: 8),
              const Text(
                'Envío exitoso',
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: const Text(
            'Nos pondremos en contacto vía correo electrónico lo más pronto posible.',
            style: TextStyle(color: Colors.white70, fontSize: 14, height: 1.4),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Entendido',
                style: TextStyle(color: theme.orange, fontWeight: FontWeight.bold),
              ),
            ),
          ],
        );
      },
    );
  }
}

// ── Contact Card ──────────────────────────────────────────────
class _ContactCard extends StatelessWidget {
  final IconData icon;
  final String title, subtitle;
  final String? badge;
  final Color badgeColor;
  final VoidCallback onTap;
  const _ContactCard({required this.icon, required this.title,
      required this.subtitle, required this.badge,
      required this.badgeColor, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return InkWell(
    onTap: onTap,
    borderRadius: BorderRadius.circular(12),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border),
      ),
      child: Row(children: [
        Container(
          width: 42, height: 42,
          decoration: BoxDecoration(
            color: theme.cardDark,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: theme.orange, size: 20),
        ),
        const SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: TextStyle(color: theme.text,
                fontSize: 14, fontWeight: FontWeight.w600)),
            Text(subtitle, style: TextStyle(
                color: theme.textMuted, fontSize: 12)),
          ],
        )),
        if (badge != null) ...[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: badgeColor.withValues(alpha: 0.4)),
            ),
            child: Text(badge!,
                style: TextStyle(color: badgeColor, fontSize: 10,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
        ],
        Icon(Icons.chevron_right, color: theme.textMuted, size: 18),
      ]),
    ),
  );
}
}

// ── FAQ Tile ─────────────────────────────────────────────────
class _FaqTile extends StatelessWidget {
  final int index;
  final String question, answer;
  final bool isOpen, isLast;
  final VoidCallback onTap;
  const _FaqTile({required this.index, required this.question,
      required this.answer, required this.isOpen,
      required this.isLast, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Column(children: [
    GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.card,
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(index == 0 ? 12 : 0),
            bottom: isLast && !isOpen ? const Radius.circular(12) : Radius.zero,
          ),
          border: Border.all(color: theme.border),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(children: [
          Expanded(
            child: Text(question,
                style: TextStyle(
                    color: isOpen ? theme.orange : theme.text,
                    fontSize: 13,
                    fontWeight: FontWeight.w600)),
          ),
          const SizedBox(width: 8),
          AnimatedRotation(
            turns: isOpen ? 0.5 : 0,
            duration: const Duration(milliseconds: 200),
            child: Icon(Icons.keyboard_arrow_down,
                color: isOpen ? theme.orange : theme.textMuted, size: 20),
          ),
        ]),
      ),
    ),
    AnimatedCrossFade(
      firstChild: const SizedBox.shrink(),
      secondChild: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: theme.cardDark,
          borderRadius: BorderRadius.vertical(
            bottom: isLast ? const Radius.circular(12) : Radius.zero),
          border: Border.all(color: theme.border),
        ),
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
        child: Text(answer,
            style: TextStyle(color: theme.textSecondary,
                fontSize: 13, height: 1.6)),
      ),
      crossFadeState: isOpen ? CrossFadeState.showSecond : CrossFadeState.showFirst,
      duration: const Duration(milliseconds: 200),
    ),
    if (!isLast)
      Divider(color: theme.border, height: 1),
  ]);
}
}

// ── Social Button ─────────────────────────────────────────────
class _SocialBtn extends StatelessWidget {
  final Widget icon;
  final String label;
  final VoidCallback onTap;
  const _SocialBtn({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return GestureDetector(
    onTap: onTap,
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 14),
      decoration: BoxDecoration(
        color: theme.card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.border),
      ),
      child: Column(children: [
        SizedBox(height: 24, child: Center(child: icon)),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(
            color: theme.textMuted, fontSize: 11, fontWeight: FontWeight.w600)),
      ]),
    ),
  );
}
}
