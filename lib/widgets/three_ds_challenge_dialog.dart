import 'dart:async';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fitnflaifrontendv2/config/app_colors.dart';
import 'package:fitnflaifrontendv2/config/app_constants.dart';
import 'package:fitnflaifrontendv2/services/payments_service.dart';

class ThreeDsChallengeDialog extends StatefulWidget {
  final String challengeHtml;
  final String? transactionId;
  final String? token;
  final PaymentsService? paymentsService;

  const ThreeDsChallengeDialog({
    super.key,
    required this.challengeHtml,
    this.transactionId,
    this.token,
    this.paymentsService,
  });

  /// Displays the dialog and returns `true` if the transaction completed/redirected.
  static Future<bool?> show(
    BuildContext context,
    String challengeHtml, {
    String? transactionId,
    String? token,
    PaymentsService? paymentsService,
  }) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Force them to complete or manually cancel via the 'X'
      builder: (context) => ThreeDsChallengeDialog(
        challengeHtml: challengeHtml,
        transactionId: transactionId,
        token: token,
        paymentsService: paymentsService,
      ),
    );
  }

  @override
  State<ThreeDsChallengeDialog> createState() => _ThreeDsChallengeDialogState();
}

class _ThreeDsChallengeDialogState extends State<ThreeDsChallengeDialog> {
  late final WebViewController _controller;
  late final PaymentsService _paymentsService;
  Timer? _pollTimer;
  bool _isPolling = false;
  int _pollAttempts = 0;
  static const int _maxPollAttempts = 20; // 20 attempts * 2s = 40s
  bool _isLoading = true;
  bool _hasNavigatedToExternalUrl = false;

  bool get _isSilentFingerprint {
    final html = widget.challengeHtml.toLowerCase();
    return html.contains('tdsmmethodform') ||
           html.contains('rendermethodurl') ||
           html.contains('visibility: hidden') ||
           html.contains('visibility:hidden');
  }

  String _getPaymentezBaseUrl() {
    const baseUrl = AppConstants.baseUrl;
    if (baseUrl.contains('staging') || baseUrl.contains('dev') || baseUrl.contains('localhost')) {
      return 'https://ccapi-stg.paymentez.com';
    }
    return 'https://ccapi.paymentez.com';
  }

  @override
  void dispose() {
    _pollTimer?.cancel();
    super.dispose();
  }

