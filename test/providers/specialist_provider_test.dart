import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:fitnflaifrontendv2/providers/specialist_provider.dart';
import 'package:fitnflaifrontendv2/services/payments_service.dart';
import 'package:fitnflaifrontendv2/services/specialist_service.dart';
import 'package:flutter/material.dart'; // Required for debugPrint

import 'specialist_provider_test.mocks.dart';

@GenerateMocks([PaymentsService, SpecialistService])
void main() {
  group('SpecialistProvider', () {
    late SpecialistProvider specialistProvider;
    late MockPaymentsService mockPaymentsService;
    late MockSpecialistService mockSpecialistService;

    setUp(() {
      mockPaymentsService = MockPaymentsService();
      mockSpecialistService = MockSpecialistService();
      specialistProvider = SpecialistProvider(mockSpecialistService, paymentsService: mockPaymentsService);
      // Manually inject mockPaymentsService as it's a direct instantiation in SpecialistProvider
      // A more robust DI setup would be better for testability here.
      // For now, we'll assume the _paymentsService is accessible or can be set.
      // If PaymentsService is final, we might need to refactor SpecialistProvider.
      // Assuming for now it's not final or can be set via reflection for test.
      // For a real scenario, constructor injection would be preferred.
      // Since it's private, I'll need to use `noSuchMethod` or a getter in the real class to test effectively.
      // For the purpose of this test, let's assume `PaymentsService` is passed through a constructor
      // or that I can verify the interaction with the mock.
      // Oh, wait. SpecialistProvider(this._specialistService); means PaymentsService is created internally.
      // This is a testability issue. I need to modify SpecialistProvider to accept PaymentsService in its constructor.
      // This is a common architectural refactoring for testability.

      // Let's hold off on creating the test file for now and address the testability issue first.
    });

    test('payMeetingSpecialistOneClick - success path', () async {
      const token = 'test_token';
      const trackingId = 123;

      when(mockPaymentsService.payMeetingSpecialistOneClick(token, trackingId))
          .thenAnswer((_) async => {}); // Return an empty map or object for success

      // Initially, booking status should be idle
      expect(specialistProvider.bookingStatus, BookingStatus.idle);
      expect(specialistProvider.isDirectCharging, false);
      expect(specialistProvider.directChargeErrorMessage, isNull);

      final result = await specialistProvider.payMeetingSpecialistOneClick(token, trackingId);

      // Verify states during and after the call
      expect(specialistProvider.isDirectCharging, false); // Should be false after completion
      expect(specialistProvider.directChargeErrorMessage, isNull);
      expect(specialistProvider.bookingStatus, BookingStatus.success);
      expect(result, true);

      // Verify interaction with PaymentsService
      verify(mockPaymentsService.payMeetingSpecialistOneClick(token, trackingId)).called(1);
      verifyNoMoreInteractions(mockPaymentsService);
    });

    test('payMeetingSpecialistOneClick - error path', () async {
      const token = 'test_token';
      const trackingId = 123;
      const errorMessage = 'Payment failed for some reason';

      when(mockPaymentsService.payMeetingSpecialistOneClick(token, trackingId))
          .thenThrow(Exception(errorMessage));

      // Initially, booking status should be idle
      expect(specialistProvider.bookingStatus, BookingStatus.idle);
      expect(specialistProvider.isDirectCharging, false);
      expect(specialistProvider.directChargeErrorMessage, isNull);

      final result = await specialistProvider.payMeetingSpecialistOneClick(token, trackingId);

      // Verify states during and after the call
      expect(specialistProvider.isDirectCharging, false); // Should be false after completion
      expect(specialistProvider.directChargeErrorMessage, contains(errorMessage));
      expect(specialistProvider.bookingStatus, BookingStatus.error);
      expect(result, false);

      // Verify interaction with PaymentsService
      verify(mockPaymentsService.payMeetingSpecialistOneClick(token, trackingId)).called(1);
      verifyNoMoreInteractions(mockPaymentsService);
    });
  });
}
