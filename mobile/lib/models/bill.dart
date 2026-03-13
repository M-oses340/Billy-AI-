import 'package:equatable/equatable.dart';

class Bill extends Equatable {
  final String id;
  final String payee;
  final double amount;
  final String currency;
  final DateTime dueDate;
  final bool isPaid;
  final String? category;

  const Bill({
    required this.id,
    required this.payee,
    required this.amount,
    required this.currency,
    required this.dueDate,
    this.isPaid = false,
    this.category,
  });

  factory Bill.fromJson(Map<String, dynamic> json) {
    return Bill(
      id: json['id'],
      payee: json['payee'],
      amount: json['amount'].toDouble(),
      currency: json['currency'],
      dueDate: DateTime.parse(json['dueDate']),
      isPaid: json['isPaid'] ?? false,
      category: json['category'],
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
    };
  }

  @override
  List<Object?> get props => [id, payee, amount, currency, dueDate, isPaid, category];
}
