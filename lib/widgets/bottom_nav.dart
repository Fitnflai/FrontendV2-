import 'package:flutter/material.dart';
import '../config/app_theme_extension.dart';
import '../config/app_routes.dart';
import '../l10n/app_localizations.dart';

class AppBottomNav extends StatelessWidget {
  final int selectedIndex;

  const AppBottomNav({super.key, required this.selectedIndex});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final items = [
      _NavItem(icon: Icons.home_outlined,       label: l10n.tabHome,      route: AppRoutes.home),
      _NavItem(icon: Icons.bar_chart_outlined,  label: l10n.tabPlan,      route: AppRoutes.plan),
      _NavItem(icon: Icons.show_chart_outlined, label: l10n.tabProgress,  route: AppRoutes.progress),
      _NavItem(icon: Icons.restaurant_outlined, label: l10n.tabNutrition, route: AppRoutes.nutrition),
      _NavItem(icon: Icons.person_outline,      label: l10n.tabProfile,    route: AppRoutes.profile),
    ];
    final theme = Theme.of(context).extension<AppThemeExtension>()!;
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: theme.card,
        border: Border(top: BorderSide(color: theme.border)),
      ),
      child: Row(
        children: List.generate(items.length, (i) {
          final item     = items[i];
          final isActive = i == selectedIndex;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (!isActive) {
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    item.route,
                    (route) => false,
                  );
                }
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(item.icon,
                      color: isActive ? theme.primary : theme.grey,
                      size: 24),
                  const SizedBox(height: 2),
                  Text(item.label,
                      style: TextStyle(
                          color: isActive ? theme.primary : theme.grey,
                          fontSize: 10)),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final String label, route;
  const _NavItem({required this.icon, required this.label, required this.route});
}