import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/cached_http.dart';
import '../../config/app_theme_extension.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/shared_widgets.dart';
import '../../l10n/app_localizations.dart';
import 'profile_test_instruction_screen.dart';

class MyTestsScreen extends StatefulWidget {
  const MyTestsScreen({super.key});
  @override
  State<MyTestsScreen> createState() => _MyTestsScreenState();
}

class _MyTestsScreenState extends State<MyTestsScreen> {
  bool _loading = true;
  List<Map<String, dynamic>> _resultados = [];

  static const _testDefs = [
    _TestDef(0, 'sentadillas', '🦵', 'Sentadillas 1 min',       'Fuerza tren inferior',       Icons.accessibility_new_outlined),
    _TestDef(1, 'cooper',      '🏃', 'Test de Cooper',           'Resistencia cardiovascular', Icons.directions_run_outlined),
    _TestDef(2, 'flexiones',   '💪', 'Flexiones 1 min',          'Fuerza tren superior',       Icons.fitness_center_outlined),
    _TestDef(3, 'plancha',     '🧱', 'Plancha abdominal',        'Core / Estabilidad',         Icons.self_improvement_outlined),
    _TestDef(4, 'inclinacion', '🤸', 'Inclinación hacia adelante','Flexibilidad',              Icons.accessibility_outlined),
  ];

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final token = context.read<AuthProvider>().token ?? '';
      final res = await CachedHttp.get(
        Uri.parse('https://apifitnflai.com/evaluacion/listar-resultados-tests'),
        headers: {'Authorization': 'Bearer $token'},
      );
      if (res.statusCode == 200 && mounted) {
        final raw = jsonDecode(res.body);
        if (raw is List) {
          setState(() => _resultados = raw.cast<Map<String, dynamic>>());
        }
      }
    } catch (e) {
      debugPrint('MY_TESTS ERROR: $e');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Map<String, dynamic>? _resultadoPara(String key) {
    try {
      // Más reciente primero
      final matches = _resultados
          .where((r) => (r['nombre_test'] as String?)?.toLowerCase() == key)
          .toList();
      if (matches.isEmpty) return null;
      matches.sort((a, b) {
        final fa = DateTime.tryParse(a['fecha_realizacion'] as String? ?? '') ?? DateTime(2000);
        final fb = DateTime.tryParse(b['fecha_realizacion'] as String? ?? '') ?? DateTime(2000);
        return fb.compareTo(fa);
      });
      return matches.first;
    } catch (_) {
      return null;
    }
  }

  int _diasRestantes(Map<String, dynamic> resultado) {
    final fecha = DateTime.tryParse(resultado['fecha_realizacion'] as String? ?? '');
    if (fecha == null) return 0;
    final proxima = fecha.add(const Duration(days: 30));
    return proxima.difference(DateTime.now()).inDays.clamp(0, 30);
  }

  void _irATest(int idx, String? idResultado) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ProfileTestInstructionScreen(
          testIndex:            idx,
          idResultadoExistente: idResultado,
        ),
      ),
    ).then((_) => _load());
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(title: l10n.myTestsTitle),
      body: _loading
          ? Center(child: CircularProgressIndicator(color: theme.primary))
          : RefreshIndicator(
              onRefresh: _load,
              color: theme.primary,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: theme.greenBg,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: theme.successBorder),
                    ),
                    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                      Row(children: [
                        Icon(Icons.sync, color: theme.successText, size: 18),
                        const SizedBox(width: 8),
                        Flexible(child: Text(l10n.myTestsBannerTitle,
                            style: TextStyle(color: theme.successText,
                                fontSize: 14, fontWeight: FontWeight.w700))),
                      ]),
                      const SizedBox(height: 8),
                      Text(
                        l10n.myTestsBannerDesc,
                        style: TextStyle(color: theme.greenText.withValues(alpha: 0.8), fontSize: 13, height: 1.5),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 24),
                  _SectionLabel(l10n.myTestsSection),
                  const SizedBox(height: 8),
                  ..._testDefs.map((def) {
                    final resultado = _resultadoPara(def.key);
                    final hecho     = resultado != null;
                    final diasLeft  = hecho ? _diasRestantes(resultado) : 0;
                    final listo     = !hecho || diasLeft == 0;

                    return Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _TestCard(
                        def:       def,
                        resultado: resultado,
                        diasLeft:  diasLeft,
                        listo:     listo,
                        onTap: () => _irATest(def.index, resultado?['id_resultado'] as String?),
                      ),
                    );
                  }),
                  const SizedBox(height: 8),
                ]),
              ),
            ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// TEST CARD
