import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:provider/provider.dart';
import '../../l10n/app_localizations.dart';
import '../../providers/auth_provider.dart';
import '../../providers/profile_provider.dart';
import '../../config/app_colors.dart';
import '../../widgets/shared_widgets.dart';
import '../../widgets/blocking_loading_overlay.dart'; // Import the new overlay widget
import '../../widgets/specialist_selection_bottom_sheet.dart';

class _Plan {
  final int id;
  final String name, tagline, badge;
  final _BadgeColor badgeColor;
  final List<_Feature> features, extras;
  final Map<String, dynamic> originalData; // To store full plan data

  const _Plan({
    required this.id, required this.name,
    required this.tagline, required this.badge,
    required this.badgeColor, required this.features, required this.extras,
    required this.originalData,
  });
}

class _Feature {
  final String label;
  final IconData icon;
  const _Feature(this.label, this.icon);
}


enum _BadgeColor { green, blue, orange }

class MembershipScreen extends StatefulWidget {
  final bool fromOnboarding;
  const MembershipScreen({super.key, this.fromOnboarding = false});
  @override
  State<MembershipScreen> createState() => _MembershipScreenState();
}

class _MembershipScreenState extends State<MembershipScreen> {
  int  _selected   = 1;
  bool _isAnnual   = false;
  List<_Plan> _currentPlans = [];

  String _price(Map<String, dynamic> planData, bool isAnnual) {
    final precios = planData['precios'] as List<dynamic>;
    final priceInfo = precios.firstWhere((p) => p['frecuencia'].contains(isAnnual ? 'anual' : 'mensual'));
    return '\\\$${(priceInfo['precio'] as num).toStringAsFixed(2)}';
  }

  String _period(Map<String, dynamic> planData, bool isAnnual) {
    return isAnnual ? 'por año' : 'por mes';
  }

  String _getPriceId(Map<String, dynamic> planData, bool isAnnual) {
    final precios = planData['precios'] as List<dynamic>;
    final priceInfo = precios.firstWhere((p) => (p['frecuencia'] as String).contains(isAnnual ? 'anual' : 'mensual'));
    return priceInfo['id_precio'] as String;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final token = context.read<AuthProvider>().token;
      if (token == null || token.isEmpty) {
        debugPrint('Error: Token de autenticación no encontrado. Regresando de pantalla.');
        Navigator.pop(context);
      } else {
        final profileProvider = context.read<ProfileProvider>();
        profileProvider.loadPlanes(token);
        profileProvider.loadSavedCards(token);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = context.watch<ProfileProvider>();
    final planes = profileProvider.planes;

    if (profileProvider.isLoadingSubscription || planes == null) {
      return const Scaffold(
        backgroundColor: AppColors.bg,
        body: Center(child: CircularProgressIndicator()),
      );
    }

    _currentPlans = _buildPlans(planes);

    if (profileProvider.pendingCheckoutPriceId != null) {
      final priceId = profileProvider.pendingCheckoutPriceId!;
      _Plan? targetPlan;
      debugPrint('💳 [CHECKOUT MEMBRESIA] pendingCheckoutPriceId is NOT NULL: "$priceId"');
      for (final p in _currentPlans) {
        if (p.originalData['precios'] != null) {
          final precios = p.originalData['precios'] as List;
          debugPrint('💳 [CHECKOUT MEMBRESIA] Checking plan "${p.name}" prices: ${precios.map((pr) => pr['id_precio'])}');
          if (precios.any((pr) => pr['id_precio'] == priceId)) {
            targetPlan = p;
            break;
          }
        }
      }
      debugPrint('💳 [CHECKOUT MEMBRESIA] resolved targetPlan: ${targetPlan?.name}');
      if (targetPlan != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          debugPrint('💳 [CHECKOUT MEMBRESIA] addPostFrameCallback triggered. Reopening checkout bottom sheet for ${targetPlan?.name}...');
          profileProvider.pendingCheckoutPriceId = null; // Clear flag to avoid duplicate modals
          _subscribe(targetPlan!, priceId);
        });
      } else {
        debugPrint('💳 [CHECKOUT MEMBRESIA] WARNING: No exact matching plan found for priceId: "$priceId". Check if price IDs match.');
      }
    }

