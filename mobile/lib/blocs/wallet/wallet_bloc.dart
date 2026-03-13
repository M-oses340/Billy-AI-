import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/wallet_repository.dart';
import 'wallet_event.dart';
import 'wallet_state.dart';

class WalletBloc extends Bloc<WalletEvent, WalletState> {
  final WalletRepository repository;

  WalletBloc(this.repository) : super(WalletDisconnected()) {
    on<ConnectWallet>(_onConnectWallet);
    on<DisconnectWallet>(_onDisconnectWallet);
    on<LoadWalletBalance>(_onLoadWalletBalance);
    on<DepositToWallet>(_onDepositToWallet);
    on<WithdrawFromWallet>(_onWithdrawFromWallet);
  }

  Future<void> _onConnectWallet(ConnectWallet event, Emitter<WalletState> emit) async {
    emit(WalletConnecting());
    try {
      final address = await repository.connectWallet();
      final balances = await repository.getBalances(address);
      emit(WalletConnected(address: address, balances: balances));
    } catch (e) {
      emit(WalletError(e.toString()));
    }
  }

  Future<void> _onDisconnectWallet(DisconnectWallet event, Emitter<WalletState> emit) async {
    await repository.disconnectWallet();
    emit(WalletDisconnected());
  }

  Future<void> _onLoadWalletBalance(LoadWalletBalance event, Emitter<WalletState> emit) async {
    if (state is WalletConnected) {
      final currentState = state as WalletConnected;
      try {
        final balances = await repository.getBalances(currentState.address);
        emit(WalletConnected(address: currentState.address, balances: balances));
      } catch (e) {
        emit(WalletError(e.toString()));
      }
    }
  }

  Future<void> _onDepositToWallet(DepositToWallet event, Emitter<WalletState> emit) async {
    if (state is WalletConnected) {
      final currentState = state as WalletConnected;
      emit(WalletTransactionProcessing());
      try {
        await repository.deposit(event.token, event.amount);
        emit(const WalletTransactionSuccess('Deposit successful'));
        final balances = await repository.getBalances(currentState.address);
        emit(WalletConnected(address: currentState.address, balances: balances));
      } catch (e) {
        emit(WalletError(e.toString()));
      }
    }
  }

  Future<void> _onWithdrawFromWallet(WithdrawFromWallet event, Emitter<WalletState> emit) async {
    if (state is WalletConnected) {
      final currentState = state as WalletConnected;
      emit(WalletTransactionProcessing());
      try {
        await repository.withdraw(event.token, event.amount);
        emit(const WalletTransactionSuccess('Withdrawal successful'));
        final balances = await repository.getBalances(currentState.address);
        emit(WalletConnected(address: currentState.address, balances: balances));
      } catch (e) {
        emit(WalletError(e.toString()));
      }
    }
  }
}
