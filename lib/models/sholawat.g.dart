// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sholawat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SholawatAdapter extends TypeAdapter<Sholawat> {
  @override
  final int typeId = 0;

  @override
  Sholawat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Sholawat(
      id: fields[0] as int,
      title: fields[1] as String,
      arabic: fields[2] as String,
      latin: fields[3] as String,
      translation: fields[4] as String,
      audio: fields[5] as String,
      category: fields[6] as String,
      url: fields[7] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Sholawat obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.arabic)
      ..writeByte(3)
      ..write(obj.latin)
      ..writeByte(4)
      ..write(obj.translation)
      ..writeByte(5)
      ..write(obj.audio)
      ..writeByte(6)
      ..write(obj.category)
      ..writeByte(7)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SholawatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
