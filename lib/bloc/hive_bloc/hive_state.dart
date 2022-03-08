import 'package:equatable/equatable.dart';
import 'package:invoicerr/enums/bloc_enums.dart';
import 'package:invoicerr/model/invoice_model.dart';
import 'package:invoicerr/model/item_model.dart';

class HiveState extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NoHiveState extends HiveState{

}


class HiveDataState extends HiveState{
  List<InvoiceModel> invoiceList;
  PaidFilter paidFilter;
  Sort sortFilter;

  HiveDataState(this.invoiceList,this.paidFilter, this.sortFilter);

  @override
  // TODO: implement props
  List<Object?> get props => [invoiceList, paidFilter, sortFilter];
}

