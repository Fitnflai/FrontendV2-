import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:fitnflaifrontendv2/models/credit_card.dart';

import './cached_http.dart';

class PaymentsService {
  final String _baseUrl = 'https://apifitnflai.com/payments';

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

  Future<dynamic> subscribeNuvei(String token, String priceId) async {
    final uri = Uri.parse('$_baseUrl/nuvei/subscribe');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'id_plan_precio': priceId,
      }),
    );
    _handleError(response, '$_baseUrl/nuvei/subscribe');
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

  Future<dynamic> payMeetingSpecialistOneClick(String token, int trackingId) async {
    final uri = Uri.parse('$_baseUrl/nuvei/pay-meeting-specialist');
    final response = await CachedHttp.post(
      uri,
      headers: _buildHeaders(token),
      body: json.encode({
        'id_seguimiento_especialista': trackingId,
      }),
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
