import 'package:permission_handler/permission_handler.dart';
import 'api_service.dart';

class SmsService {
  final ApiService apiService;
  final List<String> trustedNumbers;

  SmsService(this.apiService, this.trustedNumbers);

  Future<bool> requestSmsPermissions() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  Future<void> startListening() async {
    final permissionsGranted = await requestSmsPermissions();

    if (permissionsGranted) {
      // Note: For actual SMS monitoring, you would need to implement
      // a native Android service using platform channels
      // This is a placeholder showing the structure
      print('SMS monitoring started');
      print('Trusted numbers: $trustedNumbers');
    } else {
      throw Exception('SMS permissions not granted');
    }
  }

  bool _isTrustedNumber(String number) {
    return trustedNumbers.any((trusted) => number.contains(trusted));
  }

  // Manual SMS processing for testing
  Future<Map<String, dynamic>> processSmsManually({
    required String from,
    required String message,
    required String userAddress,
    required String userId,
  }) async {
    if (!_isTrustedNumber(from)) {
      throw Exception('Number not in trusted list');
    }

    try {
      final response = await apiService.post('/sms/process', {
        'from': from,
        'message': message,
        'userAddress': userAddress,
        'userId': userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _handleSmsResponse(response);
      return response;
    } catch (e) {
      print('Error processing SMS: $e');
      rethrow;
    }
  }

  void _handleSmsResponse(Map<String, dynamic> response) {
    final status = response['status'];

    switch (status) {
      case 'paid':
        print('✅ Bill paid successfully');
        break;
      case 'insufficient_balance':
        print('⚠️ Insufficient balance');
        break;
      case 'review_required':
        print('📋 Review required');
        break;
    }
  }
}
