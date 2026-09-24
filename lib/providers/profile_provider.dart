import 'package:flutter/widgets.dart'; // Required for WidgetsBindingObserver
import '../services/profile_service.dart';
import '../services/payments_service.dart';
import '../services/cached_http.dart';
import 'package:fitnflaifrontendv2/providers/auth_provider.dart';
import 'package:fitnflaifrontendv2/models/credit_card.dart';

class ProfileProvider with ChangeNotifier, WidgetsBindingObserver {
  final ProfileService _service;
  final PaymentsService _paymentsService = PaymentsService();
  final AuthProvider _authProvider; // Injected AuthProvider

  ProfileProvider({ProfileService? service, required AuthProvider authProvider})
      : _service = service ?? ProfileService(),
        _authProvider = authProvider {
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  List<CreditCard> _savedCards = [];
  bool _isLoadingCards = false;
  bool _isAssociatingCard = false;
  bool _isProcessingOneClick = false;
  String? _cardsError;

  List<CreditCard> get savedCards => _savedCards;
  bool get isLoadingCards => _isLoadingCards;
  bool get isAssociatingCard => _isAssociatingCard;
  set isAssociatingCard(bool value) {
    _isAssociatingCard = value;
    notifyListeners();
  }

  bool get isProcessingOneClick => _isProcessingOneClick;
  set isProcessingOneClick(bool value) {
    _isProcessingOneClick = value;
    notifyListeners();
  }

  String? get cardsError => _cardsError;
  set cardsError(String? value) {
    _cardsError = value;
    notifyListeners();
  }


  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed && _isAssociatingCard) {
      debugPrint('App resumed, reloading profile and cards after card association.');
      CachedHttp.clearCache();
      final String? token = _authProvider.token; // Use injected AuthProvider to get token
      if (token != null) {
        await loadAll(token, force: true);
        await loadSavedCards(token);
      }
      _isAssociatingCard = false;
    }
  }

  List<dynamic>? _planes;
  bool _isLoadingSubscription = false;
  String? _subscriptionError;

  Map<String, dynamic>? _profileData;
  Map<String, dynamic>? _planActivo;
  String? _parqStatus;
  bool _isLoading = false;
  bool _isSaving  = false;
  String? _error;

  Map<String, dynamic>? get profileData => _profileData;
  Map<String, dynamic>? get planActivo  => _planActivo;
  String?               get parqStatus  => _parqStatus;
  bool                  get isLoading   => _isLoading;
  bool                  get isSaving    => _isSaving;
  String?               get error       => _error;
  List<dynamic>?        get planes      => _planes;
  bool                  get isLoadingSubscription => _isLoadingSubscription;
  String?               get subscriptionError => _subscriptionError;
  List<dynamic>?        _citas;
  List<dynamic>?        get citas => _citas;

  Map<String, dynamic>? get upcomingAppointment {
    if (_citas == null || _citas!.isEmpty) {
      return null;
    }

    final now = DateTime.now();

    final pendingAppointments = _citas!.where((cita) {
      final estado = (cita['estado'] as String?)?.toLowerCase() ?? '';
      return estado != 'cancelada' &&
             estado != 'cancelled' &&
             estado != 'rechazada' &&
             estado != 'rejected' &&
             estado != 'completada' &&
             estado != 'completed' &&
             estado != 'done';
    }).toList();

    if (pendingAppointments.isEmpty) {
      return null;
    }

    // Sort chronologically by fecha_hora
    pendingAppointments.sort((a, b) {
      final dateTimeA = DateTime.parse(a['fecha_hora']).toLocal();
      final dateTimeB = DateTime.parse(b['fecha_hora']).toLocal();
      return dateTimeA.compareTo(dateTimeB);
    });

    // Return the first upcoming one
    for (var cita in pendingAppointments) {
      final dateTime = DateTime.parse(cita['fecha_hora']).toLocal();
      if (dateTime.isAfter(now)) {
        return cita;
      }
    }
    return null; // No upcoming pending appointments found
  }

  Future<void> loadAll(String token, {bool force = false}) async {
    if (_profileData == null || force) {
      if (force) {
        CachedHttp.clearCache();
      }
      _isLoading = true;
      _error = null;
      notifyListeners();
    }
    try {
      final results = await Future.wait([
        _service.getMe(token),
        // Handle getPlanActivo errors locally, returning null to allow other futures to complete
        () async {
          try {
            return await _service.getPlanActivo(token);
          } catch (e) {
            debugPrint('Error loading active plan: $e');
            return null; // Return null on error
          }
        }(),
        // Handle getParqStatus errors locally, returning 'CLEAR' as a safe fallback
        () async {
          try {
            return await _service.getParqStatus(token);
          } catch (e) {
            debugPrint('Error loading PARQ status: $e');
            return 'CLEAR'; // Return safe fallback on error
          }
        }(),
        // Handle getMisCitas errors locally, returning an empty list to allow other futures to complete
        () async {
          try {
            return await _service.getMisCitas(token);
          } catch (e) {
            debugPrint('Error loading appointments: $e');
            return []; // Return empty list on error
          }
        }(),
      ]);
      _profileData = results[0] as Map<String, dynamic>;
      _planActivo  = results[1] as Map<String, dynamic>?;
      _parqStatus  = results[2] as String;
      _citas       = results[3] as List<dynamic>;
      _error = null;
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> saveProfile(
    String token, {
    String? nombre,
    String? fechaNacimiento,
    String? genero,
    String? intensidadNotificaciones,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      final updated = await _service.updateProfile(
        token,
        nombre: nombre,
        fechaNacimiento: fechaNacimiento,
        genero: genero,
        intensidadNotificaciones: intensidadNotificaciones,
      );
      _profileData = updated;
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<bool> saveReporte(
    String token, {
    required String diaReporte,
    required String horaReporte,
  }) async {
    _isSaving = true;
    notifyListeners();
    try {
      await _service.updateReporte(token, diaReporte: diaReporte, horaReporte: horaReporte);
      if (_profileData != null) {
        _profileData!['dia_reporte']  = diaReporte;
        _profileData!['hora_reporte'] = horaReporte;
      }
      return true;
    } catch (_) {
      return false;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  Future<void> loadPlanes(String token) async {
    _isLoadingSubscription = true;
    _subscriptionError = null;
    notifyListeners();
    try {
      _planes = await _paymentsService.getPlanes(token);
    } catch (e) {
      _subscriptionError = e.toString();
      debugPrint('Error loading plans: $e');
      rethrow; // Propagate the error
    } finally {
      _isLoadingSubscription = false;
      notifyListeners();
    }
  }

  Future<bool> startFreeTrial(String token) async {
    _isLoadingSubscription = true;
    _subscriptionError = null;
    notifyListeners();
    try {
      await _paymentsService.startFreeTrial(token);
      await loadAll(token, force: true); // Reload profile to sync subscription status
      return true;
    } catch (e) {
      _subscriptionError = e.toString();
      debugPrint('Error starting free trial: $e');
      return false;
    } finally {
      _isLoadingSubscription = false;
      notifyListeners();
    }
  }

  Future<dynamic> simulatePurchase(String token, String priceId) async {
    _isLoadingSubscription = true;
    _subscriptionError = null;
    notifyListeners();
    try {
      final result = await _paymentsService.simulatePurchase(token, priceId);
      return result;
    } catch (e) {
      _subscriptionError = e.toString();
      debugPrint('Error simulating purchase: $e');
      rethrow; // Propagate the error
    } finally {
      _isLoadingSubscription = false;
      notifyListeners();
    }
  }

  Future<dynamic> changePlan(String token, String priceId) async {
    _isLoadingSubscription = true;
    _subscriptionError = null;
    notifyListeners();
    try {
      final result = await _paymentsService.changePlan(token, priceId);
      return result;
    } catch (e) {
      _subscriptionError = e.toString();
      debugPrint('Error changing plan: $e');
      rethrow; // Propagate the error
    } finally {
      _isLoadingSubscription = false;
      notifyListeners();
    }
  }

  Future<String> initPayment(String token, String priceId, String? returnUrl) async {
    _isLoadingSubscription = true;
    _subscriptionError = null;
    notifyListeners();
    try {
      final url = await _paymentsService.initPayment(token, priceId, returnUrl);
      return url;
    } catch (e) {
      _subscriptionError = e.toString();
      debugPrint('Error initiating payment: $e');
      rethrow;
    } finally {
      _isLoadingSubscription = false;
      notifyListeners();
    }
  }

  Future<dynamic> refundNuvei(String token, String reference, String reason) async {
    _isLoadingSubscription = true;
    _subscriptionError = null;
    notifyListeners();
    try {
      final result = await _paymentsService.refundNuvei(token, reference, reason);
      return result;
    } catch (e) {
      _subscriptionError = e.toString();
      debugPrint('Error processing Nuvei refund: $e');
      rethrow;
    } finally {
      _isLoadingSubscription = false;
      notifyListeners();
    }
  }

  Future<void> loadSavedCards(String token) async {
    _isLoadingCards = true;
    _cardsError = null;
    notifyListeners();
    try {
      _savedCards = await _paymentsService.getSavedCards(token);
    } catch (e) {
      _cardsError = e.toString();
      debugPrint('Error loading saved cards: $e');
    } finally {
      _isLoadingCards = false;
      notifyListeners();
    }
  }

  Future<String?> associateCard(String token, {String? returnUrl}) async {
    _isAssociatingCard = true;
    _cardsError = null;
    notifyListeners();
    try {
      final checkoutUrl = await _paymentsService.initAddCard(token, returnUrl);
      return checkoutUrl;
    } catch (e) {
      _cardsError = e.toString();
      debugPrint('Error initiating card association: $e');
      _isAssociatingCard = false; // Reset on error
      notifyListeners();
      return null;
    }
  }

  Future<void> saveCardAction(String token, String userId, Map<String, dynamic> cardData) async {
    _isAssociatingCard = true;
    _cardsError = null;
    notifyListeners();
    try {
      await _paymentsService.saveCard(token, userId, cardData);
      await loadSavedCards(token); // Reload cards after saving
    } catch (e) {
      _cardsError = e.toString();
      debugPrint('Error saving card: $e');
    } finally {
      _isAssociatingCard = false;
      notifyListeners();
    }
  }

  Future<void> deleteCardAction(String token, String cardId) async {
    _isProcessingOneClick = true; // Use this flag to indicate any card-related processing
    _cardsError = null;
    notifyListeners();
    try {
      await _paymentsService.deleteCard(token, cardId);
      _savedCards.removeWhere((card) => card.id == cardId);
    } catch (e) {
      _cardsError = e.toString();
      debugPrint('Error deleting card: $e');
    } finally {
      _isProcessingOneClick = false;
      notifyListeners();
    }
  }

  Future<dynamic> chargeWithSavedCard(String token, String priceId, String cardId) async {
    _isProcessingOneClick = true;
    _cardsError = null;
    notifyListeners();
    try {
      final result = await _paymentsService.chargeWithSavedCard(token, priceId, cardId);
      return result;
    } catch (e) {
      _cardsError = e.toString();
      debugPrint('Error charging with saved card: $e');
      rethrow;
    } finally {
      _isProcessingOneClick = false;
      notifyListeners();
    }
  }

  Future<void> subscribeNuveiAction(String token, String priceId) async {
    _isProcessingOneClick = true;
    _subscriptionError = null;
    notifyListeners();
    try {
      await _paymentsService.subscribeNuvei(token, priceId);
      await loadAll(token, force: true); // Reload all data to reflect new subscription
    } catch (e) {
      _subscriptionError = e.toString();
      debugPrint('Error subscribing with Nuvei: $e');
    } finally {
      _isProcessingOneClick = false;
      notifyListeners();
    }
  }
}

