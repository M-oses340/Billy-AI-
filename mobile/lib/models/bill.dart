import 'package:equatable/equatable.dart';

class Bill extends Equatable {
  final String id;
  final String payee;
  final double amount;
  final String currency;
  final DateTime dueDate;
  final bool isPaid;
  final String? category;
  final String status; // pending, queued, paid, failed
  final bool isRecurring;
  final String? recurringFrequency; // weekly, monthly, quarterly, yearly

  const Bill({
    required this.id,
    required this.payee,
    required this.amount,
    required this.currency,
    required this.dueDate,
    this.isPaid = false,
    this.category,
    this.status = 'pending',
    this.isRecurring = false,
    this.recurringFrequency,
  });

  // Alias for category
  String? get billType => category;

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['_id'] ?? json['id'],
      payee: json['biller'] ?? json['payee'],
      amount: (json['amount'] is int) ? (json['amount'] as int).toDouble() : json['amount'].toDouble(),
      currency: json['currency'],
      dueDate: DateTime.parse(json['dueDate']),
      isPaid: json['status'] == 'paid' || json['isPaid'] == true,
      category: json['billType'] ?? json['category'],
      status: json['status'] ?? 'pending',
      isRecurring: json['isRecurring'] ?? false,
      recurringFrequency: json['recurringFrequency'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'payee': payee,
      'amount': amount,
      'currency': currency,
      'dueDate': dueDate.toIso8601String(),
      'isPaid': isPaid,
      'category': category,
      'status': status,
      'isRecurring': isRecurring,
      'recurringFrequency': recurringFrequency,
    };
  }

  @override
  List<Object?> get props => [id, payee, amount, currency, dueDate, isPaid, category, status, isRecurring, recurringFrequency];
}
