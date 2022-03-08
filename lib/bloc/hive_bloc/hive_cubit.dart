

import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:invoicerr/bloc/hive_bloc/hive_state.dart';
import 'package:invoicerr/enums/bloc_enums.dart';
import 'package:invoicerr/model/additional_cost_model.dart';
import 'package:invoicerr/model/client_details.dart';
import 'package:invoicerr/model/delivery_address_model.dart';
import 'package:invoicerr/model/invoice_model.dart';
import 'package:invoicerr/model/item_model.dart';

class HiveCubit extends Cubit<HiveState>{

  HiveCubit():super(NoHiveState());

  getHive() async{
    bool boxExists = await Hive.boxExists('invoicebox');

    if(boxExists){
      List<InvoiceModel> invoiceList = Hive.box<InvoiceModel>('invoicebox').values.toList();

      invoiceList.sort((a, b) => a.date.compareTo(b.date));

      emit(HiveDataState(invoiceList, PaidFilter.all, Sort.ascending));
    }else{
      emit(NoHiveState());
    }
  }

  addData(InvoiceModel invoiceModel){

    Box<InvoiceModel> invoiceBox = Hive.box('invoicebox');

    invoiceBox.put(
      getKey(),
      invoiceModel
    );

    emit(HiveDataState(invoiceBox.values.toList(), PaidFilter.all, Sort.ascending));
  }

  deleteItem(InvoiceModel model, int index, ItemModel item){

    Box<InvoiceModel> invoiceBox = Hive.box('invoicebox');

    InvoiceModel invoiceModel = invoiceBox.get(model.invoiceNumber)!;

    if(invoiceModel.items.contains(item)){
      invoiceModel.items.removeAt(index);

      invoiceBox.put(model.invoiceNumber, invoiceModel);
    }

    emit(HiveDataState(invoiceBox.values.toList(), PaidFilter.all, Sort.ascending));
  }

  updateInvoiceModel({
    required InvoiceModel model,
    List<ItemModel>? items,
    double? netTax,
    List<AdditionalCost>? additionalCost,
    bool? paid,
    ClientDetails? clientDetails,
    DeliveryAddress? deliveryAddress,
    String? additionalNote,
    double? totalDiscount,
    DateTime? date,
    String? invoiceNumber,
  }){

    Box<InvoiceModel> invoiceBox = Hive.box('invoicebox');


    InvoiceModel updatedInvoice = model;

    updatedInvoice.items = items ?? model.items;
    updatedInvoice.tax = netTax ?? model.tax;
    updatedInvoice.additionalCost = additionalCost ?? model.additionalCost;
    updatedInvoice.paid = paid ?? model.paid;
    updatedInvoice.clientDetail = clientDetails ?? model.clientDetail;
    updatedInvoice.deliveryAddress = deliveryAddress ?? model.deliveryAddress;
    updatedInvoice.notes = additionalNote ?? model.notes;
    updatedInvoice.totalDiscount = totalDiscount ?? model.totalDiscount;
    updatedInvoice.date = model.date;
    updatedInvoice.invoiceNumber = model.invoiceNumber;

    invoiceBox.put(updatedInvoice.invoiceNumber, updatedInvoice);
    emit(HiveDataState(invoiceBox.values.toList(), PaidFilter.all, Sort.ascending));
  }

  deleteInvoice(int index){
    Box<InvoiceModel> invoiceBox = Hive.box('invoicebox');

    invoiceBox.deleteAt(index);

    emit(HiveDataState(invoiceBox.values.toList(), PaidFilter.all, Sort.ascending));
  }

  String getKey() {

    Box<InvoiceModel> box = Hive.box('invoicebox');
    int lengthOfBox = box.values.toList().length;
    List<InvoiceModel> list = box.values.toList();

    late String newInvoiceNumber;

    List<String> invoiceNumberList = [];
    list.map((invoice) => invoiceNumberList.add(invoice.invoiceNumber)).toList();

    for(int i = 0; i <= invoiceNumberList.length; i++){
      if(invoiceNumberList.contains("INV_0${lengthOfBox + i}")){
        continue;
      }else{
        newInvoiceNumber = "INV_0${lengthOfBox + i}";
        break;
      }
    }
    return newInvoiceNumber;
  }

  refresh(){

    emit(NoHiveState());
    emit(HiveDataState(Hive.box<InvoiceModel>('invoicebox').values.toList(), PaidFilter.all, Sort.ascending));
  }

  paidFilter(PaidFilter filter, HiveState state){

    late Sort sortFilter;

    if(state is HiveDataState){
      PaidFilter paidFilter = state.paidFilter;
      sortFilter = state.sortFilter;
    }

    List<InvoiceModel> invoiceList = Hive.box<InvoiceModel>('invoicebox').values.toList();
    List<InvoiceModel> filteredList;
    if(filter == PaidFilter.paid){
      filteredList = invoiceList.where((invoice) => invoice.paid == true).toList();

      emit(HiveDataState(filteredList, PaidFilter.paid, sortFilter));
    }else if(filter == PaidFilter.unpaid){
      filteredList = invoiceList.where((invoice) => invoice.paid == false).toList();

      emit(HiveDataState(filteredList, PaidFilter.unpaid, sortFilter));
    }else{
      emit(HiveDataState(invoiceList, PaidFilter.all, sortFilter));
    }
  }

  sortFilter(Sort filter, HiveState state){

    late PaidFilter paidFilter;

    if(state is HiveDataState){
      paidFilter = state.paidFilter;
    }

    List<InvoiceModel> invoiceList = Hive.box<InvoiceModel>('invoicebox').values.toList();
    List<InvoiceModel> filteredList;
    if(filter == Sort.ascending){
      filteredList = invoiceList;

      emit(HiveDataState(filteredList, paidFilter, Sort.ascending));
    }else if(filter == Sort.descending){
      filteredList = invoiceList.reversed.toList();

      emit(HiveDataState(filteredList, paidFilter, Sort.descending));
    }
  }


}