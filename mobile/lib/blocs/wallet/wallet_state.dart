import 'package:equatable/equatable.dart';
import '../../models/wallet.dart';

abstract class WalletState extends Equatable {
  const WalletState();

  @override
  List<Object?> get props => [];
}

class WalletDisconnected extends WalletState {}

class WalletConnecting extends WalletState {}

class WalletConnected extends WalletState {
  final String address;
  final List<WalletBalance> balances;

  const WalletConnected({required this.address, required this.balances});

  @override
  List<Object?> get props => [address, balances];
}

class WalletTransactionProcessing extends WalletState {}

class WalletTransactionSuccess extends WalletState {
  final String message;

  const WalletTransactionSuccess(this.message);

  @override
  List<Object?> get props => [message];
}

class WalletError extends WalletState {
  final String message;

  const WalletError(this.message);

  @override
  List<Object?> get props => [message];
}
