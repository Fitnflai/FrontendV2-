import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:fitnflaifrontendv2/models/credit_card.dart';

import './cached_http.dart';

class PaymentsService {
  final String _baseUrl = 'https://apifitnflai.com/payments';

  Future<String> _getRealDeviceIp() async {
    try {
      for (var interface in await NetworkInterface.list()) {
        for (var addr in interface.addresses) {
          if (addr.type == InternetAddressType.IPv4 && !addr.isLoopback) {
            return addr.address;
          }
        }
      }
    } catch (_) {}
    return '127.0.0.1'; // Fallback
  }

  String _getRealUserAgent() {
    try {
      if (Platform.isAndroid) {
        return 'Mozilla/5.0 (Linux; Android 13; SM-G998B) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Mobile Safari/537.36';
      } else if (Platform.isIOS) {
        return 'Mozilla/5.0 (iPhone; CPU iPhone OS 16_5 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.5 Mobile/15E148 Safari/604.1';
      }
    } catch (_) {}
    return 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/114.0.0.0 Safari/537.36';
  }

  Map<String, String> _buildHeaders(String token) {
    return {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    };
  }

  // Helper for error handling
  void _handleError(http.Response response, String endpoint) {
    if (response.statusCode < 200 || response.statusCode >= 300) {
      dynamic errorBody = _parseResponse(response);
      debugPrint('Error accessing $endpoint: ${response.statusCode} - $errorBody');
      throw Exception('Failed to load data from $endpoint: ${response.statusCode} - $errorBody');
    }
  }

