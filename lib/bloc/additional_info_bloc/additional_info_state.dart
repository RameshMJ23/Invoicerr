
import 'package:equatable/equatable.dart';
import 'package:invoicerr/model/client_details.dart';
import 'package:invoicerr/model/delivery_address_model.dart';

class AdditionalInfoState extends Equatable{

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class InitAdditionalInfo extends AdditionalInfoState{

}

class AddedAdditionalInfo extends AdditionalInfoState{

  ClientDetails? clientDetails;
  DeliveryAddress? deliveryAddress;
  String? additionalNotes;
  bool paid;

  AddedAdditionalInfo({
    this.clientDetails,
    this.deliveryAddress,
    this.additionalNotes,
    this.paid = false
  });

  @override
  // TODO: implement props
  List<Object?> get props => [clientDetails, deliveryAddress, additionalNotes, paid];
}