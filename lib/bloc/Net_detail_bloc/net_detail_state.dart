
import 'package:equatable/equatable.dart';

class NetTaxDiscountState extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class NilTaxDiscount extends NetTaxDiscountState{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class AddedTaxDiscount extends NetTaxDiscountState{
  late double? tax;
  late double? discount;

  AddedTaxDiscount({
    required this.tax,
    required this.discount
  });

  @override
  // TODO: implement props
  List<Object?> get props => [tax, discount];
}

