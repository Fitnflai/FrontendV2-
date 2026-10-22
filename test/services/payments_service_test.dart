import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:fitnflaifrontendv2/services/payments_service.dart';
import 'package:fitnflaifrontendv2/services/cached_http.dart'; // Ensure correct import path for CachedHttp

import 'payments_service_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  group('PaymentsService', () {
    late PaymentsService paymentsService;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      paymentsService = PaymentsService();
      // Inject the mock client into CachedHttp for testing
      CachedHttp.client = mockClient;
    });

    test('payMeetingSpecialistOneClick - success', () async {
      const token = 'test_token';
      const trackingId = 123;

      final responseBody = json.encode({'status': 'success', 'message': 'Payment successful'});

      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseBody, 200));

      final result = await paymentsService.payMeetingSpecialistOneClick(token, trackingId);

      expect(result, {'status': 'success', 'message': 'Payment successful'});
      verify(mockClient.post(
        Uri.parse('https://apifitnflai.com/payments/nuvei/pay-meeting-specialist'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: anyNamed('body'),
      )).called(1);
    });

    test('payMeetingSpecialistOneClick - failure (400 bad request)', () async {
      const token = 'test_token';
      const trackingId = 123;

      final responseBody = json.encode({'status': 'error', 'message': 'Invalid card'});

      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseBody, 400));

      final future = paymentsService.payMeetingSpecialistOneClick(token, trackingId);
      await expectLater(
        future,
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Failed to load data from https://apifitnflai.com/payments/nuvei/pay-meeting-specialist: 400 - {status: error, message: Invalid card}'))),
      );

      verify(mockClient.post(
        Uri.parse('https://apifitnflai.com/payments/nuvei/pay-meeting-specialist'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: anyNamed('body'),
      )).called(1);
    });

    test('payMeetingSpecialistOneClick - failure (500 internal server error)', () async {
      const token = 'test_token';
      const trackingId = 123;

      final responseBody = json.encode({'status': 'error', 'message': 'Internal server error'});

      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async => http.Response(responseBody, 500));

      final future = paymentsService.payMeetingSpecialistOneClick(token, trackingId);
      await expectLater(
        future,
        throwsA(isA<Exception>().having((e) => e.toString(), 'message', contains('Failed to load data from https://apifitnflai.com/payments/nuvei/pay-meeting-specialist: 500 - {status: error, message: Internal server error}'))),
      );
    });

    test('getEstadoTransaccion - success', () async {
      const token = 'test_token';
      const gatewayPaymentId = 'DF-2159885';

      final responseBody = json.encode({
        'id_transaccion': '3fa85f64-5717-4562-b3fc-2c963f66afa6',
        'estado': 'Aprobada',
        'tipo': 'subscripcion',
        'gateway_payment_id': gatewayPaymentId,
        'monto': 29.99,
      });

      when(mockClient.get(
        Uri.parse('https://apifitnflai.com/payments/estado-transaccion?gateway_payment_id=$gatewayPaymentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response(responseBody, 200));

      final result = await paymentsService.getEstadoTransaccion(token, gatewayPaymentId);

      expect(result['estado'], 'Aprobada');
      expect(result['gateway_payment_id'], gatewayPaymentId);
      verify(mockClient.get(
        Uri.parse('https://apifitnflai.com/payments/estado-transaccion?gateway_payment_id=$gatewayPaymentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      )).called(1);
    });

    test('getEstadoTransaccion - 404 returns pending status gracefully for polling', () async {
      const token = 'test_token';
      const gatewayPaymentId = 'DF-2159885';

      when(mockClient.get(
        Uri.parse('https://apifitnflai.com/payments/estado-transaccion?gateway_payment_id=$gatewayPaymentId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      )).thenAnswer((_) async => http.Response('{"detail": "Not found"}', 404));

      final result = await paymentsService.getEstadoTransaccion(token, gatewayPaymentId);

      expect(result['estado'], 'pendiente');
      expect(result['gateway_payment_id'], gatewayPaymentId);
    });
  });
}
