// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

import 'package:hive/hive.dart';
import 'package:invoicerr/model/item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 3;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      itemName: fields[14] as String,
      costPerUnit: fields[15] as double,
      tax: fields[16] as double,
      totalAmount: fields[17] as double,
      notes: fields[18] as String?,
      discount: fields[20] as double?,
      numberOfItems: fields[19] as double,
    );
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(14)
      ..write(obj.itemName)
      ..writeByte(15)
      ..write(obj.costPerUnit)
      ..writeByte(16)
      ..write(obj.tax)
      ..writeByte(17)
      ..write(obj.totalAmount)
      ..writeByte(18)
      ..write(obj.notes)
      ..writeByte(19)
      ..write(obj.numberOfItems)
      ..writeByte(20)
      ..write(obj.discount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ItemModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}