import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'api_service.dart';

class SmsService {
  final ApiService apiService;
  final List<String> trustedNumbers;
  static const platform = MethodChannel('com.example.billy/sms');
  
  String? _userAddress;
  String? _userId;

  SmsService(this.apiService, this.trustedNumbers);

  Future<bool> requestSmsPermissions() async {
    final status = await Permission.sms.request();
    return status.isGranted;
  }

  Future<void> startListening({
    required String userAddress,
    required String userId,
  }) async {
    _userAddress = userAddress;
    _userId = userId;
    
    final permissionsGranted = await requestSmsPermissions();

    if (permissionsGranted) {
      // Set up method call handler for incoming SMS
      platform.setMethodCallHandler(_handleMethodCall);
      print('✅ SMS monitoring started');
      print('📱 Listening for bills from trusted numbers');
      print('🔐 User: $userId');
    } else {
      throw Exception('SMS permissions not granted');
    }
  }

  Future<dynamic> _handleMethodCall(MethodCall call) async {
    if (call.method == 'onSmsReceived') {
      final Map<dynamic, dynamic> args = call.arguments;
      final String sender = args['sender'] ?? '';
      final String message = args['message'] ?? '';
      
      print('📨 SMS received from: $sender');
      
      // Check if sender is trusted
      if (_isTrustedNumber(sender)) {
        print('✅ Trusted sender detected, processing bill...');
        await _processIncomingSms(sender, message);
      } else {
        print('⚠️ Unknown sender, ignoring SMS');
      }
    }
  }

  Future<void> _processIncomingSms(String from, String message) async {
    if (_userAddress == null || _userId == null) {
      print('❌ User not initialized');
      return;
    }

    try {
      print('🤖 Sending to AI for parsing...');
      final response = await apiService.post('/sms/process', {
        'from': from,
        'message': message,
        'userAddress': _userAddress,
        'userId': _userId,
        'timestamp': DateTime.now().toIso8601String(),
      });

      _handleSmsResponse(response);
    } catch (e) {
      print('❌ Error processing SMS: $e');
    }
  }

  bool _isTrustedNumber(String number) {
    // Remove all non-digits for comparison
    final cleanNumber = number.replaceAll(RegExp(r'[^\d]'), '');
    return trustedNumbers.any((trusted) {
      final cleanTrusted = trusted.replaceAll(RegExp(r'[^\d]'), '');
      return cleanNumber.contains(cleanTrusted) || cleanTrusted.contains(cleanNumber);
    });
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
        print('✅ Bill paid automatically!');
        print('💰 Amount: ${response['parsedBill']?['amount']}');
        break;
      case 'insufficient_balance':
        print('⚠️ Insufficient balance - bill queued');
        print('💵 Need: ${response['shortfall']}');
        break;
      case 'review_required':
        print('📋 Low confidence - review required');
        print('🤔 Confidence: ${response['parsedBill']?['confidence']}');
        break;
      default:
        print('📨 SMS processed: $status');
    }
  }
}
