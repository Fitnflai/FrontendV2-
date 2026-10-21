import 'package:flutter/material.dart';
import 'package:fitnflaifrontendv2/config/app_colors.dart';

class OtpVerificationDialog extends StatefulWidget {
  final String transactionId;
  final Future<dynamic> Function(String otpCode) onVerify;

  const OtpVerificationDialog({
    super.key,
    required this.transactionId,
    required this.onVerify,
  });

  /// Displays the OTP verification dialog and returns the result of the onVerify callback, or null if cancelled.
  static Future<dynamic> show(
    BuildContext context, {
    required String transactionId,
    required Future<dynamic> Function(String otpCode) onVerify,
  }) {
    return showDialog<dynamic>(
      context: context,
      barrierDismissible: false, // Force them to complete or cancel via buttons
      builder: (context) => OtpVerificationDialog(
        transactionId: transactionId,
        onVerify: onVerify,
      ),
    );
  }

  @override
  State<OtpVerificationDialog> createState() => _OtpVerificationDialogState();
}

class _OtpVerificationDialogState extends State<OtpVerificationDialog> {
  final TextEditingController _otpController = TextEditingController();
  bool _isVerifying = false;
  String? _errorMessage;

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _handleVerification() async {
    final otp = _otpController.text.trim();
    if (otp.isEmpty) {
      setState(() {
        _errorMessage = 'Por favor, ingresá el código OTP';
      });
      return;
    }

    setState(() {
      _isVerifying = true;
      _errorMessage = null;
    });

    try {
      final result = await widget.onVerify(otp);
      if (mounted) {
        Navigator.pop(context, result);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          // Extract user-friendly error if possible
          _errorMessage = e.toString().replaceAll('Exception:', '').trim();
          _isVerifying = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF1E1E1E), // Matches membership's dialog color
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.security,
              color: AppColors.orange,
              size: 48,
            ),
            const SizedBox(height: 16),
            const Text(
              'Verificación OTP',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              'Ingresá el código de verificación OTP que fue enviado para validar tu transacción segura.',
              style: TextStyle(
                color: AppColors.greyLight,
                fontSize: 13,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            TextField(
              controller: _otpController,
              keyboardType: TextInputType.number,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                letterSpacing: 4,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                hintText: 'CÓDIGO OTP',
                hintStyle: const TextStyle(
                  color: AppColors.grey,
                  fontSize: 13,
                  letterSpacing: 1,
                  fontWeight: FontWeight.normal,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 14),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.orange, width: 2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
              ),
              enabled: !_isVerifying,
            ),
            if (_errorMessage != null) ...[
              const SizedBox(height: 12),
              Text(
                _errorMessage!,
                style: const TextStyle(
                  color: Colors.red,
                  fontSize: 13,
                ),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: TextButton(
                    onPressed: _isVerifying ? null : () => Navigator.pop(context, null),
                    child: const Text(
                      'Cancelar',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _isVerifying ? null : _handleVerification,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.orange,
                      disabledBackgroundColor: AppColors.orange.withValues(alpha: 0.5),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: _isVerifying
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.white,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            'Validar',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
