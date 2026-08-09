// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ordinance_hive_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class OrdinanceHiveModelAdapter extends TypeAdapter<OrdinanceHiveModel> {
  @override
  final int typeId = 0;

  @override
  OrdinanceHiveModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return OrdinanceHiveModel(
      ordinanceId: fields[0] as int,
      ordinanceNo: fields[1] as String,
      ordinanceCode: fields[2] as String,
      title: fields[3] as String,
      description: fields[4] as String,
      category: fields[5] as String,
      createdAt: fields[6] as DateTime,
      severity: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, OrdinanceHiveModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.ordinanceId)
      ..writeByte(1)
      ..write(obj.ordinanceNo)
      ..writeByte(2)
      ..write(obj.ordinanceCode)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.category)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.severity);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrdinanceHiveModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
