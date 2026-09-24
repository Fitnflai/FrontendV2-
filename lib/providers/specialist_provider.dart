
import '../services/payments_service.dart';
import 'package:flutter/material.dart';
import '../models/specialist.dart';
import '../services/specialist_service.dart';
import '../models/turno.dart';

enum BookingStatus {
  idle,
  loading,
  success,
  paymentPending,
  slotCollision,
  error,
}

class SpecialistProvider with ChangeNotifier {
  final SpecialistService _specialistService;
  final PaymentsService _paymentsService;

  List<Specialist> _specialists = [];
  List<Specialist> _filteredSpecialists = [];
  bool _isLoading = false;
  String? _errorMessage;
  Specialist? _selectedSpecialist;
  Specialist? _assignedSpecialist;
  bool _isLoadingAssigned = false;

  Map<DateTime, List<Turno>> _specialistAvailability = {};
  List<Turno> _filteredAvailability = [];
  bool _isAvailabilityLoading = false;
  String? _availabilityErrorMessage;

  // Nuvei Payment Specific States
  bool _isPaymentInitializing = false;
  String? _checkoutUrl;
  bool _isWaitingForWebhook = false;
  BookingStatus _bookingStatus = BookingStatus.idle; // Initialize with idle
  String? _paymentErrorMessage;

  bool _isDirectCharging = false;
  String? _directChargeErrorMessage;


  SpecialistProvider(this._specialistService, {PaymentsService? paymentsService})
      : _paymentsService = paymentsService ?? PaymentsService();

  List<Specialist> get specialists => _specialists;
  List<Specialist> get filteredSpecialists => _filteredSpecialists;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  Specialist? get selectedSpecialist => _selectedSpecialist;
  Specialist? get assignedSpecialist => _assignedSpecialist;
  bool get isLoadingAssigned => _isLoadingAssigned;
  Map<DateTime, List<Turno>> get specialistAvailability => _specialistAvailability;
  List<Turno> get filteredAvailability => _filteredAvailability;
  bool get isAvailabilityLoading => _isAvailabilityLoading;
  String? get availabilityErrorMessage => _availabilityErrorMessage;

  // Nuvei Payment Specific Getters
  bool get isPaymentInitializing => _isPaymentInitializing;
  String? get checkoutUrl => _checkoutUrl;
  bool get isWaitingForWebhook => _isWaitingForWebhook;
  BookingStatus get bookingStatus => _bookingStatus;
  String? get paymentErrorMessage => _paymentErrorMessage;

  bool get isDirectCharging => _isDirectCharging;
  String? get directChargeErrorMessage => _directChargeErrorMessage;


  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setErrorMessage(String? message) {
    _errorMessage = message;
    notifyListeners();
  }

  void setSelectedSpecialist(Specialist? specialist) {
    _selectedSpecialist = specialist;
    notifyListeners();
  }

  void _setAvailabilityLoading(bool value) {
    _isAvailabilityLoading = value;
    notifyListeners();
  }

  void _setAvailabilityErrorMessage(String? message) {
    _availabilityErrorMessage = message;
    notifyListeners();
  }

  // Nuvei Payment Specific Setters
  void _setIsPaymentInitializing(bool value) {
    _isPaymentInitializing = value;
    notifyListeners();
  }

  void _setCheckoutUrl(String? url) {
    _checkoutUrl = url;
    notifyListeners();
  }

  void setIsWaitingForWebhook(bool value) {
    _isWaitingForWebhook = value;
    notifyListeners();
  }

  void _setBookingStatus(BookingStatus status) {
    _bookingStatus = status;
    notifyListeners();
  }

  void _setPaymentErrorMessage(String? message) {
    _paymentErrorMessage = message;
    notifyListeners();
  }

  void _setIsDirectCharging(bool value) {
    _isDirectCharging = value;
    notifyListeners();
  }

  void _setDirectChargeErrorMessage(String? value) {
    _directChargeErrorMessage = value;
    notifyListeners();
  }

