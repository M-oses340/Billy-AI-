import 'package:equatable/equatable.dart';

class Payment extends Equatable {
  final String id;
  final String billId;
  final double amount;
  final String token;
  final String transactionHash;
  final DateTime timestamp;
  final PaymentStatus status;

  const Payment({
    required this.id,
    required this.billId,
    required this.amount,
    required this.token,
    required this.transactionHash,
    required this.timestamp,
    required this.status,
  });

  factory Payment.fromJson(Map<String, dynamic> json) {
    return Payment(
      id: json['id'],
      billId: json['billId'],
      amount: json['amount'].toDouble(),
      token: json['token'],
      transactionHash: json['transactionHash'],
      timestamp: DateTime.parse(json['timestamp']),
      status: PaymentStatus.values.byName(json['status']),
    );
  }

  @override
  List<Object?> get props => [id, billId, amount, token, transactionHash, timestamp, status];
}

enum PaymentStatus { pending, confirmed, failed }
