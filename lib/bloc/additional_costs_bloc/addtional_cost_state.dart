

import 'package:equatable/equatable.dart';
import 'package:invoicerr/model/additional_cost_model.dart';

class AdditionalCostState extends Equatable{
  @override
  // TODO: implement props
  List<Object?> get props => [this];

}

class EmptyListState extends AdditionalCostState{

}

class InitAdditionalCostState extends AdditionalCostState{

  List<AdditionalCost> additionalCost;

  InitAdditionalCostState({required this.additionalCost});

  @override
  List<Object?> get props => [additionalCost];
}

class AddedAdditionalCost extends AdditionalCostState{

  List<AdditionalCost> additionalCostList;

  AddedAdditionalCost({required this.additionalCostList});

  @override
  List<Object?> get props => [additionalCostList];

}