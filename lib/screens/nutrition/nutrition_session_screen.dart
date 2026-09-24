import 'package:flutter/material.dart';
import '../../config/app_colors.dart';
import '../../widgets/bottom_nav.dart';

class NutritionSessionScreen extends StatelessWidget {
  const NutritionSessionScreen({super.key});

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildAIBadge(),
                    const SizedBox(height: 16),
                    _buildSection(
                      phase: '30-60 min ANTES',
                      phaseNote: 'Ahora · antes de salir',
                      icon: Icons.access_time,
                      color: AppColors.orange,
                      items: const [
                        _TipItem(emoji: '🍌', name: '1 plátano maduro',
                            detail: 'Carbohidrato de rápida absorción. Tu combustible para los primeros 30 min.',
                            tag: ('IG alto', AppColors.orange)),
                        _TipItem(emoji: '💧', name: '500 ml de agua',
                            detail: 'Siempre bebes 20% menos agua de lo que piensas. Bebe más de lo que creas.'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      phase: 'DURANTE · si superas 60 min',
                      phaseNote: '60+ min de sesión',
                      icon: Icons.directions_run,
                      color: AppColors.greenText,
                      items: const [
                        _TipItem(emoji: '🌀', name: '200-300 ml cada 20 min',
                            detail: 'En sesiones de Zona 2 — no necesitas carbohidratos durante.'),
                        _TipItem(emoji: '🍌', name: 'Solo si superas 90 min',
                            detail: 'Sesión corta — no necesitas carbohidratos durante.',
                            tag: ('opcional', AppColors.orange)),
                        _TipItem(emoji: '💧', name: '500 ml agua o bebida isotónica',
                            detail: 'Si pierdes más de 1 kg durante la sesión, añade electrolitos.'),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildSection(
                      phase: 'DESPUÉS · -30 min post-sesión',
                      phaseNote: 'Ventana de recuperación',
                      icon: Icons.restaurant,
                      color: AppColors.orange,
                      items: const [
                        _TipItem(emoji: '🍚', name: 'Arroz + pollo + plátano',
                            detail: '1 taza arroz · 150g pollo · 1 plátano. IG alto para reponer glucógeno + proteína para recuperar músculo.',
                            tag: ('IG alto · recuperación', AppColors.greenText)),
                        _TipItem(emoji: '💧', name: '500 ml agua o bebida isotónica',
                            detail: 'Repón lo que sudaste. Si perdiste más de 1 kg añade electrolitos.'),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildAltitudeNote(),
                    const SizedBox(height: 16),
                    _buildStartButton(),
                    const SizedBox(height: 8),
                    Center(
                      child: Text(
                        'Nutrición basada en el protocolo del Dr. Ochoa · Plan Pro activo',
                        style: TextStyle(color: AppColors.grey, fontSize: 11),
                        textAlign: TextAlign.center,
                      ),
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
      const Text('Carrera base · Zona 2',
          style: TextStyle(color: AppColors.white, fontSize: 18, fontWeight: FontWeight.bold)),
    ]),
  );

  Widget _buildAIBadge() => Container(
    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(children: [
      const Text('🧠', style: TextStyle(fontSize: 14)),
      const SizedBox(width: 6),
      Text('Nutrición para esta sesión', style: TextStyle(color: AppColors.grey, fontSize: 12)),
      const Spacer(),
      Text('Generado por IA · Plan Pro',
          style: TextStyle(color: AppColors.orange, fontSize: 11, fontWeight: FontWeight.w500)),
    ]),
  );

  Widget _buildSection({
    required String phase,
    required String phaseNote,
    required IconData icon,
    required Color color,
    required List<_TipItem> items,
  }) => Container(
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Row(children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(8)),
              child: Icon(icon, color: color, size: 16),
            ),
            const SizedBox(width: 10),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(phase, style: TextStyle(color: color, fontSize: 13, fontWeight: FontWeight.bold)),
              Text(phaseNote, style: TextStyle(color: AppColors.grey, fontSize: 11)),
            ]),
          ]),
        ),
        Divider(color: AppColors.border, height: 1),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: items.asMap().entries.map((e) => Padding(
              padding: EdgeInsets.only(top: e.key > 0 ? 12 : 0),
              child: _buildTipItem(e.value),
            )).toList(),
          ),
        ),
      ],
    ),
  );

  Widget _buildTipItem(_TipItem item) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(item.emoji, style: const TextStyle(fontSize: 20)),
      const SizedBox(width: 10),
      Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(item.name,
              style: const TextStyle(color: AppColors.white, fontSize: 13, fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(item.detail, style: TextStyle(color: AppColors.grey, fontSize: 12, height: 1.4)),
          if (item.tag != null) ...[
            const SizedBox(height: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: item.tag!.$2.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: item.tag!.$2.withValues(alpha: 0.35)),
              ),
              child: Text(item.tag!.$1,
                  style: TextStyle(color: item.tag!.$2, fontSize: 11, fontWeight: FontWeight.w500)),
            ),
          ],
        ],
      )),
    ],
  );

  Widget _buildAltitudeNote() => Container(
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: AppColors.orange.withValues(alpha: 0.08),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.orange.withValues(alpha: 0.3)),
    ),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('⚠️', style: TextStyle(fontSize: 15)),
      const SizedBox(width: 10),
      Expanded(child: Text(
        'Quito 2.850m · Tu metabolismo basal es un 12% mayor en altitud. Come un poco más en días de carga alta. Tu cuerpo trabaja más incluso en reposo.',
        style: TextStyle(color: AppColors.grey, fontSize: 12, height: 1.5),
      )),
    ]),
  );

  Widget _buildStartButton() => SizedBox(
    width: double.infinity,
    child: ElevatedButton(
      onPressed: () {},
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.orange,
        padding: const EdgeInsets.symmetric(vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
      child: const Text('¡Vamos! Iniciar sesión →',
          style: TextStyle(color: AppColors.white, fontWeight: FontWeight.bold, fontSize: 16)),
    ),
  );
}

class _TipItem {
  final String emoji, name, detail;
  final (String, Color)? tag;
  const _TipItem({required this.emoji, required this.name, required this.detail, this.tag});
}
