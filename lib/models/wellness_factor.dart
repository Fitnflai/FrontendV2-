
import 'package:flutter/material.dart';
import '../config/app_theme_extension.dart';

class WellnessFactor {
  final String id;
  final String nameEs;
  final String nameEn;
  final double weight;
  final List<double> scores;
  final List<String> labels;
  final Color Function(AppThemeExtension) colorResolver;

  const WellnessFactor({
    required this.id,
    required this.nameEs,
    required this.nameEn,
    required this.weight,
    required this.scores,
    required this.labels,
    required this.colorResolver,
  });

  String getName(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'es' ? nameEs : nameEn;

  Map<String, double> getYBounds() {
    if (scores.isEmpty) return {'minY': 0.0, 'maxY': 100.0};
    final minScore = scores.reduce((a, b) => a < b ? a : b);
    final maxScore = scores.reduce((a, b) => a > b ? a : b);

    double padding = (maxScore - minScore) * 0.15;
    if (padding < 1.0) padding = 1.0; // Flatline safety

    return {
      'minY': (minScore - padding).clamp(0.0, id == 'body_age' ? double.infinity : 100.0),
      'maxY': (maxScore + padding).clamp(0.0, id == 'body_age' ? double.infinity : 100.0),
    };
  }
}
