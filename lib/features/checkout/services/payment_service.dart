import 'dart:convert';
import 'dart:math';
import 'package:http/http.dart' as http;

/// You can provide a real mock API endpoint when running the app:
/// flutter run --dart-define=CHECKOUT_ENDPOINT=https://your.mock/endpoint
const String kCheckoutEndpoint =
    String.fromEnvironment('CHECKOUT_ENDPOINT', defaultValue: '');

/// Model for payment result
class PaymentResult {
  final bool success;
  final String message;
  final String? id;

  PaymentResult({
    required this.success,
    required this.message,
    this.id,
  });
}

class PaymentService {
  /// Simulates a checkout API request
  static Future<PaymentResult> checkout({
    required String planId,
    required double amount,
    String? promo,
  }) async {
    // ✅ Local mock fallback (if no endpoint is provided)
    if (kCheckoutEndpoint.isEmpty) {
      await Future.delayed(const Duration(seconds: 2));

      final ok = amount == 0 || Random().nextDouble() < 0.85;
      return PaymentResult(
        success: ok,
        message: ok ? 'Mock payment successful' : 'Mock payment failed',
        id: ok ? 'pi_mock_${Random().nextInt(999999)}' : null,
      );
    }

    // ✅ Real API call (if endpoint is provided)
    try {
      final res = await http
          .post(
            Uri.parse(kCheckoutEndpoint),
            headers: {'Content-Type': 'application/json'},
            body: jsonEncode({
              'plan': planId,
              'amount': amount,
              'currency': 'USD',
              'promo': promo,
            }),
          )
          .timeout(const Duration(seconds: 6));

      if (res.statusCode >= 200 && res.statusCode < 300) {
        final data = jsonDecode(res.body);

        final status = (data['status'] ?? 'succeeded').toString();
        final ok = status.toLowerCase() == 'succeeded';

        return PaymentResult(
          success: ok,
          message: data['message'] ??
              (ok ? 'Payment succeeded' : 'Payment failed'),
          id: data['id']?.toString(),
        );
      } else {
        return PaymentResult(
          success: false,
          message: 'Server error: ${res.statusCode}',
        );
      }
    } catch (e) {
      return PaymentResult(
        success: false,
        message: 'Network/error: $e',
      );
    }
  }
}
