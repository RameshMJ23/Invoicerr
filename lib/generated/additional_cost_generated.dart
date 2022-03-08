// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************
import 'package:hive/hive.dart';
import 'package:invoicerr/model/additional_cost_model.dart';


class AdditionalCostAdapter extends TypeAdapter<AdditionalCost> {
  @override
  final int typeId = 4;

  @override
  AdditionalCost read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AdditionalCost(
      cost: fields[42] as double,
      costName: fields[41] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AdditionalCost obj) {
    writer
      ..writeByte(2)
      ..writeByte(41)
      ..write(obj.costName)
      ..writeByte(42)
      ..write(obj.cost);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
          other is AdditionalCostAdapter &&
              runtimeType == other.runtimeType &&
              typeId == other.typeId;
}