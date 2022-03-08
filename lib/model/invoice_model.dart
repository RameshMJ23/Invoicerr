
import 'package:hive/hive.dart';
import 'package:invoicerr/model/additional_cost_model.dart';
import 'package:invoicerr/model/client_details.dart';
import 'package:invoicerr/model/item_model.dart';

import 'delivery_address_model.dart';

@HiveType(typeId: 2)
class InvoiceModel{

  //add net tax
  @HiveField(8)
  String invoiceNumber;

  @HiveField(9)
  DateTime date;

  @HiveField(10)
  ClientDetails? clientDetail;

  @HiveField(12)
  double? totalDiscount;

  @HiveField(13)
  List<ItemModel> items;

  @HiveField(31)
  bool paid;

  @HiveField(32)
  List<AdditionalCost> additionalCost;

  @HiveField(33)
  String? notes;

  @HiveField(34)
  DeliveryAddress? deliveryAddress;

  @HiveField(35)
  double? tax;

  InvoiceModel({
    this.clientDetail,
    required this.date,
    required this.invoiceNumber,
    this.totalDiscount,
    required this.items,
    this.paid = false,
    this.additionalCost = const [],
    this.notes,
    this.deliveryAddress,
    this.tax
  });

}

