import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../config/app_routes.dart';
import '../../widgets/shared_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../main.dart';
import '../../l10n/app_localizations.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final currentLang = Localizations.localeOf(context).languageCode;

    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),

              // ── Logo ─────────────────────────────
              const FitnflaiLogo(fontSize: 48),
              const SizedBox(height: 4),
              Text(
                l10n.welcomeMarketingText,
                style: const TextStyle(color: AppColors.greyLight, fontSize: 16),
              ),

              const Spacer(flex: 2),

              // ── Título ───────────────────────────
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 200),
                child: Column(
                  key: ValueKey(currentLang),
                  children: [
                    Text(
                      l10n.welcomeTitle,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      l10n.welcomeSubtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.grey, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 28),

              // ── Selector de idioma ───────────────
              Row(children: [
                Expanded(
                  child: _LangOption(
                    flag: '🇺🇸',
                    name: 'English',
                    selected: currentLang == 'en',
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('selected_language', 'en');
                      if (!context.mounted) return;
                      FitnflaiApp.of(context)?.setLocale(const Locale('en'));
                    },
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: _LangOption(
                    flag: '🇪🇸',
                    name: 'Español',
                    selected: currentLang == 'es',
                    onTap: () async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setString('selected_language', 'es');
                      if (!context.mounted) return;
                      FitnflaiApp.of(context)?.setLocale(const Locale('es'));
                    },
                  ),
                ),
              ]),

              const Spacer(flex: 3),

              // ── Botón continuar ──────────────────
              PrimaryButton(
                labelWidget: Text(l10n.welcomeButton, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                onTap: () => Navigator.pushReplacementNamed(
                  context, AppRoutes.login,
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Language option card ─────────────────────────────────────────
class _LangOption extends StatelessWidget {
  final String flag, name;
  final bool selected;
  final VoidCallback onTap;
  const _LangOption({
    required this.flag,
    required this.name,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFF3A1F0A) : AppColors.card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: selected ? AppColors.orange : AppColors.border,
          width: selected ? 1.5 : 1,
        ),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(flag, style: const TextStyle(fontSize: 32)),
        const SizedBox(height: 8),
        Text(name,
            style: TextStyle(
              color: selected ? AppColors.orange : AppColors.greyLight,
              fontSize: 14,
              fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            )),
        const SizedBox(height: 6),
        AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 20, height: 20,
          decoration: BoxDecoration(
            color: selected ? AppColors.orange : Colors.transparent,
            shape: BoxShape.circle,
            border: Border.all(
              color: selected ? AppColors.orange : AppColors.border,
              width: 1.5,
            ),
          ),
          child: selected
              ? const Icon(Icons.check, color: Colors.white, size: 12)
              : null,
        ),
      ]),
    ),
  );
}