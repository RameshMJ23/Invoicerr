// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

import 'package:invoicerr/model/delivery_address_model.dart';
import 'package:invoicerr/model/invoice_model.dart';
import 'package:hive/hive.dart';
import 'package:invoicerr/model/item_model.dart';
import 'package:invoicerr/model/additional_cost_model.dart';
import 'package:invoicerr/model/client_details.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class InvoiceModelAdapter extends TypeAdapter<InvoiceModel> {
  @override
  final int typeId = 2;

  @override
  InvoiceModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return InvoiceModel(
      clientDetail: fields[10] as ClientDetails?,
      date: fields[9] as DateTime,
      invoiceNumber: fields[8] as String,
      totalDiscount: fields[12] as double?,
      items: (fields[13] as List).cast<ItemModel>(),
      paid: fields[31] as bool,
      additionalCost: (fields[32] as List).cast<AdditionalCost>(),
      notes: fields[33] as String?,
      deliveryAddress: fields[34] as DeliveryAddress?,
      tax: fields[35] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, InvoiceModel obj) {
    writer
      ..writeByte(10)
      ..writeByte(8)
      ..write(obj.invoiceNumber)
      ..writeByte(9)
      ..write(obj.date)
      ..writeByte(10)
      ..write(obj.clientDetail)
      ..writeByte(12)
      ..write(obj.totalDiscount)
      ..writeByte(13)
      ..write(obj.items)
      ..writeByte(31)
      ..write(obj.paid)
      ..writeByte(32)
      ..write(obj.additionalCost)
      ..writeByte(33)
      ..write(obj.notes)
      ..writeByte(34)
      ..write(obj.deliveryAddress)
      ..writeByte(35)
      ..write(obj.tax);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is InvoiceModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}