import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/payment_repository.dart';
import 'payment_event.dart';
import 'payment_state.dart';

class PaymentBloc extends Bloc<PaymentEvent, PaymentState> {
  final PaymentRepository repository;

  PaymentBloc(this.repository) : super(PaymentInitial()) {
    on<InitiatePayment>(_onInitiatePayment);
    on<LoadPaymentHistory>(_onLoadPaymentHistory);
  }

  Future<void> _onInitiatePayment(InitiatePayment event, Emitter<PaymentState> emit) async {
    emit(PaymentProcessing());
    try {
      final txHash = await repository.initiatePayment(
        event.billId,
        event.amount,
        event.token,
      );
      emit(PaymentSuccess(txHash));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }

  Future<void> _onLoadPaymentHistory(LoadPaymentHistory event, Emitter<PaymentState> emit) async {
    try {
      final payments = await repository.getPaymentHistory();
      emit(PaymentHistoryLoaded(payments));
    } catch (e) {
      emit(PaymentError(e.toString()));
    }
  }
}
