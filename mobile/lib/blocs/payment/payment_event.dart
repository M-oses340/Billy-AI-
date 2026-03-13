import 'package:equatable/equatable.dart';

abstract class PaymentEvent extends Equatable {
  const PaymentEvent();

  @override
  List<Object?> get props => [];
}

class InitiatePayment extends PaymentEvent {
  final String billId;
  final double amount;
  final String token;

  const InitiatePayment({
    required this.billId,
    required this.amount,
    required this.token,
  });

  @override
  List<Object?> get props => [billId, amount, token];
}

class LoadPaymentHistory extends PaymentEvent {}
