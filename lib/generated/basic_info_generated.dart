// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

import 'package:hive/hive.dart';
import 'package:invoicerr/model/basic_info.dart';

class BasicInfoModelAdapter extends TypeAdapter<BasicInfoModel> {
  @override
  final int typeId = 1;

  @override
  BasicInfoModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return BasicInfoModel(
      name: fields[1] as String,
      email: fields[7] as String,
      companyName: fields[2] as String,
      addressL1: fields[3] as String,
      addressL2: fields[4] as String,
      addressL3: fields[5] as String,
      contactNo: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, BasicInfoModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.companyName)
      ..writeByte(3)
      ..write(obj.addressL1)
      ..writeByte(4)
      ..write(obj.addressL2)
      ..writeByte(5)
      ..write(obj.addressL3)
      ..writeByte(6)
      ..write(obj.contactNo)
      ..writeByte(7)
      ..write(obj.email);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is BasicInfoModelAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}