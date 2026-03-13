import 'package:equatable/equatable.dart';

abstract class WalletEvent extends Equatable {
  const WalletEvent();

  @override
  List<Object?> get props => [];
}

class ConnectWallet extends WalletEvent {}

class DisconnectWallet extends WalletEvent {}

class LoadWalletBalance extends WalletEvent {}

class DepositToWallet extends WalletEvent {
  final String token;
  final double amount;

  const DepositToWallet({required this.token, required this.amount});

  @override
  List<Object?> get props => [token, amount];
}

class WithdrawFromWallet extends WalletEvent {
  final String token;
  final double amount;

  const WithdrawFromWallet({required this.token, required this.amount});

  @override
  List<Object?> get props => [token, amount];
}
