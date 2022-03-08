
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicerr/bloc/Net_detail_bloc/net_detail_state.dart';

class NetDetailCubit extends Cubit<NetTaxDiscountState>{

  NetDetailCubit():super(NilTaxDiscount());

  addTax(double tax, NetTaxDiscountState state){
    if(state is AddedTaxDiscount){
      final discount = state.discount;

      emit(AddedTaxDiscount(tax: tax, discount: discount));
    }else{
      emit(AddedTaxDiscount(tax: tax, discount: null));
    }
  }

  addDiscount(double discount, NetTaxDiscountState state){
    if(state is AddedTaxDiscount){
      final tax = state.tax;

      emit(AddedTaxDiscount(tax: tax, discount: discount));
    }else{
      emit(AddedTaxDiscount(tax: null, discount: discount));
    }
  }

  removeAll(){
    emit(NilTaxDiscount());
  }

  updateInvoice(double? discount, double? tax){
    emit(AddedTaxDiscount(tax: tax, discount: discount));
  }
}