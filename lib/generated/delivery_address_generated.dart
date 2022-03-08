// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

import 'package:invoicerr/model/delivery_address_model.dart';
import 'package:hive_flutter/adapters.dart';


class DeliveryAddressAdapter extends TypeAdapter<DeliveryAddress> {
  @override
  final int typeId = 6;

  @override
  DeliveryAddress read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DeliveryAddress(
      receiverName: fields[60] as String,
      receiverNum: fields[61] as String,
      receiverAddress1: fields[62] as String,
      receiverAddress2: fields[63] as String,
      receiverAddress3: fields[64] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DeliveryAddress obj) {
    writer
      ..writeByte(5)
      ..writeByte(60)
      ..write(obj.receiverName)
      ..writeByte(61)
      ..write(obj.receiverNum)
      ..writeByte(62)
      ..write(obj.receiverAddress1)
      ..writeByte(63)
      ..write(obj.receiverAddress2)
      ..writeByte(64)
      ..write(obj.receiverAddress3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is DeliveryAddressAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}