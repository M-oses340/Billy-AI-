import 'package:equatable/equatable.dart';
import '../../models/bill.dart';

abstract class BillEvent extends Equatable {
  const BillEvent();

  @override
  List<Object?> get props => [];
}

class LoadBills extends BillEvent {}

class AddBill extends BillEvent {
  final Bill bill;

  const AddBill(this.bill);

  @override
  List<Object?> get props => [bill];
}

class UpdateBill extends BillEvent {
  final Bill bill;

  const UpdateBill(this.bill);

  @override
  List<Object?> get props => [bill];
}

class DeleteBill extends BillEvent {
  final String billId;

  const DeleteBill(this.billId);

  @override
  List<Object?> get props => [billId];
}

class ParseBillFromImage extends BillEvent {
  final String imagePath;

  const ParseBillFromImage(this.imagePath);

  @override
  List<Object?> get props => [imagePath];
}
