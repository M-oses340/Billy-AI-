import '../models/payment.dart';
import '../services/api_service.dart';
import '../services/web3_service.dart';

class PaymentRepository {
  final ApiService apiService;
  final Web3Service web3Service;

  PaymentRepository(this.apiService, this.web3Service);

  Future<String> initiatePayment(String billId, double amount, String token) async {
    final response = await apiService.post('/payments/initiate', {
      'billId': billId,
      'amount': amount,
      'token': token,
    });
    return response['transactionHash'];
  }

  Future<List<Payment>> getPaymentHistory() async {
    final response = await apiService.get('/payments/history');
    return (response['payments'] as List).map((json) => Payment.fromJson(json)).toList();
  }
}
