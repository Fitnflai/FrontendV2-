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

  const PaymentMethodsScreen({
    super.key,
    this.initialToken,
    this.initialLastFour,
    this.initialBrand,
    this.initialExpMonth,
    this.initialExpYear,
  });

  @override
  State<PaymentMethodsScreen> createState() => _PaymentMethodsScreenState();
}

class _PaymentMethodsScreenState extends State<PaymentMethodsScreen> {
  bool _isLoadingDeepLinkSave = false;

  @override
  void initState() {
    super.initState();
    _loadCards();

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
        _showSuccessSnackBar('Card saved successfully!');
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
        if (!await launchUrl(Uri.parse(checkoutUrl), mode: LaunchMode.inAppWebView)) {
          // Fallback for older devices or if in-app browser fails
          // You might want to show an error or use an external browser
          debugPrint('Could not launch $checkoutUrl in inAppWebView. Trying external.');
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
    return BlockingLoadingOverlay(
      isLoading: _isLoadingDeepLinkSave,
      message: 'Saving card...',
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Payment Methods'),
        ),
        body: Consumer<ProfileProvider>(
          builder: (context, profileProvider, child) {
            if (profileProvider.isLoadingCards) {
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
