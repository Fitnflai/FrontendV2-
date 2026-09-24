import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../widgets/bottom_nav.dart';

class SweatRateScreen extends StatefulWidget {
  const SweatRateScreen({super.key});

  @override
  State<SweatRateScreen> createState() => _SweatRateScreenState();
}

class _SweatRateScreenState extends State<SweatRateScreen> {
  double _weightBefore  = 87.1;
  double _weightAfter   = 86.4;
  int    _liquidMl      = 450;
  int    _durationMin   = 50;

  double get _sweatRatePerHour {
    final lostG  = (_weightBefore - _weightAfter) * 1000;
    final totalMl = lostG + _liquidMl;
    final hours  = _durationMin / 60;
    return hours > 0 ? totalMl / hours : 0;
  }

  double get _deficitMl => (_weightBefore - _weightAfter) * 1000;

  double get _lossPercent => (_deficitMl / (_weightBefore * 1000)) * 100;

  String get _statusLabel {
    if (_lossPercent < 2) return 'Bien hidratado ✓';
    if (_lossPercent < 3) return 'Deshidratación leve';
    return 'Deshidratación moderada';
  }

  Color get _statusColor {
    if (_lossPercent < 2) return AppColors.greenText;
    if (_lossPercent < 3) return Colors.amber;
    return AppColors.redText;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bg,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                child: Column(
                  children: [
                    _buildInfoBanner(),
                    const SizedBox(height: 12),
                    _buildHowToNote(),
                    const SizedBox(height: 16),
                    _buildInputCard(
                      number: 1,
                      emoji: '⚖️',
                      title: 'Peso antes de la sesión',
                      subtitle: 'Antes, después de orinar, ropa mínima',
                      displayValue: _weightBefore.toStringAsFixed(1),
                      unit: 'kg',
                      isDone: true,
                      onDecrease: () => setState(() => _weightBefore = (_weightBefore - 0.1).clamp(30, 200)),
                      onIncrease: () => setState(() => _weightBefore = (_weightBefore + 0.1).clamp(30, 200)),
                    ),
                    const SizedBox(height: 10),
                    _buildInputCard(
                      number: 2,
                      emoji: '⚖️',
                      title: 'Peso después de la sesión',
                      subtitle: 'Sin beber ni comer después',
                      displayValue: _weightAfter.toStringAsFixed(1),
                      unit: 'kg',
                      isDone: true,
                      onDecrease: () => setState(() => _weightAfter = (_weightAfter - 0.1).clamp(30, 200)),
                      onIncrease: () => setState(() => _weightAfter = (_weightAfter + 0.1).clamp(30, 200)),
                    ),
                    const SizedBox(height: 10),
                    _buildInputCard(
                      number: 3,
                      emoji: '💧',
                      title: 'Líquido bebido durante',
                      subtitle: 'Mide la botella antes y después',
                      displayValue: '$_liquidMl',
                      unit: 'ml',
                      isDone: false,
                      onDecrease: () => setState(() => _liquidMl = (_liquidMl - 50).clamp(0, 3000)),
                      onIncrease: () => setState(() => _liquidMl = (_liquidMl + 50).clamp(0, 3000)),
                    ),
                    const SizedBox(height: 10),
                    _buildInputCard(
                      number: 4,
                      emoji: '⏱️',
                      title: 'Duración de la sesión',
                      subtitle: 'Incluye calentamiento y enfriamiento',
                      displayValue: '$_durationMin',
                      unit: 'min',
                      isDone: false,
                      onDecrease: () => setState(() => _durationMin = (_durationMin - 5).clamp(10, 300)),
                      onIncrease: () => setState(() => _durationMin = (_durationMin + 5).clamp(10, 300)),
                    ),
                    const SizedBox(height: 20),
                    _buildResult(),
                    const SizedBox(height: 16),
                    _buildSaveButton(),
                    const SizedBox(height: 8),
                    Text(
                      'Repite en 2-3 sesiones similares para obtener tu promedio real.',
                      style: TextStyle(color: AppColors.grey, fontSize: 11),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(selectedIndex: 2),
    );
  }

  Widget _buildHeader(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    child: Row(children: [
      GestureDetector(
        onTap: () => Navigator.pop(context),
        child: Icon(Icons.arrow_back_ios, color: AppColors.grey, size: 20),
      ),
      const SizedBox(width: 12),
      const Text('Tasa de sudoración',
          style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _buildInfoBanner() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: Colors.blue.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: Colors.blue.withValues(alpha: 0.4)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text('Calcula tu hidratación exacta',
          style: TextStyle(color: Colors.blue, fontSize: 14, fontWeight: FontWeight.bold)),
      const SizedBox(height: 6),
      Text(
        'Con tu tasa personal de sudoración, la IA calcula exactamente cuánto debes beber en cada sesión. Protocolo del Dr. Ochoa.',
        style: TextStyle(color: AppColors.grey, fontSize: 12, height: 1.5),
      ),
    ]),
  );

  Widget _buildHowToNote() => Container(
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: AppColors.orange.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
    ),
    child: Row(children: [
      const Text('⚠️', style: TextStyle(fontSize: 14)),
      const SizedBox(width: 8),
      Expanded(child: Text(
        'Para hacerlo bien: Pésate justo antes y justo después de la sesión, con ropa mínima, después de orinar. Anota cuánto bebiste durante.',
        style: TextStyle(color: AppColors.grey, fontSize: 12, height: 1.4),
      )),
    ]),
  );

  Widget _buildInputCard({
    required int number,
    required String emoji, title, subtitle, displayValue, unit,
    required bool isDone,
    required VoidCallback onDecrease, onIncrease,
  }) => Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: isDone ? AppColors.greenText.withValues(alpha: 0.4) : AppColors.border),
    ),
    child: Row(children: [
      Container(
        width: 28, height: 28,
        decoration: BoxDecoration(
          color: isDone ? AppColors.greenBg : AppColors.border,
          shape: BoxShape.circle,
        ),
        child: Center(child: isDone
            ? Icon(Icons.check, color: AppColors.greenText, size: 14)
            : Text('$number', style: TextStyle(color: AppColors.grey, fontSize: 12, fontWeight: FontWeight.bold))),
      ),
      const SizedBox(width: 12),
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w600)),
        Text(subtitle, style: TextStyle(color: AppColors.grey, fontSize: 11)),
      ])),
      const SizedBox(width: 12),
      Row(children: [
        _StepButton(icon: Icons.remove, onTap: onDecrease),
        const SizedBox(width: 8),
        SizedBox(
          width: 58,
          child: Column(children: [
            Text(displayValue, style: const TextStyle(color: AppColors.white, fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            Text(unit, style: TextStyle(color: AppColors.grey, fontSize: 10)),
          ]),
        ),
        const SizedBox(width: 8),
        _StepButton(icon: Icons.add, onTap: onIncrease),
      ]),
    ]),
  );

  Widget _buildResult() => Container(
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(color: AppColors.orange.withValues(alpha: 0.4)),
    ),
    child: Column(children: [
      Text('TU TASA DE SUDORACIÓN',
          style: TextStyle(color: AppColors.grey, fontSize: 11, letterSpacing: 0.5)),
      const SizedBox(height: 8),
      Row(mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.baseline,
          textBaseline: TextBaseline.alphabetic, children: [
        Text(_sweatRatePerHour.toStringAsFixed(0),
            style: TextStyle(color: AppColors.orange, fontSize: 48, fontWeight: FontWeight.bold)),
        const SizedBox(width: 6),
        Text('ml/hora', style: TextStyle(color: AppColors.grey, fontSize: 16)),
      ]),
      const SizedBox(height: 6),
      Text(
        'Déficit: ${_deficitMl.toStringAsFixed(0)}ml  ·  masa perdida: ${_lossPercent.toStringAsFixed(1)}%',
        style: TextStyle(color: AppColors.grey, fontSize: 13),
      ),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: _statusColor.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(_statusLabel,
            style: TextStyle(color: _statusColor, fontSize: 13, fontWeight: FontWeight.w600)),
      ),
      const SizedBox(height: 14),
      Text(
        'A partir de ahora la IA usará esto para personalizar tu hidratación en cada sesión similar.',
        style: TextStyle(color: AppColors.grey, fontSize: 12, height: 1.5),
        textAlign: TextAlign.center,
      ),
      const SizedBox(height: 12),
      _buildProgressBar(),
    ]),
  );

  Widget _buildProgressBar() {
    final progress = (_lossPercent / 4).clamp(0.0, 1.0);
    return Column(children: [
      ClipRRect(
        borderRadius: BorderRadius.circular(4),
        child: LinearProgressIndicator(
          value: progress,
          backgroundColor: AppColors.border,
          valueColor: AlwaysStoppedAnimation<Color>(_statusColor),
          minHeight: 8,
        ),
      ),
      const SizedBox(height: 6),
      Row(children: [
        Text('0%', style: TextStyle(color: AppColors.grey, fontSize: 10)),
        const SizedBox(width: 4),
        Text('-1% Óptimo', style: TextStyle(color: AppColors.greenText, fontSize: 10)),
        const Spacer(),
        Text('-2% Leve', style: TextStyle(color: Colors.amber, fontSize: 10)),
        const Spacer(),
        Text('-3% Mod.', style: TextStyle(color: AppColors.redText, fontSize: 10)),
        const SizedBox(width: 4),
        Text('+4%', style: TextStyle(color: AppColors.grey, fontSize: 10)),
      ]),
    ]);
  }

  Widget _buildSaveButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text('Guardar · Personalizar mi hidratación',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 15)),
    ),
  );
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _StepButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) => GestureDetector(
    onTap: onTap,
    child: Container(
      width: 30, height: 30,
      decoration: BoxDecoration(color: AppColors.border, borderRadius: BorderRadius.circular(8)),
      child: Icon(icon, color: AppColors.grey, size: 16),
    ),
  );
}
