import 'package:fitnflaifrontendv2/widgets/blocking_loading_overlay.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fitnflaifrontendv2/providers/profile_provider.dart';
import 'package:fitnflaifrontendv2/providers/auth_provider.dart';
import 'package:fitnflaifrontendv2/models/credit_card.dart';

class PaymentMethodsScreen extends StatefulWidget {
  static const String routeName = '/payment-methods';

  final String? initialToken;
  final String? initialLastFour;
  final String? initialBrand;
  final String? initialExpMonth;
  final String? initialExpYear;
  final bool isFromMembership;
  final String? priceId;

  const PaymentMethodsScreen({
    super.key,
    this.initialToken,
    this.initialLastFour,
    this.initialBrand,
    this.initialExpMonth,
    this.initialExpYear,
    this.isFromMembership = false,
    this.priceId,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  bool _isLoadingDeepLinkSave = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadCards();
    });

    if (widget.initialToken != null) {
      _isLoadingDeepLinkSave = true; // Activate loader immediately
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _saveCardFromDeepLink();
      });
    }
  }

  Future<void> _saveCardFromDeepLink() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    if (authProvider.token == null || authProvider.user?.id == null) {
      _showErrorSnackBar('Please log in to save your card.');
      setState(() {
        _isLoadingDeepLinkSave = false;
      });
      return;
    }

    try {
      final cardData = {
        'token': widget.initialToken,
        'last_four': widget.initialLastFour,
        'brand': widget.initialBrand,
        'exp_month': widget.initialExpMonth,
        'exp_year': widget.initialExpYear,
        'status': 'success',
      };
      // Remove null values from cardData map to avoid issues with JSON serialization
      cardData.removeWhere((key, value) => value == null);

      await profileProvider.saveCardAction(
        authProvider.token!,
        authProvider.user!.id,
        cardData as Map<String, dynamic>,
      );
      if (profileProvider.cardsError != null) {
        _showErrorSnackBar(profileProvider.cardsError!);
      } else {
        _showSuccessSnackBar('¡Tarjeta guardada correctamente!');
        profileProvider.pendingSubscribePriceId = null; // Clear memory cache
        if (mounted) {
          await profileProvider.loadSavedCards(authProvider.token!);
          if (mounted) {
            Navigator.of(context).pop(); // Go back to MembershipScreen
          }
        }
      }
    } catch (e) {
      _showErrorSnackBar('Failed to save card: $e');
    } finally {
      setState(() {
        _isLoadingDeepLinkSave = false;
      });
    }
  }

  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  Future<void> _loadCards() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);
    if (authProvider.token != null) {
      await profileProvider.loadSavedCards(authProvider.token!);
    }
  }

  Future<void> _associateCard() async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    if (authProvider.token != null) {
      const returnUrl = 'fitnflai://payment-methods'; // Deep link for app to resume
      final checkoutUrl = await profileProvider.associateCard(authProvider.token!, returnUrl: returnUrl);
      if (checkoutUrl != null) {
        if (!await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.inAppBrowserView)) {
          // Fallback for older devices or if in-app browser fails
          // You might want to show an error or use an external browser
          debugPrint('Could not launch $checkoutUrl in inAppBrowserView. Trying external.');
          await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.externalApplication);
        }
      } else if (profileProvider.cardsError != null) {
        _showErrorSnackBar(profileProvider.cardsError!);
      }
    }
  }

  Future<void> _confirmDeleteCard(CreditCard card) async {
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Card'),
          content: Text('Are you sure you want to delete your ${card.brand} card ending in ${card.lastFour}?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      _deleteCard(card.id);
    }
  }

  Future<void> _deleteCard(String cardId) async {
    final authProvider = Provider.of<AuthProvider>(context, listen: false);
    final profileProvider = Provider.of<ProfileProvider>(context, listen: false);

    if (authProvider.token != null) {
      await profileProvider.deleteCardAction(authProvider.token!, cardId);
      if (profileProvider.cardsError != null) {
        _showErrorSnackBar(profileProvider.cardsError!);
      }
    }
  }

  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<ProfileProvider>(context);
    final isFromMembershipFlow = widget.isFromMembership || profileProvider.pendingSubscribePriceId != null;

    if (isFromMembershipFlow) {
      return Scaffold(
        backgroundColor: const Color(0xFF121212),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (_isLoadingDeepLinkSave) ...[
                  const CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.orange),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Vinculando tarjeta...',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Por favor, no cierres la aplicación mientras guardamos tu método de pago.',
                    style: TextStyle(color: Colors.grey, fontSize: 13),
                    textAlign: TextAlign.center,
                  ),
                ] else if (profileProvider.cardsError != null) ...[
                  const Icon(Icons.error_outline, color: Colors.red, size: 60),
                  const SizedBox(height: 24),
                  const Text(
                    'Error al guardar tarjeta',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    profileProvider.cardsError!,
                    style: const TextStyle(color: Colors.redAccent, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        profileProvider.pendingSubscribePriceId = null; // Clear on error too
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Volver', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ] else ...[
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: const BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.check, color: Colors.white, size: 40),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    '¡Tarjeta guardada correctamente!',
                    style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tu método de pago ha sido registrado de forma segura. Ahora podés completar tu suscripción seleccionando la tarjeta e ingresando tu CVC.',
                    style: TextStyle(color: Colors.grey, fontSize: 14),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Pop to go back to home/profile
                        Navigator.of(context).pop();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Continuar', style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      );
    }

    return BlockingLoadingOverlay(
      isLoading: _isLoadingDeepLinkSave,
      message: 'Saving card...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Methods'),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            if (profileProvider.isLoadingCards && profileProvider.savedCards.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            if (profileProvider.cardsError != null) {
              return Center(child: Text('Error: ${profileProvider.cardsError}'));
            }

            if (profileProvider.savedCards.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('No saved cards. Add one to get started!'),
                    ElevatedButton(
                      onPressed: profileProvider.isAssociatingCard || profileProvider.isProcessingOneClick
                          ? null
                          : _associateCard,
                      child: const Text('Add Card'),
                    ),
                  ],
                ),
              );
            }

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: profileProvider.savedCards.length,
                    itemBuilder: (context, index) {
                      final card = profileProvider.savedCards[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: ListTile(
                          leading: _buildCardBrandIcon(card.brand),
                          title: Text('${card.brand} **** ${card.lastFour}'),
                          subtitle: Text('Expires: ${card.expMonth}/${card.expYear}'),
                          trailing: IconButton(
                            icon: profileProvider.isProcessingOneClick
                                ? const CircularProgressIndicator.adaptive()
                                : const Icon(Icons.delete),
                            onPressed: profileProvider.isProcessingOneClick
                                ? null
                                : () => _confirmDeleteCard(card),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: profileProvider.isAssociatingCard || profileProvider.isProcessingOneClick
                        ? null
                        : _associateCard,
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: profileProvider.isAssociatingCard
                        ? const CircularProgressIndicator.adaptive(valueColor: AlwaysStoppedAnimation<Color>(Colors.white))
                        : const Text('Add New Card'),
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildCardBrandIcon(String brand) {
    IconData iconData;
    switch (brand.toLowerCase()) {
      case 'visa':
        iconData = Icons.credit_card;
        break;
      case 'mastercard':
        iconData = Icons.credit_card;
        break;
      default:
        iconData = Icons.credit_card;
    }
    return Icon(iconData);
  }
}