  Future<void> initiatePaymentFlow(String token, int trackingId, String? returnUrl) async {
    _setIsPaymentInitializing(true);
    _setPaymentErrorMessage(null);
    _setCheckoutUrl(null);
    _setBookingStatus(BookingStatus.loading);
    try {
      final url = await _paymentsService.initPaymentMeetingSpecialist(token, trackingId, returnUrl);
      _setCheckoutUrl(url);
      _setBookingStatus(BookingStatus.idle); // Reset to idle after getting URL, actual booking still pending
    } catch (e) {
      _setPaymentErrorMessage('Error initiating payment: $e');
      _setBookingStatus(BookingStatus.error);
      debugPrint('Error initiating payment flow: $e');
    } finally {
      _setIsPaymentInitializing(false);
    }
  }

  Future<bool> payMeetingSpecialistOneClick(
    String token,
    int trackingId,
  ) async {
    _setIsDirectCharging(true);
    _setDirectChargeErrorMessage(null);
    _setBookingStatus(BookingStatus.loading);
    try {
      await _paymentsService.payMeetingSpecialistOneClick(token, trackingId);
      _setBookingStatus(BookingStatus.success);
      return true;
    } catch (e) {
      debugPrint('Error direct charging meeting: $e');
      _setDirectChargeErrorMessage(e.toString());
      _setBookingStatus(BookingStatus.error);
      return false;
    } finally {
      _setIsDirectCharging(false);
    }
  }

  Future<void> loadAndFilter(String token, String? userDiscipline) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      _specialists = await _specialistService.getSpecialists(token);

      if (userDiscipline != null && userDiscipline.isNotEmpty) {
        final normalizedUserDiscipline = userDiscipline.trim().toLowerCase();
        _filteredSpecialists = _specialists.where((s) {
          return s.disciplinas.any((d) => d.trim().toLowerCase() == normalizedUserDiscipline);
        }).toList();
      } else {
        _filteredSpecialists = _specialists; // If no discipline, show all
      }

