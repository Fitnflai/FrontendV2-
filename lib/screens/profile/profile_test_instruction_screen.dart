import 'package:flutter/material.dart';
import '../../config/app_theme_extension.dart';
import '../onboarding/step5_test_instruction_screen.dart';
import 'profile_test_timer_screen.dart';

// Reutiliza los datos y widgets del onboarding (allTests, TestData, etc.)
// Solo cambia la navegación: back → pop, sin paso X de Y

class ProfileTestInstructionScreen extends StatelessWidget {
  final int testIndex;
  final String? idResultadoExistente;

  const ProfileTestInstructionScreen({
    super.key,
    required this.testIndex,
    this.idResultadoExistente,
  });

  @override
  Widget build(BuildContext context) {
    final test = getTests(context)[testIndex];
    final theme = context.themeColors;
    return Scaffold(
      backgroundColor: theme.bg,
      body: SafeArea(
        child: Column(children: [
          // ── Top bar ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: theme.card,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: theme.border),
                  ),
                  child: Icon(Icons.arrow_back_ios_new,
                      color: theme.primary, size: 16),
                ),
              ),
              const Spacer(),
              Text(idResultadoExistente != null
                      ? 'Repetir test'
                      : 'Nuevo test',
                  style: TextStyle(
                      color: theme.textMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w500)),
            ]),
          ),

          // ── Contenido del test (reutiliza widgets del onboarding) ──
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                // Icon + tag
                Row(children: [
                  Text(test.icon, style: const TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Expanded(child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(test.tag.toUpperCase(),
                        style: TextStyle(
                            color: theme.primary, fontSize: 11,
                            fontWeight: FontWeight.w700, letterSpacing: 0.8)),
                    Text(test.title,
                        style: TextStyle(
                            color: theme.text, fontSize: 20,
                            fontWeight: FontWeight.w800)),
                  ])),
                ]),
                const SizedBox(height: 16),

                // Descripción
                Text(test.description,
                    style: TextStyle(
                        color: theme.textSecondary, fontSize: 13,
                        height: 1.6)),
                const SizedBox(height: 24),

                // Pasos
                Text(test.measuresTitle,
                    style: TextStyle(
                        color: theme.text, fontSize: 15,
                        fontWeight: FontWeight.w700)),
                const SizedBox(height: 4),
                Text(test.measuresDesc,
                    style: TextStyle(
                        color: theme.textMuted, fontSize: 12, height: 1.5)),
                const SizedBox(height: 16),

                ...test.steps.asMap().entries.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: Row(crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Container(
                      width: 24, height: 24,
                      decoration: BoxDecoration(
                          color: theme.primary, shape: BoxShape.circle),
                      child: Center(child: Text('${e.key + 1}',
                          style: const TextStyle(color: Colors.white,
                              fontSize: 12, fontWeight: FontWeight.w700))),
                    ),
                    const SizedBox(width: 12),
                    Expanded(child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text(e.value.main,
                          style: TextStyle(
                              color: theme.text, fontSize: 13,
                              height: 1.4)),
                      if (e.value.tip != null) ...[
                        const SizedBox(height: 4),
                        Text('💡 ${e.value.tip}',
                            style: TextStyle(
                                color: theme.textMuted, fontSize: 11,
                                height: 1.4)),
                      ],
                    ])),
                  ]),
                )),

                // Errores comunes
                if (test.errors.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: theme.errorText.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: theme.errorText),
                    ),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('⚠️ Evita estos errores',
                          style: TextStyle(
                              color: theme.errorText, fontSize: 12,
                              fontWeight: FontWeight.w700)),
                      const SizedBox(height: 8),
                      ...test.errors.map((e) => Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                          Text('• ',
                              style: TextStyle(
                                  color: theme.errorText, fontSize: 13)),
                          Expanded(child: Text(e,
                              style: TextStyle(
                                  color: theme.errorText.withValues(alpha: 0.8),
                                  fontSize: 12, height: 1.4))),
                        ]),
                      )),
                    ]),
                  ),
                ],
                const SizedBox(height: 24),
              ]),
            ),
          ),

          // ── Botón ────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: SizedBox(
              width: double.infinity, height: 52,
              child: ElevatedButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ProfileTestTimerScreen(
                      testIndex:            testIndex,
                      idResultadoExistente: idResultadoExistente,
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  elevation: 0,
                ),
                child: Text(test.startLabel,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w700)),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}