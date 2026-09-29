import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../config/app_theme_extension.dart';
import '../../l10n/app_localizations.dart';
import '../../widgets/shared_widgets.dart';
import '../../providers/profile_provider.dart';

class MisCitasScreen extends StatelessWidget {
  const MisCitasScreen({super.key});

  Future<void> _launch(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  String _formatFechaHora(String isoString, bool isEs) {
    try {
      // Parse ISO string handling timezone correctly:
      // - If string has 'Z' or offset (+00:00, -06:00), parse as UTC and convert to local
      // - If no timezone info, assume it's already in user's local time
      DateTime dt;
      if (isoString.endsWith('Z') || isoString.contains(RegExp(r'[+-]\d{2}:?\d{2}$'))) {
        dt = DateTime.parse(isoString).toLocal();
      } else {
        dt = DateTime.parse(isoString); // assume local
      }
      final monthsEs = [
        'ene', 'feb', 'mar', 'abr', 'may', 'jun',
        'jul', 'ago', 'sep', 'oct', 'nov', 'dic'
      ];
      final monthsEn = [
        'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
        'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
      ];
      final months = isEs ? monthsEs : monthsEn;
      final hora = dt.hour.toString().padLeft(2, '0');
      final minuto = dt.minute.toString().padLeft(2, '0');
      return '${dt.day} ${months[dt.month - 1]} ${dt.year} · $hora:$minuto';
    } catch (_) {
      return isoString;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);
    final isEs = l10n.localeName == 'es';

    return Scaffold(
      backgroundColor: theme.bg,
      appBar: FitnflaiAppBar(
        title: isEs ? 'Mis citas' : 'My Appointments',
      ),
      body: Consumer<ProfileProvider>(
        builder: (context, profile, child) {
          final List<dynamic> citas = profile.citas ?? [];

          if (citas.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '📅',
                      style: TextStyle(fontSize: 50),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      isEs ? 'No tienes citas programadas.' : 'No scheduled appointments.',
                      style: TextStyle(
                        color: theme.text,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            );
          }

          // Sort chronologically (earliest first or latest first? Let's sort closest first)
          final sortedCitas = List<dynamic>.from(citas);
          sortedCitas.sort((a, b) {
            try {
              final dtA = DateTime.parse(a['fecha_hora'] as String).toLocal();
              final dtB = DateTime.parse(b['fecha_hora'] as String).toLocal();
              return dtA.compareTo(dtB);
            } catch (_) {
              return 0;
            }
          });

          return ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            itemCount: sortedCitas.length,
            itemBuilder: (context, index) {
              final cita = sortedCitas[index] as Map<String, dynamic>;
              final especialista = cita['especialista'] as Map<String, dynamic>? ?? {};
              final nombreEspecialista = especialista['nombre_especialista'] ?? (isEs ? 'Especialista Élite' : 'Elite Specialist');
              final especialidad = especialista['especialidad'] ?? (isEs ? 'Especialista General' : 'General Specialist');
              final fotoUrl = especialista['foto_url'] as String?;
              final fechaHoraFormatted = _formatFechaHora(cita['fecha_hora'] as String, isEs);
              final estado = cita['estado']?.toString() ?? 'Pendiente';

              return Card(
                color: theme.card,
                elevation: 0,
                margin: const EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(color: theme.border),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 24,
                            backgroundColor: theme.primary.withValues(alpha: 0.2),
                            backgroundImage: fotoUrl != null && fotoUrl.isNotEmpty
                                ? NetworkImage(fotoUrl)
                                : null,
                            child: fotoUrl == null || fotoUrl.isEmpty
                                ? const Text('👩‍⚕️', style: TextStyle(fontSize: 24))
                                : null,
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  nombreEspecialista,
                                  style: TextStyle(color: theme.text, fontSize: 15, fontWeight: FontWeight.bold),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  especialidad,
                                  style: TextStyle(color: theme.textSecondary, fontSize: 13),
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: theme.orange.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: theme.orange.withValues(alpha: 0.3)),
                            ),
                            child: Text(
                              estado,
                              style: TextStyle(color: theme.orange, fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      const Divider(height: 24),
                      Row(
                        children: [
                          Icon(Icons.calendar_today_outlined, color: theme.orange, size: 14),
                          const SizedBox(width: 8),
                          Text(
                            fechaHoraFormatted,
                            style: TextStyle(color: theme.orange, fontSize: 13, fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => _launch('https://meet.google.com/abc-defg-hij'),
                              icon: const Icon(Icons.videocam_outlined, size: 16),
                              label: Text(
                                isEs ? 'Unirse a la reunión' : 'Join Meeting',
                                style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: theme.primary,
                                foregroundColor: Colors.white,
                                elevation: 0,
                                padding: const EdgeInsets.symmetric(vertical: 12),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
