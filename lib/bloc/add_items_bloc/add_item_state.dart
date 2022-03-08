
// ignore_for_file: must_be_immutable

import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:invoicerr/model/item_model.dart';

class AddItemState extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];

}

class InitItemState extends AddItemState{
  List<ItemModel> initItems;

  InitItemState(this.initItems);

  @override
  // TODO: implement props
  List<Object?> get props => [initItems];
}

class ItemAddedState extends AddItemState{
  List<ItemModel> items;

  ItemAddedState(this.items);

  @override
  // TODO: implement props
  List<Object?> get props => [items];
}