    return BlockingLoadingOverlay(
      isLoading: profileProvider.isProcessingOneClick,
      message: AppLocalizations.of(context).processingYourPayment,
      child: Scaffold(
        backgroundColor: AppColors.bg,
        appBar: widget.fromOnboarding
            ? null
            : FitnflaiAppBar(title: 'Membresías'),
        body: SafeArea(
          child: Column(children: [
            if (widget.fromOnboarding) ...[
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: Row(children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: AppColors.card,
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(Icons.arrow_back_ios_new,
                          color: AppColors.orange, size: 16),
                    ),
                  ),
                ]),
              ),
            ],
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(children: [
                  // Toggle mensual / anual
                  _BillingToggle(
                    annual: _isAnnual,
                    onChanged: (v) => setState(() => _isAnnual = v),
                  ),
                  const SizedBox(height: 16),

                  // Selector de plan (tabs)
                  _PlanSelector(
                    selected: _selected,
                    onChanged: (i) => setState(() => _selected = i),
                    plans: _currentPlans, // Pass plans to selector
                  ),
                  const SizedBox(height: 16),

                  // Tarjeta del plan seleccionado
                  _PlanCard(
                    plan: _currentPlans[_selected],
                    price: _price(_currentPlans[_selected].originalData, _isAnnual),
                    period: _period(_currentPlans[_selected].originalData, _isAnnual),
                    isActivePlan: (context.watch<AuthProvider>().user?.nombrePlanActivo?.toLowerCase() ?? '') == _currentPlans[_selected].name.toLowerCase(),
                    onSubscribe: () => _subscribe(
                      _currentPlans[_selected],
                      _getPriceId(_currentPlans[_selected].originalData, _isAnnual),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Comparativa
                  _ComparisonTable(),
                  const SizedBox(height: 24),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  List<_Plan> _buildPlans(List<dynamic> planesData) {
    return planesData.map((planData) {
      final name = planData['nombre'] as String? ?? 'Essential';
      int id = 0;
      if (name.toLowerCase().contains('pro')) {
        id = 1;
      } else if (name.toLowerCase().contains('elite') || name.toLowerCase().contains('élite')) {
        id = 2;
      }
      final tagline = planData['descripcion'] as String? ?? '';
      final beneficios = planData['beneficios'] as List<dynamic>? ?? [];

      _BadgeColor badgeColor;
      String badgeText;

      switch (name) {
        case 'Essential':
          badgeColor = _BadgeColor.green;
          badgeText = 'Incluido gratis';
          break;
        case 'Pro':
          badgeColor = _BadgeColor.blue;
          badgeText = 'Más popular';
          break;
        case 'Elite':
          badgeColor = _BadgeColor.orange;
          badgeText = 'Premium';
          break;
        default:
          badgeColor = _BadgeColor.green;
          badgeText = '';
      }

      final features = <_Feature>[];
      final extras = <_Feature>[];

      for (var beneficio in beneficios) {
        if (beneficio is Map<String, dynamic>) {
          final bNombre = beneficio['nombre'] as String? ?? '';
          final bDesc = beneficio['descripcion'] as String? ?? '';
          final featureText = bDesc.isNotEmpty ? '$bNombre: $bDesc' : bNombre;
          final iconName = beneficio['icono'] as String?;
          final icon = _getFeatureIcon(iconName);
          final feature = _Feature(featureText, icon);
          if (beneficio['es_extra'] == true) {
            extras.add(feature);
          } else {
            features.add(feature);
          }
        }
      }

      return _Plan(
        id: id,
        name: name,
        tagline: tagline,
        badge: badgeText,
        badgeColor: badgeColor,
        features: features,
        extras: extras,
        originalData: planData,
      );
    }).toList();
  }

  IconData _getFeatureIcon(String? iconName) {
    switch (iconName) {
      case 'brain': return Icons.psychology_outlined;
      case 'chart': return Icons.show_chart_outlined;
      case 'refresh': return Icons.autorenew_outlined;
      case 'mountain':return Icons.terrain_outlined;
      case 'heart':   return Icons.favorite_border;
      case 'check':   return Icons.check_circle_outline;
      case 'nutrition':return Icons.restaurant_outlined;
      case 'drop':    return Icons.water_drop_outlined;
      case 'sync':    return Icons.sync_outlined;
      case 'shield':  return Icons.verified_user_outlined;
      case 'edit':    return Icons.edit_note_outlined;
      case 'message': return Icons.forum_outlined;
      default: return Icons.check_circle_outline; // Default icon
    }
  }


  void _subscribe(_Plan plan, String priceId) {
    final pageContext = context;
    final token = context.read<AuthProvider>().token;
    if (token != null) {
      context.read<ProfileProvider>().loadSavedCards(token);
    }

    final TextEditingController cvvController = TextEditingController();
    int checkoutStep = 0; // 0: Card selection, 1: Nuvei Webview, 2: Processing, 3: Success
    String? errorMessageCheckout;
    int selectedCardIndex = 0;
    bool showCvvPrompt = false;
    String? cvvError;

    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.card,
      isScrollControlled: true, // Allows content to be full height
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (BuildContext context) {


        return StatefulBuilder(
          builder: (BuildContext dialogContext, StateSetter setModalState) {
            final l10n = AppLocalizations.of(pageContext);
            final authProvider = pageContext.read<AuthProvider>();
            final profileProvider = dialogContext.watch<ProfileProvider>();
            final token = authProvider.token;



            // Common bottom padding for all steps
            final bottomPadding = MediaQuery.of(dialogContext).viewInsets.bottom > 0
                ? 0.0 // Keyboard is open, no extra bottom padding
                : 32.0;

            if (checkoutStep == 0) {
              // Card Selection / Add Card Step
              if (profileProvider.isLoadingCards && profileProvider.savedCards.isEmpty) {
                return _buildLoadingBottomSheet(l10n, l10n.loadingCards);
              }

              if (profileProvider.cardsError != null) {
                return _buildErrorBottomSheet(l10n, profileProvider.cardsError!, () {
                  setModalState(() { errorMessageCheckout = null; profileProvider.cardsError = null; });
                  profileProvider.loadSavedCards(token!);
                });
              }

              if (profileProvider.savedCards.isNotEmpty) {
                final cards = profileProvider.savedCards;
                final selectedCard = cards[selectedCardIndex];

                return Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDragHandle(),
                      const SizedBox(height: 20),
                      if (showCvvPrompt) ...[
                        Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back, color: AppColors.white, size: 20),
                              onPressed: () => setModalState(() => showCvvPrompt = false),
                            ),
                            const Expanded(
                              child: Text(
                                'Confirmación de Seguridad',
                                style: TextStyle(color: AppColors.white, fontSize: 16, fontWeight: FontWeight.w800),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(width: 40), // Balance back button
                          ],
                        ),
                        const SizedBox(height: 15),
                        Text(
                          'Ingresá el código de seguridad (CVV) de tu tarjeta ${selectedCard.brand} finalizada en ${selectedCard.lastFour} para procesar tu suscripción.',
                          style: const TextStyle(color: AppColors.greyLight, fontSize: 13, height: 1.4),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        SizedBox(
                          width: 140,
                          child: TextField(
                            controller: cvvController,
                            keyboardType: TextInputType.number,
                            obscureText: true,
                            maxLength: 4,
                            style: const TextStyle(color: AppColors.white, fontSize: 20, letterSpacing: 8, fontWeight: FontWeight.bold),
                            textAlign: TextAlign.center,
                            decoration: InputDecoration(
                              hintText: '•••',
                              hintStyle: const TextStyle(color: AppColors.grey, fontSize: 20, letterSpacing: 8),
                              counterText: '',
                              errorText: cvvError,
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.orange, width: 2),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: const BorderSide(color: AppColors.border),
                              ),
                            ),
                          ),
                        ),
                        if (errorMessageCheckout != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            errorMessageCheckout!,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 25),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: profileProvider.isProcessingOneClick
                                ? null
                                : () async {
                              final cvv = cvvController.text.trim();
                              final isNumeric = RegExp(r'^\d+$').hasMatch(cvv);
                              if (cvv.length < 3 || cvv.length > 4 || !isNumeric) {
                                setModalState(() {
                                  cvvError = 'CVV inválido (debe tener 3 o 4 dígitos)';
                                });
                                return;
                              }
                              setModalState(() {
                                cvvError = null;
                                errorMessageCheckout = null;
                              });
                              try {
                                profileProvider.isProcessingOneClick = true;
                                final mediaQuery = MediaQuery.of(context);
                                final screenWidth = mediaQuery.size.width.toInt();
                                final screenHeight = mediaQuery.size.height.toInt();
                                final timezoneOffset = DateTime.now().timeZoneOffset.inMinutes;

                                await profileProvider.subscribeNuveiAction(
                                  token!,
                                  priceId,
                                  cvc: cvv,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  timezoneOffset: timezoneOffset,
                                );
                                if (profileProvider.subscriptionError != null) {
                                  setModalState(() {
                                    errorMessageCheckout = profileProvider.subscriptionError;
                                  });
                                } else {
                                  setModalState(() {
                                    checkoutStep = 3;
                                    showCvvPrompt = false;
                                  });
                                  cvvController.clear();
                                  await authProvider.refreshUser();
                                }
                              } catch (e) {
                                setModalState(() {
                                  errorMessageCheckout = e.toString();
                                });
                              } finally {
                                profileProvider.isProcessingOneClick = false;
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: profileProvider.isProcessingOneClick
                                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                                : const Text('Confirmar y Suscribirse',
                                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ] else ...[
                        Text(l10n.subscribeToPlan(plan.name),
                            style: const TextStyle(
                                color: AppColors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w800)),
                        const SizedBox(height: 8),
                        Text(
                            '${_price(plan.originalData, _isAnnual)} ${_period(plan.originalData, _isAnnual)}',
                            style: const TextStyle(
                                color: AppColors.orange,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                        const SizedBox(height: 20),
                        Container(
                          constraints: const BoxConstraints(maxHeight: 180),
                          child: SingleChildScrollView(
                            child: Column(
                              children: List.generate(cards.length, (index) {
                                final card = cards[index];
                                final isSelected = selectedCardIndex == index;
                                return GestureDetector(
                                  onTap: () => setModalState(() => selectedCardIndex = index),
                                  child: Container(
                                    margin: const EdgeInsets.only(bottom: 10),
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.cardDark : AppColors.card,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                          color: isSelected ? AppColors.orange : AppColors.border,
                                          width: isSelected ? 1.5 : 1),
                                    ),
                                    child: Row(
                                      children: [
                                        Icon(
                                            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                                            color: isSelected ? AppColors.orange : AppColors.grey,
                                            size: 18),
                                        const SizedBox(width: 12),
                                        Icon(Icons.credit_card_outlined,
                                            color: isSelected ? AppColors.white : AppColors.grey,
                                            size: 18),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Text(
                                            l10n.payWithCardEnding(card.brand, card.lastFour),
                                            style: TextStyle(
                                                color: isSelected ? AppColors.white : AppColors.grey,
                                                fontSize: 13,
                                                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () async {
                            Navigator.pop(dialogContext); // Close modal
                            try {
                              profileProvider.pendingSubscribePriceId = priceId;
                              profileProvider.isAssociatingCard = true;
                              final returnUrl = 'fitnflai://payment-methods/membership/$priceId';
                              final checkoutUrl = await profileProvider.associateCard(token!, returnUrl: returnUrl);
                              if (checkoutUrl != null) {
                                if (!await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.inAppBrowserView)) {
                                  await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
                                }
                              }
                            } catch (e) {
                              debugPrint('Error asociando tarjeta: $e');
                            } finally {
                              profileProvider.isAssociatingCard = false;
                            }
                          },
                          icon: const Icon(Icons.add_card_outlined, color: AppColors.orange, size: 16),
                          label: const Text('Asociar nueva tarjeta',
                              style: TextStyle(color: AppColors.orange, fontSize: 13, fontWeight: FontWeight.bold)),
                        ),
                        if (errorMessageCheckout != null) ...[
                          const SizedBox(height: 16),
                          Text(
                            errorMessageCheckout!,
                            style: const TextStyle(color: Colors.red, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ],
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () async {
                            final mediaQuery = MediaQuery.of(pageContext);
                            final screenWidth = mediaQuery.size.width.toInt();
                            final screenHeight = mediaQuery.size.height.toInt();
                            final timezoneOffset = DateTime.now().timeZoneOffset.inMinutes;

                            // 1. Show Dialog to collect CVV / CVC (centered, highly stable, keyboard friendly)
                            final TextEditingController tempCvvController = TextEditingController();
                            final bool? confirmed = await showDialog<bool>(
                                context: dialogContext,
                                barrierDismissible: false,
                                builder: (BuildContext alertContext) {
                                  String? localError;
                                  return StatefulBuilder(
                                    builder: (context, setDialogState) {
                                      return AlertDialog(
                                        backgroundColor: const Color(0xFF1E1E1E),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                                        title: const Text(
                                          'Confirmación de Seguridad',
                                          style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                                          textAlign: TextAlign.center,
                                        ),
                                        content: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Por motivos de seguridad, ingresá el código de verificación (CVV) de tu tarjeta ${selectedCard.brand} finalizada en ${selectedCard.lastFour} para procesar tu suscripción.',
                                              style: const TextStyle(color: Colors.grey, fontSize: 13, height: 1.4),
                                              textAlign: TextAlign.center,
                                            ),
                                            const SizedBox(height: 16),
                                            SizedBox(
                                              width: 120,
                                              child: TextField(
                                                controller: tempCvvController,
                                                keyboardType: TextInputType.number,
                                                obscureText: true,
                                                maxLength: 4,
                                                style: const TextStyle(color: Colors.white, fontSize: 20, letterSpacing: 8, fontWeight: FontWeight.bold),
                                                textAlign: TextAlign.center,
                                                decoration: InputDecoration(
                                                  hintText: '•••',
                                                  hintStyle: const TextStyle(color: Colors.grey, fontSize: 20, letterSpacing: 8),
                                                  counterText: '',
                                                  errorText: localError,
                                                  focusedBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(color: Colors.orange, width: 2),
                                                  ),
                                                  enabledBorder: OutlineInputBorder(
                                                    borderRadius: BorderRadius.circular(10),
                                                    borderSide: const BorderSide(color: Color(0xFF2E2E2E)),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                                        actions: [
                                          TextButton(
                                            onPressed: () => Navigator.pop(alertContext, false),
                                            child: const Text('Cancelar', style: TextStyle(color: Colors.grey)),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              final cvvVal = tempCvvController.text.trim();
                                              final isNumeric = RegExp(r'^\d+$').hasMatch(cvvVal);
                                              if (cvvVal.length < 3 || cvvVal.length > 4 || !isNumeric) {
                                                setDialogState(() {
                                                  localError = 'CVV inválido';
                                                });
                                                return;
                                              }
                                              Navigator.pop(alertContext, true);
                                            },
                                            child: const Text('Confirmar', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                                          ),
                                        ],
                                      );
                                    },
                                  );
                                },
                              );

                              if (confirmed != true) return;

                              final cvv = tempCvvController.text.trim();

                              try {
                                setModalState(() {
                                  checkoutStep = 2; // Show processing loader
                                  errorMessageCheckout = null;
                                });

                                await profileProvider.subscribeNuveiAction(
                                  token!,
                                  priceId,
                                  cvc: cvv,
                                  screenWidth: screenWidth,
                                  screenHeight: screenHeight,
                                  timezoneOffset: timezoneOffset,
                                );

                                if (profileProvider.subscriptionError != null) {
                                  setModalState(() {
                                    checkoutStep = 0; // Go back to card selection so they can try again or see error
                                    errorMessageCheckout = profileProvider.subscriptionError;
                                  });
                                } else {
                                  setModalState(() {
                                    checkoutStep = 3; // Success!
                                  });
                                  await authProvider.refreshUser();
                                }
                              } catch (e) {
                                setModalState(() {
                                  checkoutStep = 0;
                                  errorMessageCheckout = e.toString();
                                });
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.orange,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                              elevation: 0,
                            ),
                            child: Text(l10n.confirmAndSubscribe,
                                style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                          ),
                        ),
                      ],
                    ],
                  ),
                );
              } else {
                // No saved cards, initiate Add Card flow
                return Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      _buildDragHandle(),
                      const SizedBox(height: 20),
                      Text(l10n.subscribeToPlan(plan.name),
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(
                          '${_price(plan.originalData, _isAnnual)} ${_period(plan.originalData, _isAnnual)}',
                          style: const TextStyle(
                              color: AppColors.orange,
                              fontSize: 16,
                              fontWeight: FontWeight.w600)),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: const Row(children: [
                          Icon(Icons.info_outline, color: AppColors.grey, size: 16),
                          SizedBox(width: 10),
                          Expanded(child: Text(
                            'Para suscribirte, primero necesitas asociar una tarjeta de crédito.',
                            style: TextStyle(color: AppColors.grey, fontSize: 12, height: 1.4),
                          )),
                        ]),
                      ),
                      if (errorMessageCheckout != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          errorMessageCheckout!,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: profileProvider.isAssociatingCard
                              ? null
                              : () async {
                            setModalState(() {
                              errorMessageCheckout = null;
                            });
                             try {
                                 profileProvider.pendingSubscribePriceId = priceId;
                                 profileProvider.isAssociatingCard = true;
                               // Deep link for app to resume
                               final returnUrl = 'fitnflai://payment-methods/membership/$priceId';
                              final checkoutUrl = await profileProvider.associateCard(token!, returnUrl: returnUrl);

                              if (checkoutUrl != null) {
                                if (!await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.inAppBrowserView)) {
                                  debugPrint('Could not launch $checkoutUrl in inAppBrowserView. Trying external.');
                                  await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
                                }
                                // After launching, we don't immediately set checkoutStep to 2.
                                // The app will resume, and didChangeAppLifecycleState will trigger card reload.
                                // Keep this modal open to show status if needed, or close it and let the profile screen handle it.
                                // For now, let's just close this modal and rely on the profile screen to refresh.
                                if (dialogContext.mounted) {
                                  Navigator.pop(dialogContext); // Close this bottom sheet
                                }
                              } else if (profileProvider.cardsError != null) {
                                if (pageContext.mounted) {
                                  _showErrorSnackBar(pageContext, profileProvider.cardsError!);
                                }
                              }
                            } catch (e) {
                              setModalState(() {
                                errorMessageCheckout = e.toString();
                              });
                            } finally {
                                profileProvider.isAssociatingCard = false;
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: profileProvider.isAssociatingCard
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(l10n.associateCardAndSubscribe,
                              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                      ),
                    ],
                  ),
                );
              }
            } else if (checkoutStep == 1) {
              // Existing Nuvei Webview logic
              return PopScope(
                canPop: !profileProvider.isLoadingSubscription,
                child: Padding(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    _buildDragHandle(),
                    if (profileProvider.isLoadingSubscription) ...[
                      const SizedBox(height: 30),
                      CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
                      ),
                      const SizedBox(height: 24),
                      Text(l10n.processingYourPayment,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Text(
                          l10n.nuveiVerificationMessage,
                          style: const TextStyle(
                              color: AppColors.greyLight, fontSize: 13, height: 1.4),
                          textAlign: TextAlign.center),
                      const SizedBox(height: 30),
                    ] else ...[
                      const SizedBox(height: 20),
                      Text(l10n.membershipNuveiVerifyButton,
                          style: const TextStyle(
                              color: AppColors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800)),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.cardDark,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.border),
                        ),
                        child: Text(
                          l10n.membershipNuveiInstructions,
                          style: const TextStyle(
                              color: AppColors.white, fontSize: 13, height: 1.4),
                        ),
                      ),
                      if (errorMessageCheckout != null) ...[
                        const SizedBox(height: 16),
                        Text(
                          errorMessageCheckout!,
                          style: const TextStyle(color: Colors.red, fontSize: 14),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: profileProvider.isLoadingSubscription ? null : () {
                            setModalState(() {
                              errorMessageCheckout = null;
                              // This will be handled by the ProfileProvider's lifecycle observer
                            });
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            elevation: 0,
                          ),
                          child: profileProvider.isLoadingSubscription
                              ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                              : Text(l10n.membershipNuveiVerifyButton,
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.w700)),
                        ),
                      ),
                      const SizedBox(height: 10),
                      SizedBox(
                        width: double.infinity,
                        child: TextButton(
                          onPressed: () => Navigator.pop(dialogContext),
                          child: Text(l10n.membershipNuveiCloseButton,
                              style: const TextStyle(
                                  color: AppColors.greyLight, fontSize: 14)),
                        ),
                      ),
                    ],
                  ]),
                ),
              );
            } else if (checkoutStep == 3) {
              return Padding(
                padding: EdgeInsets.fromLTRB(20, 20, 20, bottomPadding),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDragHandle(),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: const BoxDecoration(
                        color: Colors.green,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Text(
                      l10n.paymentCompleted,
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      l10n.membershipActivatedMessage,
                      style: const TextStyle(
                        color: AppColors.greyLight,
                        fontSize: 14,
                        height: 1.5,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      child:                       ElevatedButton(
                        onPressed: () async {
                          Navigator.pop(dialogContext); // Close success modal
                          final planName = plan.name.toLowerCase();
                          final isElite = planName.contains('elite') || planName.contains('élite');
                          final specialistId = profileProvider.profileData?['id_especialista'];
                          final hasSpecialist = specialistId != null &&
                              (specialistId is num || (specialistId is String && specialistId.trim().isNotEmpty && specialistId.trim() != 'null'));

                          if (isElite && !hasSpecialist) {
                            final selected = await showModalBottomSheet<bool>(
                              context: pageContext,
                              isScrollControlled: true,
                              isDismissible: false,
                              enableDrag: false,
                              builder: (ctx) => const SpecialistSelectionBottomSheet(),
                            );
                            if (selected == true && pageContext.mounted) {
                              Navigator.pop(pageContext); // Go back to profile screen
                            }
                          } else {
                            if (pageContext.mounted) {
                              Navigator.pop(pageContext); // Go back to profile screen
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          l10n.startTraining,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            } else {
              return const SizedBox.shrink(); // Fallback for unexpected checkoutStep
            }
          },
        );
      },
    );
  }

  Widget _buildDragHandle() {
    return Container(
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: AppColors.border,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }

  Widget _buildLoadingBottomSheet(AppLocalizations l10n, String message) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 30),
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppColors.orange),
          ),
          const SizedBox(height: 24),
          Text(message,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold)),
          const SizedBox(height: 30),
        ],
      ),
    );
  }

  void _showErrorSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  Widget _buildErrorBottomSheet(AppLocalizations l10n, String errorMessage, VoidCallback onRetry) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildDragHandle(),
          const SizedBox(height: 20),
          Text(l10n.errorTitle,
              style: const TextStyle(
                  color: Colors.red,
                  fontSize: 18,
                  fontWeight: FontWeight.w800)),
          const SizedBox(height: 16),
          Text(errorMessage,
              style: const TextStyle(color: AppColors.greyLight, fontSize: 14),
              textAlign: TextAlign.center),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: onRetry,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.orange,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                elevation: 0,
              ),
              child: Text(l10n.retryButton,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ),
          ),
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(l10n.cancelButton,
                  style: const TextStyle(color: AppColors.greyLight, fontSize: 14)),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// DATA MODELS
// ═══════════════════════════════════════════════════════════════

// ═══════════════════════════════════════════════════════════════
// TRIAL BANNER
// ═══════════════════════════════════════════════════════════════
// ═══════════════════════════════════════════════════════════════
// BILLING TOGGLE
// ═══════════════════════════════════════════════════════════════
class _BillingToggle extends StatelessWidget {
  final bool annual;
  final ValueChanged<bool> onChanged;
  const _BillingToggle({required this.annual, required this.onChanged});

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(children: [
      Expanded(child: GestureDetector(
        onTap: () => onChanged(false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: !annual ? AppColors.cardDark : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: !annual ? Border.all(color: AppColors.border) : null,
          ),
          child: Text('Mensual',
              textAlign: TextAlign.center,
              style: TextStyle(
                  color: !annual ? AppColors.white : AppColors.grey,
                  fontSize: 13, fontWeight: !annual ? FontWeight.w600 : FontWeight.w400)),
        ),
      )),
      Expanded(child: GestureDetector(
        onTap: () => onChanged(true),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: annual ? AppColors.cardDark : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            border: annual ? Border.all(color: AppColors.orange.withValues(alpha: 0.5)) : null,
          ),
          child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text('Anual',
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: annual ? AppColors.white : AppColors.grey,
                    fontSize: 13, fontWeight: annual ? FontWeight.w600 : FontWeight.w400)),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF1A3A0A),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text('-15%',
                  style: TextStyle(color: AppColors.greenText,
                      fontSize: 10, fontWeight: FontWeight.w700)),
            ),
          ]),
        ),
      )),
    ]),
  );
}

