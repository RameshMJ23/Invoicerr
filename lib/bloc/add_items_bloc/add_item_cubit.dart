
import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicerr/bloc/add_items_bloc/add_item_state.dart';
import 'package:invoicerr/model/item_model.dart';

class AddItemCubit extends Cubit<AddItemState>{


  AddItemCubit():super(InitItemState(<ItemModel>[]));

  addItem(ItemModel item, AddItemState state){

    if(state is InitItemState){

      final itemList = state.initItems;
      itemList.add(item);
      emit(ItemAddedState(itemList));

    }else if(state is ItemAddedState){

      List<ItemModel> listOfItems = state.items;

      listOfItems.add(item);
      emit(InitItemState(listOfItems));

    }
  }

  editItem(ItemModel itemModel, int index, AddItemState state){

    if(state is InitItemState){

      final itemList = state.initItems;
      itemList[index] = itemModel;
      emit(ItemAddedState(itemList));

    }else if(state is ItemAddedState){

      final listOfItems = state.items;
      listOfItems[index] = itemModel;
      emit(InitItemState(listOfItems));
    }
  }

  removeItem(int index, AddItemState state){

    if(state is InitItemState){

      final itemList = state.initItems;
      itemList.removeAt(index);
      emit(ItemAddedState(itemList));

    }else if(state is ItemAddedState){

      final listOfItems = state.items;
      listOfItems.removeAt(index);
      emit(InitItemState(listOfItems));
    }
  }

  removeAll(){
    if(state is InitItemState){
      emit(ItemAddedState([]));
    }else{
      emit(InitItemState([]));
    }
  }

  updateCreatedInvoice(List<ItemModel> items){

    if(state is InitItemState){
      emit(ItemAddedState(items));
    }else{
      emit(InitItemState(items));
    }
  }

  @override
  Future<void> close() {
    return super.close();
  }
}