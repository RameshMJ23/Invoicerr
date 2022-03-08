
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicerr/bloc/additional_costs_bloc/addtional_cost_state.dart';
import 'package:invoicerr/model/additional_cost_model.dart';

class AdditionalCostCubit extends Cubit<AdditionalCostState>{

  AdditionalCostCubit():super(InitAdditionalCostState(additionalCost: []));

  addCost(AdditionalCost additionalCost, AdditionalCostState state){

    if(state is InitAdditionalCostState){

      final list = state.additionalCost;

      list.add(additionalCost);

      emit(AddedAdditionalCost(additionalCostList: list));
    }

    if(state is AddedAdditionalCost){

      final list = state.additionalCostList;

      list.add(additionalCost);

      emit(InitAdditionalCostState(additionalCost: list));

    }
  }

  deleteCost(AdditionalCostState state, int index){

    if(state is AddedAdditionalCost){

      final list = state.additionalCostList;

      list.removeAt(index);

      emit(InitAdditionalCostState(additionalCost: list));
    }else if(state is InitAdditionalCostState){

      final list = state.additionalCost;

      list.removeAt(index);

      emit(AddedAdditionalCost(additionalCostList: list));
    }
  }

  removeAll(){


    if(state is AddedAdditionalCost){
      emit(InitAdditionalCostState(additionalCost: []));
    }else if(state is InitAdditionalCostState){
      emit(AddedAdditionalCost(additionalCostList: []));
    }
  }

  updateInvoice(List<AdditionalCost> costList){
    emit(AddedAdditionalCost(additionalCostList: costList));
  }
}