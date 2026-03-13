import '../models/bill.dart';
import '../services/api_service.dart';

class BillRepository {
  final ApiService apiService;

  BillRepository(this.apiService);

  Future<List<Bill>> getBills() async {
    final response = await apiService.get('/bills');
    return (response['bills'] as List).map((json) => Bill.fromJson(json)).toList();
  }

  Future<void> addBill(Bill bill) async {
    await apiService.post('/bills', bill.toJson());
  }

  Future<void> updateBill(Bill bill) async {
    await apiService.put('/bills/${bill.id}', bill.toJson());
  }

  Future<void> deleteBill(String billId) async {
    await apiService.delete('/bills/$billId');
  }

  Future<Bill> parseBillFromImage(String imagePath) async {
    final response = await apiService.post('/bills/parse', {'imagePath': imagePath});
    return Bill.fromJson(response);
  }
}
