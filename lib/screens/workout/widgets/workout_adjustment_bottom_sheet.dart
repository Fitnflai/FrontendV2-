import 'package:flutter/material.dart';
import '../../../config/app_theme_extension.dart';
import '../../../l10n/app_localizations.dart';

/// ═══════════════════════════════════════════════════════════════
/// WORKOUT ADJUSTMENT BOTTOM SHEET
/// ═══════════════════════════════════════════════════════════════
class WorkoutAdjustmentBottomSheet extends StatefulWidget {
  const WorkoutAdjustmentBottomSheet({super.key});

  @override
  State<WorkoutAdjustmentBottomSheet> createState() =>
      _WorkoutAdjustmentBottomSheetState();
}

class _WorkoutAdjustmentBottomSheetState
    extends State<WorkoutAdjustmentBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  
  String? _selectedReason;
  String? _selectedSeverity;
  final _descriptionController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    // Simulate async API call with a 2-second delay
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isSubmitting = false;
    });

    final l10n = AppLocalizations.of(context);
    
    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.workoutAdjustmentSuccessMessage,
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );

    // Close the bottom sheet
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.themeColors;
    final l10n = AppLocalizations.of(context);

    // Common dropdown styling matching the theme
    final inputDecorationTheme = InputDecoration(
      filled: true,
      fillColor: theme.cardDark,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      hintStyle: TextStyle(color: theme.grey),
      labelStyle: TextStyle(color: theme.textSecondary, fontSize: 14),
      errorStyle: const TextStyle(color: Colors.redAccent, fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: theme.orange, width: 1.5),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.5),
      ),
    );

    return Container(
      decoration: BoxDecoration(
        color: theme.bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border(
          top: BorderSide(color: theme.border, width: 0.5),
        ),
      ),
      child: SafeArea(
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: 20 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pull bar indicator
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: theme.grey.withAlpha(76),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  
                  // Sheet Title
                  Text(
                    l10n.workoutAdjustmentTitle,
                    style: TextStyle(
                      color: theme.text,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),

                  // Reason Dropdown Label
                  Text(
                    l10n.workoutAdjustmentReasonLabel,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Reason Dropdown
                  DropdownButtonFormField<String>(
                    initialValue: _selectedReason,
                    dropdownColor: theme.cardDark,
                    style: TextStyle(color: theme.text, fontSize: 15),
                    icon: Icon(Icons.keyboard_arrow_down, color: theme.grey),
                    decoration: inputDecorationTheme.copyWith(
                      hintText: l10n.workoutAdjustmentReasonSelect,
                    ),
                    validator: (value) => value == null
                        ? l10n.workoutAdjustmentValidationRequired
                        : null,
                    onChanged: (value) {
                      setState(() {
                        _selectedReason = value;
                        // Reset severity if reason is not injury
                        if (value != 'injury') {
                          _selectedSeverity = null;
                        }
                      });
                    },
                    items: [
                      DropdownMenuItem(
                        value: 'weather',
                        child: Text(l10n.workoutAdjustmentReasonWeather),
                      ),
                      DropdownMenuItem(
                        value: 'tired',
                        child: Text(l10n.workoutAdjustmentReasonTired),
                      ),
                      DropdownMenuItem(
                        value: 'injury',
                        child: Text(l10n.workoutAdjustmentReasonInjury),
                      ),
                      DropdownMenuItem(
                        value: 'other',
                        child: Text(l10n.workoutAdjustmentReasonOther),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // Conditional Injury Severity Dropdown
                  if (_selectedReason == 'injury') ...[
                    Text(
                      l10n.workoutAdjustmentSeverityLabel,
                      style: TextStyle(
                        color: theme.textSecondary,
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<String>(
                      initialValue: _selectedSeverity,
                      dropdownColor: theme.cardDark,
                      style: TextStyle(color: theme.text, fontSize: 15),
                      icon: Icon(Icons.keyboard_arrow_down, color: theme.grey),
                      decoration: inputDecorationTheme.copyWith(
                        hintText: l10n.workoutAdjustmentSeveritySelect,
                      ),
                      validator: (value) => _selectedReason == 'injury' && value == null
                          ? l10n.workoutAdjustmentValidationRequired
                          : null,
                      onChanged: (value) {
                        setState(() {
                          _selectedSeverity = value;
                        });
                      },
                      items: [
                        DropdownMenuItem(
                          value: 'mild',
                          child: Text(l10n.workoutAdjustmentSeverityMild),
                        ),
                        DropdownMenuItem(
                          value: 'moderate',
                          child: Text(l10n.workoutAdjustmentSeverityModerate),
                        ),
                        DropdownMenuItem(
                          value: 'severe',
                          child: Text(l10n.workoutAdjustmentSeveritySevere),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                  ],

                  // Description Label
                  Text(
                    l10n.workoutAdjustmentDescLabel,
                    style: TextStyle(
                      color: theme.textSecondary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Description TextArea
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 3,
                    style: TextStyle(color: theme.text, fontSize: 15),
                    decoration: inputDecorationTheme.copyWith(
                      hintText: l10n.workoutAdjustmentDescPlaceholder,
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons (Enviar and Cancelar)
                  Row(
                    children: [
                      // Cancel Button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: OutlinedButton(
                            onPressed: _isSubmitting
                                ? null
                                : () => Navigator.of(context).pop(),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: theme.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              foregroundColor: theme.textSecondary,
                            ),
                            child: Text(
                              l10n.workoutAdjustmentBtnCancel,
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),

                      // Submit Button
                      Expanded(
                        child: SizedBox(
                          height: 48,
                          child: ElevatedButton(
                            onPressed: _isSubmitting ? null : _submit,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: theme.orange,
                              disabledBackgroundColor: theme.disabledBg,
                              foregroundColor: Colors.white,
                              disabledForegroundColor: theme.grey,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: _isSubmitting
                                ? SizedBox(
                                    width: 20,
                                    height: 20,
                                    child: CircularProgressIndicator(
                                      color: theme.bg,
                                      strokeWidth: 2,
                                    ),
                                  )
                                : Text(
                                    l10n.workoutAdjustmentBtnSubmit,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