  void _startStatusPolling() {
    final txId = widget.transactionId;
    final token = widget.token;
    if (txId == null || token == null || txId.isEmpty || token.isEmpty) return;

    debugPrint('3DS: Starting status polling for gateway_payment_id: $txId');
    // Give the iframe 2 seconds to auto-submit the fingerprint form to CardinalCommerce
    Future.delayed(const Duration(seconds: 2), () {
      if (!mounted) return;
      _pollTimer = Timer.periodic(const Duration(seconds: 2), (timer) async {
        if (!mounted) {
          timer.cancel();
          return;
        }
        if (_isPolling) return;

        _pollAttempts++;
        if (_pollAttempts > _maxPollAttempts) {
          debugPrint('3DS: Polling max attempts reached ($_maxPollAttempts). Stopping poll.');
          timer.cancel();
          if (mounted) {
            Navigator.pop(context, false);
          }
          return;
        }

        _isPolling = true;
        try {
          final res = await _paymentsService.getEstadoTransaccion(token, txId);
          debugPrint('3DS: Polling attempt $_pollAttempts response: $res');
          if (res is Map<String, dynamic>) {
            final estado = ((res['estado'] ?? res['status'] ?? res['state']) as String?)?.toLowerCase().trim() ?? '';
            if (estado == 'aprobada' ||
                estado == 'exitosa' ||
                estado == 'success' ||
                estado == 'completed' ||
                estado == 'pagada' ||
                estado == 'approved') {
              timer.cancel();
              debugPrint('3DS: Transaction approved ($estado)! Closing dialog with success.');
              if (mounted) {
                Navigator.pop(context, true);
              }
              return;
            } else if (estado == 'rechazada' ||
                       estado == 'fallida' ||
                       estado == 'failed' ||
                       estado == 'denied' ||
                       estado == 'cancelada' ||
                       estado == 'rejected') {
              timer.cancel();
              debugPrint('3DS: Transaction failed/rejected ($estado). Closing dialog with failure.');
              if (mounted) {
                Navigator.pop(context, false);
              }
              return;
            }
            // If 'pendiente' or 'en_proceso', continue polling
          }
        } catch (e) {
          debugPrint('3DS: Polling error on attempt $_pollAttempts: $e (treating as pending)');
        } finally {
          _isPolling = false;
        }
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _paymentsService = widget.paymentsService ?? PaymentsService();
    _startStatusPolling();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
            final lower = url.toLowerCase();
            if ((lower.startsWith('http://') || lower.startsWith('https://')) &&
                !lower.startsWith(_getPaymentezBaseUrl().toLowerCase())) {
              _hasNavigatedToExternalUrl = true;
            }
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });

            // Check if this is a transaction status page by URL
            final lowerUrl = url.toLowerCase();
            if (lowerUrl.contains('challenges/status') ||
                lowerUrl.contains('challenges/result') ||
                lowerUrl.contains('payments/status') ||
                lowerUrl.contains('success.html') ||
                lowerUrl.contains('failure.html') ||
                lowerUrl.contains('complete') ||
                lowerUrl.contains('success') ||
                lowerUrl.contains('failure')) {
              debugPrint('3DS: Status page finished loading ($url). Waiting 3 seconds for the user to read it, then auto-closing...');
              await Future.delayed(const Duration(seconds: 3));
              if (mounted) {
                Navigator.pop(context, true);
              }
              return;
            }

            // Fallback: Check if this is a transaction status page by content text
            try {
              final Object resultObj = await _controller.runJavaScriptReturningResult("document.body.innerText");
              final String pageText = resultObj.toString().toLowerCase();
              if (pageText.contains('autenticación completada') || 
                  pageText.contains('regresar a la aplicación') || 
                  pageText.contains('completada con éxito') ||
                  pageText.contains('pago exitoso')) {
                debugPrint('3DS: Success text detected in page content! Waiting 3 seconds, then closing...');
                await Future.delayed(const Duration(seconds: 3));
                if (mounted) {
                  Navigator.pop(context, true);
                }
                return;
              }
            } catch (e) {
              debugPrint('Error evaluating page text in 3DS: $e');
            }

            // Heuristic fallback for silent fingerprinting only if polling is not configured
            if (widget.transactionId == null || widget.token == null) {
              try {
                final currentUrl = await _controller.currentUrl();
                debugPrint('3DS WebView current URL: $currentUrl');
                if (!_hasNavigatedToExternalUrl && (currentUrl == null || 
                    currentUrl == 'about:blank' || 
                    currentUrl.startsWith('data:'))) {
                  debugPrint('3DS: Posible flujo silencioso detectado. Esperando 10 segundos...');
                  await Future.delayed(const Duration(seconds: 10));
                  if (mounted) {
                    final finalUrl = await _controller.currentUrl();
                    debugPrint('3DS Timer finalizado. URL final en el WebView: $finalUrl');
                    if (!_hasNavigatedToExternalUrl && (finalUrl == null || 
                        finalUrl == 'about:blank' || 
                        finalUrl.startsWith('data:'))) {
                      debugPrint('3DS: Confirmado flujo silencioso sin navegación externa. Auto-cerrando...');
                      if (mounted) {
                        Navigator.pop(context, true); // Auto-close with success to trigger profile reload!
                      }
                    } else {
                      debugPrint('3DS: Se detectó redirección externa activa ($finalUrl). Cancelando auto-cierre.');
                    }
                  }
                }
              } catch (e) {
                debugPrint('Error checking current URL in 3DS: $e');
              }
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('3DS WebView resource error: ${error.description} (code: ${error.errorCode})');
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            debugPrint('3DS WebView navigating to: $url');
            if (url.startsWith('http://') || url.startsWith('https://')) {
              _hasNavigatedToExternalUrl = true;
            }
            
            // If the redirect URL contains our app scheme or standard return URLs, close webview
            if (url.startsWith('fitnflai://') || 
                url.contains('nuvei_redirect') || 
                url.contains('payment-methods/membership')) {
              Navigator.pop(context, true); // Pop with success indicator
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    debugPrint('3DS Challenge HTML Content: ${widget.challengeHtml}');
    final trimmedChallenge = widget.challengeHtml.trim();
    if (trimmedChallenge.startsWith('http://') || trimmedChallenge.startsWith('https://')) {
      debugPrint('3DS: challenge is a URL. Loading via loadRequest.');
      _controller.loadRequest(Uri.parse(trimmedChallenge));
    } else {
      debugPrint('3DS: challenge is raw HTML. Loading via loadHtmlString with same-origin baseUrl.');
      _controller.loadHtmlString(trimmedChallenge, baseUrl: _getPaymentezBaseUrl());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      backgroundColor: const Color(0xFF1E1E1E), // Match app's dark background
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.8,
          child: Column(
            children: [
              // Header bar
              Container(
                color: const Color(0xFF2A2A2A),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Validación 3D Secure',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () => Navigator.pop(context, false), // User cancelled
                      constraints: const BoxConstraints(),
                      padding: EdgeInsets.zero,
                    ),
                  ],
                ),
              ),
              
              // Progress bar
              if (_isLoading || (_isSilentFingerprint && !_hasNavigatedToExternalUrl))
                const LinearProgressIndicator(
                  color: AppColors.orange,
                  backgroundColor: Color(0xFF2A2A2A),
                ),
                
              // WebView and Status Layer
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      // Loader & helper messages
                      if (_isLoading || (_isSilentFingerprint && !_hasNavigatedToExternalUrl))
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 24),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const CircularProgressIndicator(color: AppColors.orange),
                                const SizedBox(height: 24),
                                const Text(
                                  'Verificando pago seguro...',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Procesando validación 3D Secure con tu banco. Por favor, no cierres esta pantalla.',
                                  style: TextStyle(
                                    color: Colors.white.withValues(alpha: 0.7),
                                    fontSize: 13,
                                    height: 1.4,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ),
                      // WebView: rendered with 0.01 opacity if silent fingerprint without external navigation
                      // so it can execute background form POST/iframe without hiding the loader with a blank rectangle!
                      Opacity(
                        opacity: (_isSilentFingerprint && !_hasNavigatedToExternalUrl) ? 0.01 : 1.0,
                        child: WebViewWidget(controller: _controller),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
