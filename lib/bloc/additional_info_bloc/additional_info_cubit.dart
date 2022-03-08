
import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:invoicerr/bloc/additional_info_bloc/additional_info_state.dart';
import 'package:invoicerr/model/client_details.dart';
import 'package:invoicerr/model/delivery_address_model.dart';
import 'package:invoicerr/model/invoice_model.dart';

class AdditionalInfoCubit extends Cubit<AdditionalInfoState>{

  AdditionalInfoCubit():super(InitAdditionalInfo());

  addNotes(String notes, AdditionalInfoState state, InvoiceModel? model){

    if(state is AddedAdditionalInfo){
      emit(AddedAdditionalInfo(
        additionalNotes: notes,
        deliveryAddress: state.deliveryAddress,
        clientDetails: state.clientDetails,
        paid: model?.paid ?? false
      ));
    }else{
      emit(
        AddedAdditionalInfo(
          additionalNotes: notes,
          deliveryAddress: null,
          clientDetails: null,
          paid: model?.paid ?? false
        )
      );
    }
  }

  addClientDetails(ClientDetails details, AdditionalInfoState state, InvoiceModel? model){
    if(state is AddedAdditionalInfo){
      emit(AddedAdditionalInfo(
          additionalNotes: state.additionalNotes,
          deliveryAddress: state.deliveryAddress,
          clientDetails: details,
          paid: model?.paid ?? false
      ));
    }else{
      emit(
          AddedAdditionalInfo(
              additionalNotes: null,
              deliveryAddress: null,
              clientDetails: details,
              paid: model?.paid ?? false
          )
      );
    }
  }

  addDeliveryAddress(DeliveryAddress address, AdditionalInfoState state, InvoiceModel? model){
    if(state is AddedAdditionalInfo){
      emit(
        AddedAdditionalInfo(
          additionalNotes: state.additionalNotes,
          deliveryAddress: address,
          clientDetails: state.clientDetails,
            paid: model?.paid ?? false
        ));
    }else{
      emit(
          AddedAdditionalInfo(
              additionalNotes: null,
              deliveryAddress: address,
              clientDetails: null,
              paid: model?.paid ?? false
          )
      );
    }
  }

  addPaymentStatus(InvoiceModel model, bool paid){
    emit(
      AddedAdditionalInfo(
        additionalNotes: model.notes,
        deliveryAddress: model.deliveryAddress,
        clientDetails: model.clientDetail,
        paid: paid
      )
    );
  }

  removeAll(){
    emit(InitAdditionalInfo());
  }

  updateInvoice({String? notes, ClientDetails? clientDetails, DeliveryAddress? address, required bool paid}){
    emit(
      AddedAdditionalInfo(
        additionalNotes: notes,
        clientDetails: clientDetails,
        deliveryAddress: address,
        paid: paid
      )
    );
  }
}