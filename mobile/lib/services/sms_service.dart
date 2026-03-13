import 'package:telephony/telephony.dart';
import 'api_service.dart';

class SmsService {
  final Telephony telephony = Telephony.instance;
  final ApiService apiService;
  final List<String> trustedNumbers;

  SmsService(this.apiService, this.trustedNumbers);

  Future<void> startListening() async {
    final bool? permissionsGranted = await telephony.requestPhoneAndSmsPermissions;

    if (permissionsGranted == true) {
      telephony.listenIncomingSms(
        onNewMessage: _handleIncomingSms,
        listenInBackground: true,
      );
    }
  }

  Future<void> _handleIncomingSms(SmsMessage message) async {
    final from = message.address ?? '';
    final body = message.body ?? '';

    // Check if from trusted biller
    if (_isTrustedNumber(from)) {
      await _processBillSms(from, body);
    }
  }

  bool _isTrustedNumber(String number) {
    return trustedNumbers.any((trusted) => number.contains(trusted));
  }

  Future<void> _processBillSms(String from, String message) async {
    try {
      final response = await apiService.post('/sms/process', {
        'from': from,
        'message': message,
        'userAddress': '0x...', // Get from wallet
        'timestamp': DateTime.now().toIso8601String(),
      });

      // Handle response and show notification
      _handleSmsResponse(response);
    } catch (e) {
      print('Error processing SMS: $e');
    }
  }

  void _handleSmsResponse(Map<String, dynamic> response) {
    final status = response['status'];

    switch (status) {
      case 'paid':
        // Show success notification
        break;
      case 'insufficient_balance':
        // Show low balance notification
        break;
      case 'review_required':
        // Show review notification
        break;
    }
  }
}
