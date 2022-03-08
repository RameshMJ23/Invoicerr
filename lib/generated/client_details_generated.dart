// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************
import 'package:invoicerr/model/client_details.dart';
import 'package:hive_flutter/adapters.dart';

class ClientDetailsAdapter extends TypeAdapter<ClientDetails> {
  @override
  final int typeId = 5;

  @override
  ClientDetails read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClientDetails(
      clientName: fields[50] as String,
      clientNum: fields[51] as String,
      companyAddress1: fields[53] as String,
      companyAddress2: fields[54] as String,
      companyAddress3: fields[55] as String,
      companyName: fields[52] as String,
    );
  }

  @override
  void write(BinaryWriter writer, ClientDetails obj) {
    writer
      ..writeByte(6)
      ..writeByte(50)
      ..write(obj.clientName)
      ..writeByte(51)
      ..write(obj.clientNum)
      ..writeByte(52)
      ..write(obj.companyName)
      ..writeByte(53)
      ..write(obj.companyAddress1)
      ..writeByte(54)
      ..write(obj.companyAddress2)
      ..writeByte(55)
      ..write(obj.companyAddress3);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is ClientDetailsAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}