// ═══════════════════════════════════════════════════════════════
// PLAN SELECTOR TABS
// ═══════════════════════════════════════════════════════════════
class _PlanSelector extends StatelessWidget {
  final int selected;
  final ValueChanged<int> onChanged;
  final List<_Plan> plans;
  const _PlanSelector({required this.selected, required this.onChanged, required this.plans});



  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(4),
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(12),
      border: Border.all(color: AppColors.border),
    ),
    child: Row(
      children: List.generate(3, (i) => Expanded(
        child: GestureDetector(
          onTap: () => onChanged(i),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 180),
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: i == selected ? AppColors.orange : Colors.transparent,
              borderRadius: BorderRadius.circular(9),
            ),
            child: Text(plans[i].name,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: i == selected ? Colors.white : AppColors.grey,
                    fontSize: 14,
                    fontWeight: i == selected
                        ? FontWeight.w700 : FontWeight.w400)),
          ),
        ),
      )),
    ),
  );
}

// ═══════════════════════════════════════════════════════════════
// PLAN CARD
// ═══════════════════════════════════════════════════════════════
class _PlanCard extends StatelessWidget {
  final _Plan plan;
  final String price, period;
  final VoidCallback onSubscribe;
  final bool isActivePlan;
  const _PlanCard({required this.plan, required this.price,
      required this.period, required this.onSubscribe, required this.isActivePlan});

