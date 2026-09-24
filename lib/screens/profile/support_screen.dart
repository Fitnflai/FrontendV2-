import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme_extension.dart';
import '../../widgets/shared_widgets.dart';

class SupportScreen extends StatefulWidget {
  const SupportScreen({super.key});
  @override
  State<SupportScreen> createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> {
  int? _openFaq;

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
            icon: Icons.chat_bubble_outline,
            title: l10n.supportLiveChat,
            subtitle: l10n.supportLiveChatSub,
            badge: l10n.supportAvailable,
            badgeColor: theme.greenText,
            onTap: () => _launch('https://wa.me/573001234567'),
          ),
          const SizedBox(height: 8),
          _ContactCard(
            icon: Icons.email_outlined,
            title: l10n.supportEmail,
            subtitle: 'soporte@fitnflai.com',
            badge: '24–48h',
            badgeColor: theme.orange,
            onTap: () => _launch('mailto:soporte@fitnflai.com'),
          ),
          const SizedBox(height: 8),
          _ContactCard(
            icon: Icons.article_outlined,
            title: l10n.supportHelpCenter,
            subtitle: l10n.supportHelpCenterSub,
            badge: null,
            badgeColor: theme.textMuted,
            onTap: () => _launch('https://help.fitnflai.com'),
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
              onTap: () => _launch('https://facebook.com/fitnflai'),
            )),
            const SizedBox(width: 10),
            Expanded(child: _SocialBtn(
              icon: const SocialSvgIcon(svgData: SocialSvgIcons.instagram, size: 22), label: 'Instagram',
              onTap: () => _launch('https://instagram.com/fitnflai'),
            )),
            const SizedBox(width: 10),
            Expanded(child: _SocialBtn(
              icon: const SocialSvgIcon(svgData: SocialSvgIcons.x, size: 20), label: 'X',
              onTap: () => _launch('https://x.com/fitnflai'),
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
