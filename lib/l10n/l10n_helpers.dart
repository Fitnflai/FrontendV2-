import 'package:flutter/material.dart';
import 'app_localizations.dart';

class L10nHelpers {
  /// Localized sleep options for daily check-in
  static List<(String, String)> getSleepOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      ('😫', l10n.dailyCheckinSleepOpt1),
      ('😔', l10n.dailyCheckinSleepOpt2),
      ('😐', l10n.dailyCheckinSleepOpt3),
      ('😊', l10n.dailyCheckinSleepOpt4),
      ('😴', l10n.dailyCheckinSleepOpt5),
    ];
  }

  /// Localized energy level options for daily check-in
  static List<(String, String)> getEnergyOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      ('🪫', l10n.dailyCheckinEnergyOpt1),
      ('😩', l10n.dailyCheckinEnergyOpt2),
      ('🙂', l10n.dailyCheckinEnergyOpt3),
      ('⚡', l10n.dailyCheckinEnergyOpt4),
      ('🔥', l10n.dailyCheckinEnergyOpt5),
    ];
  }

  /// Localized available time options for daily check-in
  static List<(String, String)> getTimeOptions(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return [
      ("30'", l10n.dailyCheckinTimeOpt1),
      ("45'", l10n.dailyCheckinTimeOpt2),
      ("60'", l10n.dailyCheckinTimeOpt3),
      ("90'", l10n.dailyCheckinTimeOpt4),
      ("✓", l10n.dailyCheckinTimeOpt5),
    ];
  }

  /// Map raw body pain zone string to localized version
  static String getPainZoneLabel(BuildContext context, String zone) {
    final l10n = AppLocalizations.of(context);
    switch (zone.toLowerCase()) {
      case 'cuello':
        return l10n.painZoneCuello;
      case 'hombro':
        return l10n.painZoneHombro;
      case 'espalda alta':
        return l10n.painZoneEspaldaAlta;
      case 'lumbar':
        return l10n.painZoneLumbar;
      case 'cadera':
        return l10n.painZoneCadera;
      case 'rodilla':
        return l10n.painZoneRodilla;
      case 'tobillo':
        return l10n.painZoneTobillo;
      case 'otro':
        return l10n.painZoneOtro;
      default:
        return zone;
    }
  }

  /// Localized RPE slider labels
  static String getRpeLabel(BuildContext context, int rpe) {
    final l10n = AppLocalizations.of(context);
    switch (rpe) {
      case 1:
        return l10n.workoutFeedbackRpe1;
      case 2:
        return l10n.workoutFeedbackRpe2;
      case 3:
        return l10n.workoutFeedbackRpe3;
      case 4:
        return l10n.workoutFeedbackRpe4;
      case 5:
        return l10n.workoutFeedbackRpe5;
      default:
        return '';
    }
  }

  /// Localized feeling option labels
  static String getFeelingLabel(BuildContext context, int feeling) {
    final l10n = AppLocalizations.of(context);
    switch (feeling) {
      case 1:
        return l10n.workoutFeedbackFeeling1;
      case 2:
        return l10n.workoutFeedbackFeeling2;
      case 3:
        return l10n.workoutFeedbackFeeling3;
      case 4:
        return l10n.workoutFeedbackFeeling4;
      case 5:
        return l10n.workoutFeedbackFeeling5;
      default:
        return '';
    }
  }
}