  @override
  Widget build(BuildContext context) {
    final borderColor = plan.id == 1
        ? const Color(0xFF1A4A8A)
        : AppColors.border;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: borderColor,
          width: plan.id == 1 ? 1.5 : 1,
        ),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        // Badge
        _Badge(text: plan.badge, color: plan.badgeColor),
        const SizedBox(height: 12),

        // Header
        Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(plan.name,
                  style: const TextStyle(color: AppColors.white,
                      fontSize: 22, fontWeight: FontWeight.w800)),
              const SizedBox(height: 2),
              Text(plan.tagline,
                  style: const TextStyle(color: AppColors.grey, fontSize: 13)),
            ]),
          ),
          Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
            Text(price,
                style: const TextStyle(color: AppColors.orange,
                    fontSize: 22, fontWeight: FontWeight.w800)),
            Text(period,
                style: const TextStyle(color: AppColors.grey, fontSize: 11)),
          ]),
        ]),
        const SizedBox(height: 16),
        const Divider(color: AppColors.border, height: 1),
        const SizedBox(height: 14),

        // Features base
        ...plan.features.map((f) => _FeatureRow(feature: f, isExtra: false)),

        // Extras con header
        if (plan.extras.isNotEmpty) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.cardDark,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              plan.id == 1 ? 'Nutrición e hidratación' : 'Validación humana',
              style: const TextStyle(color: AppColors.greyLight,
                  fontSize: 11, fontWeight: FontWeight.w600,
                  letterSpacing: 0.3),
            ),
          ),
          const SizedBox(height: 8),
          ...plan.extras.map((f) => _FeatureRow(feature: f, isExtra: true)),
        ],

        // Nota Elite
        if (plan.id == 2) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF0A1A2E),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                  color: const Color(0xFF1A4A8A).withValues(alpha: 0.5)),
            ),
            child: const Row(
                crossAxisAlignment: CrossAxisAlignment.start, children: [
              Icon(Icons.person_search_outlined,
                  color: Color(0xFF4A90D9), size: 16),
              SizedBox(width: 8),
              Expanded(child: Text(
                'La IA genera el plan y el deportólogo lo revisa, valida y personaliza antes de que llegue a ti.',
                style: TextStyle(color: Color(0xFF7AAED9),
                    fontSize: 12, height: 1.4),
              )),
            ]),
          ),
        ],

        const SizedBox(height: 18),
        SizedBox(
          width: double.infinity, height: 48,
          child: ElevatedButton(
            onPressed: isActivePlan ? null : onSubscribe,
            style: ElevatedButton.styleFrom(
              backgroundColor: isActivePlan
                  ? AppColors.cardDark
                  : AppColors.orange,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              side: isActivePlan
                  ? const BorderSide(color: AppColors.border)
                  : BorderSide.none,
              elevation: 0,
            ),
            child: Text(
              isActivePlan
                  ? 'Tu plan actual'
                  : 'Suscribirme a ${plan.name}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w700),
            ),
          ),
        ),
      ]),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final _Feature feature;
  final bool isExtra;
  const _FeatureRow({required this.feature, required this.isExtra});

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 8),
    child: Row(children: [
      Icon(feature.icon,
          color: isExtra ? AppColors.orange : AppColors.greenText,
          size: 16),
      const SizedBox(width: 10),
      Expanded(child: Text(feature.label,
          style: const TextStyle(color: AppColors.greyLight,
              fontSize: 13, height: 1.3))),
    ]),
  );
}

