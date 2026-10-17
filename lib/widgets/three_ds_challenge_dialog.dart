import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:fitnflaifrontendv2/config/app_colors.dart';

class ThreeDsChallengeDialog extends StatefulWidget {
  final String challengeHtml;

  const ThreeDsChallengeDialog({
    super.key,
    required this.challengeHtml,
  });

  /// Displays the dialog and returns `true` if the transaction completed/redirected.
  static Future<bool?> show(BuildContext context, String challengeHtml) {
    return showDialog<bool>(
      context: context,
      barrierDismissible: false, // Force them to complete or manually cancel via the 'X'
      builder: (context) => ThreeDsChallengeDialog(challengeHtml: challengeHtml),
    );
  }

  @override
  State<ThreeDsChallengeDialog> createState() => _ThreeDsChallengeDialogState();
}

class _ThreeDsChallengeDialogState extends State<ThreeDsChallengeDialog> {
  late final WebViewController _controller;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setUserAgent('Mozilla/5.0 (iPhone; CPU iPhone OS 16_6 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.6 Mobile/15E148 Safari/604.1')
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              _isLoading = true;
            });
          },
          onPageFinished: (String url) async {
            setState(() {
              _isLoading = false;
            });

            // Heuristic to detect silent fingerprinting (Frictionless Flow):
            // If the URL is still 'about:blank' or a 'data:' URI, it means the WebView
            // loaded our raw HTML string containing the silent 1x1 iframe but did not
            // navigate to any external bank challenge portal.
            try {
              final currentUrl = await _controller.currentUrl();
              debugPrint('3DS WebView current URL: $currentUrl');
              if (currentUrl == null || 
                  currentUrl == 'about:blank' || 
                  currentUrl.startsWith('data:')) {
                debugPrint('3DS: Silent fingerprinting detected. Waiting 3 seconds for background scripts, then auto-closing...');
                await Future.delayed(const Duration(seconds: 3));
                if (mounted) {
                  Navigator.pop(context, true); // Auto-close with success to trigger profile reload!
                }
              }
            } catch (e) {
              debugPrint('Error checking current URL in 3DS: $e');
            }
          },
          onWebResourceError: (WebResourceError error) {
            debugPrint('3DS WebView resource error: ${error.description} (code: ${error.errorCode})');
          },
          onNavigationRequest: (NavigationRequest request) {
            final url = request.url.toLowerCase();
            debugPrint('3DS WebView navigating to: $url');
            
            // If the redirect URL contains our app scheme or standard return URLs, close webview
            if (url.startsWith('fitnflai://') || 
                url.contains('nuvei_redirect') || 
                url.contains('payments/status') || 
                url.contains('payment-methods/membership') ||
                url.contains('success.html') ||
                url.contains('failure.html')) {
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
      debugPrint('3DS: challenge is raw HTML. Loading via loadHtmlString.');
      _controller.loadHtmlString(trimmedChallenge);
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
              if (_isLoading)
                const LinearProgressIndicator(
                  color: AppColors.orange,
                  backgroundColor: Color(0xFF2A2A2A),
                ),
                
              // WebView
              Expanded(
                child: Container(
                  color: Colors.transparent,
                  child: Stack(
                    children: [
                      // Behind: Loader & helper messages
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
                                'Procesando validación con tu banco para tu seguridad. Por favor, no cierres esta pantalla.',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.6),
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                      // In front: WebViewWidget
                      WebViewWidget(controller: _controller),
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
