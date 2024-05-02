// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'models.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class GroceryAdapter extends TypeAdapter<Grocery> {
  @override
  final int typeId = 0;

  @override
  Grocery read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Grocery(
      name: fields[0] as String,
      store: fields[1] as String,
      purchased: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Grocery obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.store)
      ..writeByte(2)
      ..write(obj.purchased);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroceryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class GroceryStoreAdapter extends TypeAdapter<GroceryStore> {
  @override
  final int typeId = 1;

  @override
  GroceryStore read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return GroceryStore(
      name: fields[0] as String,
      color: fields[1] as String,
    );
  }

  @override
  void write(BinaryWriter writer, GroceryStore obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is GroceryStoreAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