class _Badge extends StatelessWidget {
  final String text;
  final _BadgeColor color;
  const _Badge({required this.text, required this.color});

  @override
  Widget build(BuildContext context) {
    Color bg, fg;
    switch (color) {
      case _BadgeColor.green:
        bg = AppColors.greenBg; fg = AppColors.greenText; break;
      case _BadgeColor.blue:
        bg = const Color(0xFF0A1A2E); fg = const Color(0xFF4A90D9); break;
      case _BadgeColor.orange:
        bg = const Color(0xFF2A1A0A); fg = AppColors.orange; break;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: fg.withValues(alpha: 0.4)),
      ),
      child: Text(text, style: TextStyle(
          color: fg, fontSize: 11, fontWeight: FontWeight.w600)),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// COMPARISON TABLE
// ═══════════════════════════════════════════════════════════════
class _ComparisonTable extends StatelessWidget {
  static const _rows = [
    ['Plan de entrenamiento IA',       true,  true,  true ],
    ['Seguimiento y progreso',          true,  true,  true ],
    ['Altitud inteligente',             true,  true,  true ],
    ['Plan nutricional IA',             false, true,  true ],
    ['Guía de hidratación',             false, true,  true ],
    ['Validación por deportólogo',      false, false, true ],
    ['Canal con tu deportólogo',        false, false, true ],
  ];

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(14),
      border: Border.all(color: AppColors.border),
    ),
    child: Column(children: [
      // Header
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: const BoxDecoration(
          color: AppColors.cardDark,
          borderRadius: BorderRadius.vertical(top: Radius.circular(13)),
        ),
        child: const Row(children: [
          Expanded(flex: 3, child: Text('Característica',
              style: TextStyle(color: AppColors.grey, fontSize: 11,
                  fontWeight: FontWeight.w600))),
          Expanded(child: Text('ESS', textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, fontSize: 11,
                  fontWeight: FontWeight.w600))),
          Expanded(child: Text('PRO', textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.orange, fontSize: 11,
                  fontWeight: FontWeight.w600))),
          Expanded(child: Text('ELITE', textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.grey, fontSize: 11,
                  fontWeight: FontWeight.w600))),
        ]),
      ),
      ..._rows.asMap().entries.map((entry) {
        final row = entry.value;
        return Column(children: [
          const Divider(color: AppColors.border, height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: Row(children: [
              Expanded(flex: 3, child: Text(row[0] as String,
                  style: const TextStyle(color: AppColors.greyLight,
                      fontSize: 12))),
              Expanded(child: Center(child: _Cell(row[1] as bool))),
              Expanded(child: Center(child: _Cell(row[2] as bool,
                  highlight: true))),
              Expanded(child: Center(child: _Cell(row[3] as bool))),
            ]),
          ),
        ]);
      }),
    ]),
  );
}

class _Cell extends StatelessWidget {
  final bool value;
  final bool highlight;
  const _Cell(this.value, {this.highlight = false});

  @override
  Widget build(BuildContext context) => value
      ? Icon(Icons.check_circle,
          color: highlight ? AppColors.orange : AppColors.greenText,
          size: 16)
      : const Icon(Icons.remove, color: AppColors.border, size: 16);
}