      if (_filteredSpecialists.isNotEmpty) {
        _selectedSpecialist = _filteredSpecialists.first; // Auto-select first one initially
      } else {
        _selectedSpecialist = null;
      }

    } catch (e) {
      _setErrorMessage('Error al cargar especialistas: $e');
      debugPrint('Error loading specialists: $e');
      _filteredSpecialists = [];
      _selectedSpecialist = null;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> solicitarCita(
    String token, {
    required int idEspecialista,
    int? idSeguimiento,
    required String fechaHora,
    required bool esExpress,
    required String descripcionCita,
    required String tipoCita,
   }) async {
     _setLoading(true);
     _setBookingStatus(BookingStatus.loading); // Set booking status to loading
    _setPaymentErrorMessage(null); // Clear previous payment error messages

    try {
      await _specialistService.solicitarCita(
        token,
        idEspecialista: idEspecialista,
        idSeguimiento: idSeguimiento,
        fechaHora: fechaHora,
        esExpress: esExpress,
        descripcionCita: descripcionCita,
        tipoCita: tipoCita,
      );
      _setBookingStatus(BookingStatus.success); // On success
      return true;
    } catch (e) {
      debugPrint('Error soliciting appointment: $e');
      _setLoading(false); // Stop loading regardless of error type


      String errorMessage = e.toString().toLowerCase();

      if (errorMessage.contains('409') || errorMessage.contains('slot taken')) {
        _setBookingStatus(BookingStatus.slotCollision);
        _setPaymentErrorMessage('The selected slot is no longer available.');
      } else if (errorMessage.contains('402') || errorMessage.contains('payment pending') || errorMessage.contains('no pagado')) {
        _setBookingStatus(BookingStatus.paymentPending);
        _setPaymentErrorMessage('Payment is still pending. Please verify your payment.');
      } else {
        _setBookingStatus(BookingStatus.error);
        _setPaymentErrorMessage('Error al solicitar cita: $e');
      }
      return false;
    } finally {
      _setLoading(false); // Ensure loading is set to false even after specific error handling
      notifyListeners(); // Notify listeners after status update
    }
  }

  Future<dynamic> refundNuvei(String token, String reference, String reason) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      final response = await _paymentsService.refundNuvei(token, reference, reason);
      _setLoading(false);
      return response;
    } catch (e) {
      _setErrorMessage('Error al solicitar reembolso: $e');
      debugPrint('Error refunding Nuvei: $e');
      _setLoading(false);
      rethrow;
    }
  }

  Future<void> elegirEspecialista(String token, int specialistId) async {
    _setLoading(true);
    _setErrorMessage(null);
    try {
      await _specialistService.requestSpecialistTracking(token, specialistId);
    } catch (e) {
      _setErrorMessage('Error al solicitar seguimiento: $e');
      debugPrint('Error requesting specialist tracking: $e');
      rethrow; // Rethrow to be caught by the UI for specific handling if needed
    } finally {
      _setLoading(false);
    }
  }

  Future<void> loadAssignedSpecialist(String token, int specialistId) async {
    _isLoadingAssigned = true;
    notifyListeners();
    _errorMessage = null; // Clear previous error messages

    try {
      if (_specialists.isEmpty) {
        // Use loadAndFilter to fetch specialists if the list is empty
        // We pass null for userDiscipline as we are not filtering by discipline here
        await loadAndFilter(token, null);
        if (_errorMessage != null) {
          final originalError = _errorMessage!
              .replaceFirst('Error al cargar especialistas: Exception: ', '')
              .replaceFirst('Error al cargar especialistas: ', '');
          throw Exception(originalError);
        }
      }

      final specialist = _specialists.firstWhere(
        (s) => s.id == specialistId,
        orElse: () => throw Exception('Specialist with ID $specialistId not found.'),
      );
      _assignedSpecialist = specialist;
    } catch (e) {
      _errorMessage = 'Error al cargar especialista asignado: $e';
      debugPrint('Error loading assigned specialist: $e');
      _assignedSpecialist = null;
    } finally {
      _isLoadingAssigned = false;
      notifyListeners();
    }
  }

  Future<void> fetchAvailability(String token, DateTime startDate, DateTime endDate) async {
    _setAvailabilityLoading(true);
    _setAvailabilityErrorMessage(null);
    try {
      final formattedStartDate = '${startDate.year}-${startDate.month.toString().padLeft(2, '0')}-${startDate.day.toString().padLeft(2, '0')}';
      final formattedEndDate = '${endDate.year}-${endDate.month.toString().padLeft(2, '0')}-${endDate.day.toString().padLeft(2, '0')}';

      final availability = await _specialistService.getSpecialistAvailability(
          token, formattedStartDate, formattedEndDate);

      _specialistAvailability = {}; // Clear previous availability
      for (var turno in availability) {
        final date = DateTime.parse(turno.fecha); // Parse date without time for map key
        // Normalize date to start of day for consistent map keys
        final normalizedDate = DateTime(date.year, date.month, date.day);
        _specialistAvailability.putIfAbsent(normalizedDate, () => []).add(turno);
      }
    } catch (e) {
      _setAvailabilityErrorMessage('Error al cargar la disponibilidad del especialista: $e');
      debugPrint('Error loading specialist availability: $e');
      _specialistAvailability = {};
    } finally {
      _setAvailabilityLoading(false);
      // After loading, filter for the initial selected date (e.g., today)
      filterAvailabilityForDate(DateTime(startDate.year, startDate.month, startDate.day)); // Filter for the initial date after loading
    }
  }

  void filterAvailabilityForDate(DateTime date) {
    // Normalize selectedDate to start of day for consistent map lookup
    final normalizedDate = DateTime(date.year, date.month, date.day);
    final allSlots = _specialistAvailability[normalizedDate] ?? [];
    final now = DateTime.now();

    _filteredAvailability = allSlots.where((turno) {
      if (turno.estado != 'disponible') return false;
      try {
        final slotTime = DateTime.parse('${turno.fecha} ${turno.horaInicio}');
        if (slotTime.isBefore(now)) return false;
      } catch (_) {}
      return true;
    }).toList();
    notifyListeners();
  }

}