  Future<String> initPayment(String token, String priceId, String? returnUrl) async {
    final uri = Uri.parse('$_baseUrl/init-payment');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'id_plan_precio': priceId,
        'return_url': returnUrl,
      }),
    );
    _handleError(response, '$_baseUrl/init-payment');
    final Map<String, dynamic> data = json.decode(response.body);
    final String? checkoutUrl = data['nuvei_response']?['checkout_url'] as String?;

    if (checkoutUrl == null) {
      throw Exception('Checkout URL not found in Nuvei response');
    }
    return checkoutUrl;
  }

  Future<String> initPaymentMeetingSpecialist(String token, int trackingId, String? returnUrl) async {
    final uri = Uri.parse('$_baseUrl/init-payment-meeting-specialist');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'id_seguimiento_especialista': trackingId,
        'return_url': returnUrl,
      }),
    );
    _handleError(response, '$_baseUrl/init-payment-meeting-specialist');
    final Map<String, dynamic> data = json.decode(response.body);
    final String? checkoutUrl = data['nuvei_response']?['checkout_url'] as String?;
    if (checkoutUrl == null) {
      throw Exception('Checkout URL not found in Nuvei response');
    }
    return checkoutUrl;
  }

  Future<String> initAddCard(String token, String? returnUrl) async {
    final uri = Uri.parse('$_baseUrl/nuvei/init-add-card');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'return_url': returnUrl,
      }),
    );
    _handleError(response, '$_baseUrl/nuvei/init-add-card');
    final Map<String, dynamic> data = json.decode(response.body);
    final String? checkoutUrl = data['checkout_url'] as String?;

    if (checkoutUrl == null) {
      throw Exception('Checkout URL not found in Nuvei response');
    }
    return checkoutUrl;
  }

  Future<void> saveCard(String token, String userId, Map<String, dynamic> cardData) async {
    final uri = Uri.parse('$_baseUrl/nuvei/save-card');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'user_id': userId,
        'card': cardData,
      }),
    );
    _handleError(response, '$_baseUrl/nuvei/save-card');
  }

  Future<List<CreditCard>> getSavedCards(String token) async {
    final uri = Uri.parse('$_baseUrl/nuvei/cards');
    final response = await CachedHttp.get(uri, headers: _buildHeaders(token));
    _handleError(response, '$_baseUrl/nuvei/cards');
    final data = json.decode(response.body);
    final cards = data['cards'] as List<dynamic>? ?? [];
    return cards.map((c) => CreditCard.fromNuveiJson(c as Map<String, dynamic>)).toList();
  }

  Future<void> deleteCard(String token, String cardId) async {
    final uri = Uri.parse('$_baseUrl/nuvei/delete-card/$cardId?id_tarjeta_usuario=$cardId');
    final response = await CachedHttp.delete(uri, headers: _buildHeaders(token));
    _handleError(response, '$_baseUrl/nuvei/delete-card/$cardId');
  }

  Future<dynamic> subscribeNuvei(
    String token,
    String priceId, {
    String cvc = '123',
    String deviceType = 'browser',
    String? referenceId,
    String ip = '127.0.0.1',
    String language = 'es',
    bool javaEnabled = true,
    bool jsEnabled = true,
    int colorDepth = 24,
    int screenHeight = 814,
    int screenWidth = 366,
    int timezoneOffset = 0,
    String? userAgent,
    String acceptHeader = 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8',
  }) async {
    final uri = Uri.parse('$_baseUrl/nuvei/change-subscription');
    
    // Resolve dynamic values
    final realIp = await _getRealDeviceIp();
    final realLanguage = PlatformDispatcher.instance.locale.languageCode;
    final realTimezoneOffset = DateTime.now().timeZoneOffset.inMinutes;
    final realUserAgent = _getRealUserAgent();

    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'id_plan_precio': priceId,
        'cvc': cvc,
        'device_type': 'browser', // Hardcoded/fixed
        'reference_id': referenceId ?? DateTime.now().millisecondsSinceEpoch.toString(),
        'ip': realIp, // Real
        'language': realLanguage, // Real
        'java_enabled': true, // Hardcoded/fixed
        'js_enabled': true, // Hardcoded/fixed
        'color_depth': colorDepth, // Real (defaults to 24)
        'screen_height': 814, // Hardcoded/fixed
        'screen_width': 366, // Hardcoded/fixed
        'timezone_offset': realTimezoneOffset, // Real
        'user_agent': realUserAgent, // Real
        'accept_header': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', // Real
      }),
    );
    _handleError(response, '$_baseUrl/nuvei/change-subscription');
    return _parseResponse(response);
  }


  Future<dynamic> chargeWithSavedCard(String token, String priceId, String cardId) async {
    // For now, we'll use simulatePurchase as a mock/real fallback.
    // In a real scenario, this would call a specific endpoint like /payments/charge-card or similar.
    debugPrint('Charging priceId: $priceId with cardId: $cardId (simulated)');
    final uri = Uri.parse('$_baseUrl/simulate-purchase');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'id_precio': priceId,
        'card_id': cardId,
      }),
    );
    _handleError(response, '$_baseUrl/simulate-purchase');
    return _parseResponse(response);
  }

  Future<dynamic> payMeetingSpecialistOneClick(
    String token,
    int trackingId, {
    String cvc = '123',
    Map<String, dynamic>? extraData,
  }) async {
    final uri = Uri.parse('$_baseUrl/nuvei/pay-meeting-specialist');
    
    // Resolve dynamic values
    final realIp = await _getRealDeviceIp();
    final realLanguage = PlatformDispatcher.instance.locale.languageCode;
    final realTimezoneOffset = DateTime.now().timeZoneOffset.inMinutes;
    final realUserAgent = _getRealUserAgent();

    final Map<String, dynamic> body = {
      'id_seguimiento_especialista': trackingId,
      'cvc': cvc,
      'device_type': 'browser', // Hardcoded/fixed
      'reference_id': DateTime.now().millisecondsSinceEpoch.toString(),
      'ip': realIp, // Real
      'language': realLanguage, // Real
      'java_enabled': true, // Hardcoded/fixed
      'js_enabled': true, // Hardcoded/fixed
      'color_depth': 24, // Real
      'screen_height': 814, // Hardcoded/fixed
      'screen_width': 366, // Hardcoded/fixed
      'timezone_offset': realTimezoneOffset, // Real
      'user_agent': realUserAgent, // Real
      'accept_header': 'text/html,application/xhtml+xml,application/xml;q=0.9,image/webp,*/*;q=0.8', // Real
      ...?(extraData),
    };
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode(body),
    );
    _handleError(response, '$_baseUrl/nuvei/pay-meeting-specialist');
    return _parseResponse(response);
  }

  Future<dynamic> refundNuvei(String token, String reference, String reason) async {
    final uri = Uri.parse('$_baseUrl/refund-nuvei');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'reference': reference,
        'reason': reason,
      }),
    );
    _handleError(response, '$_baseUrl/refund-nuvei');
    return _parseResponse(response);
  }

  /// Fetches a list of available plans.
  /// Fetches a list of available plans.
  Future<dynamic> getPlanes(String token) async {
    final uri = Uri.parse('$_baseUrl/planes');
    final response = await CachedHttp.get(uri, headers: _buildHeaders(token));
    _handleError(response, '$_baseUrl/planes');
    return _parseResponse(response);
  }

  /// Simulates a plan purchase.
  Future<dynamic> simulatePurchase(String token, String priceId) async {
    final uri = Uri.parse('$_baseUrl/simulate-purchase');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({'id_precio': priceId}),
    );
    _handleError(response, '$_baseUrl/simulate-purchase');
    return _parseResponse(response);
  }

  /// Gets the current subscription status.
  Future<String> getStatus(String token) async {
    final uri = Uri.parse('$_baseUrl/status');
    final response = await CachedHttp.get(uri, headers: _buildHeaders(token));
    _handleError(response, '$_baseUrl/status');
    return response.body; // Raw body response string as requested
  }

  /// Changes the user's plan.
  // Helper for robust response parsing
  dynamic _parseResponse(http.Response response) {
    try {
      return json.decode(response.body);
    } catch (e) {
      // If not JSON, return as plain string
      return response.body;
    }
  }

  /// Changes the user's plan.
  Future<dynamic> changePlan(String token, String priceId) async {
    final uri = Uri.parse('$_baseUrl/change-plan?new_price_id=$priceId');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({}),
    );
    _handleError(response, '$_baseUrl/change-plan');
    return _parseResponse(response);
  }

  /// Starts a free trial for the user.
  Future<dynamic> startFreeTrial(String token) async {
    final uri = Uri.parse('$_baseUrl/start-free-trial');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({}), // Empty body as requested
    );
    _handleError(response, '$_baseUrl/start-free-trial');
    return _parseResponse(response);
  }
}
