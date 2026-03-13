import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repositories/bill_repository.dart';
import 'bill_event.dart';
import 'bill_state.dart';

class BillBloc extends Bloc<BillEvent, BillState> {
  final BillRepository repository;

  BillBloc(this.repository) : super(BillInitial()) {
    on<LoadBills>(_onLoadBills);
    on<AddBill>(_onAddBill);
    on<UpdateBill>(_onUpdateBill);
    on<DeleteBill>(_onDeleteBill);
    on<ParseBillFromImage>(_onParseBillFromImage);
  }

  Future<void> _onLoadBills(LoadBills event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      final bills = await repository.getBills();
      emit(BillLoaded(bills));
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }

  Future<void> _onAddBill(AddBill event, Emitter<BillState> emit) async {
    try {
      await repository.addBill(event.bill);
      add(LoadBills());
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }

  Future<void> _onUpdateBill(UpdateBill event, Emitter<BillState> emit) async {
    try {
      await repository.updateBill(event.bill);
      add(LoadBills());
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }

  Future<void> _onDeleteBill(DeleteBill event, Emitter<BillState> emit) async {
    try {
      await repository.deleteBill(event.billId);
      add(LoadBills());
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }

  Future<void> _onParseBillFromImage(ParseBillFromImage event, Emitter<BillState> emit) async {
    emit(BillLoading());
    try {
      final bill = await repository.parseBillFromImage(event.imagePath);
      await repository.addBill(bill);
      add(LoadBills());
    } catch (e) {
      emit(BillError(e.toString()));
    }
  }
}