// ═══════════════════════════════════════════════════════════════
class _TestCard extends StatelessWidget {
  final _TestDef def;
  final Map<String, dynamic>? resultado;
  final int diasLeft;
  final bool listo;
  final VoidCallback onTap;
  const _TestCard({
    required this.def,
    required this.resultado,
    required this.diasLeft,
    required this.listo,
    required this.onTap,
  });

  String _formatFecha(String? iso) {
    if (iso == null) return '';
    try {
      final dt = DateTime.parse(iso).toLocal();
      return '${dt.day}/${dt.month}/${dt.year}';
    } catch (_) { return ''; }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final hecho = resultado != null;
    final Color borderColor = !hecho
        ? theme.border
        : listo
            ? theme.primary
            : theme.successBorder;
    final Color bgColor = !hecho
        ? theme.card
        : listo
            ? theme.primary.withValues(alpha: 0.1)
            : theme.successBg;

    return Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: borderColor),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 10),
          child: Row(children: [
            Container(
              width: 44, height: 44,
              decoration: BoxDecoration(
                color: !hecho
                    ? theme.cardDark
                    : listo
                        ? theme.primary.withValues(alpha: 0.15)
                        : theme.successBorder.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Center(child: Text(def.emoji,
                  style: const TextStyle(fontSize: 22))),
            ),
            const SizedBox(width: 12),
            Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(def.getName(context), style: TextStyle(
                  color: theme.text, fontSize: 14,
                  fontWeight: FontWeight.w700)),
              Text(def.getCategory(context), style: TextStyle(
                  color: theme.textMuted, fontSize: 12)),
            ])),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: !hecho
                    ? theme.cardDark
                    : listo
                        ? theme.primary.withValues(alpha: 0.15)
                        : theme.successBorder.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: !hecho
                      ? theme.border
                      : listo
                          ? theme.primary
                          : theme.successBorder,
                ),
              ),
              child: Text(
                !hecho
                    ? AppLocalizations.of(context).myTestsStatusPending
                    : listo
                        ? AppLocalizations.of(context).myTestsStatusRepeat
                        : AppLocalizations.of(context).myTestsStatusDays(diasLeft),
                style: TextStyle(
                    color: !hecho
                        ? theme.textSecondary
                        : listo
                            ? theme.primary
                            : theme.successText,
                    fontSize: 11,
                    fontWeight: FontWeight.w600),
              ),
            ),
          ]),
        ),

        if (hecho) ...[
          Divider(color: theme.border, height: 1, indent: 16, endIndent: 16),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
            child: Row(children: [
              Icon(Icons.check_circle, color: theme.successText, size: 14),
              const SizedBox(width: 6),
              Text(AppLocalizations.of(context).myTestsLastTime(_formatFecha(resultado!['fecha_realizacion'] as String?)),
                  style: TextStyle(color: theme.textMuted, fontSize: 12)),
              const Spacer(),
              if ((resultado!['resultado_valor'] as num?) != null)
                Text('${resultado!['resultado_valor']} ${resultado!['unidad'] ?? ''}',
                    style: TextStyle(
                        color: theme.textSecondary, fontSize: 12,
                        fontWeight: FontWeight.w600)),
            ]),
          ),
        ],

        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
          child: SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: onTap,
              icon: Icon(
                hecho ? Icons.refresh : Icons.play_arrow_rounded,
                size: 18,
              ),
              label: Text(
                hecho ? AppLocalizations.of(context).myTestsBtnRetake : AppLocalizations.of(context).myTestsBtnStart,
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: listo || !hecho ? theme.primary : theme.successBg,
                foregroundColor: listo || !hecho ? Colors.white : theme.successText,
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ),
        ),
      ]),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════════════════════════
class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);
  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    return Padding(
      padding: const EdgeInsets.only(left: 2, bottom: 4),
      child: Text(text, style: TextStyle(
          color: theme.textMuted, fontSize: 11,
          fontWeight: FontWeight.w700, letterSpacing: 0.8)),
    );
  }
}

class _TestDef {
  final int index;
  final String key, emoji, name, category;
  final IconData icon;
  const _TestDef(this.index, this.key, this.emoji, this.name, this.category, this.icon);

  String getName(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'sentadillas': return l10n.myTestsSquatsName;
      case 'cooper': return l10n.myTestsCooperName;
      case 'flexiones': return l10n.myTestsPushupsName;
      case 'plancha': return l10n.myTestsPlankName;
      case 'inclinacion': return l10n.myTestsFlexName;
      default: return name;
    }
  }

  String getCategory(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    switch (key) {
      case 'sentadillas': return l10n.myTestsSquatsCategory;
      case 'cooper': return l10n.myTestsCooperCategory;
      case 'flexiones': return l10n.myTestsPushupsCategory;
      case 'plancha': return l10n.myTestsPlankCategory;
      case 'inclinacion': return l10n.myTestsFlexCategory;
      default: return category;
    }
  }
}