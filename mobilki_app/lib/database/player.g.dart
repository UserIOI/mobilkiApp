// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PlayerAdapter extends TypeAdapter<Player> {
  @override
  final int typeId = 1;

  @override
  Player read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Player()
      ..name = fields[0] as String
      ..skillList = (fields[1] as List).cast<String>()
      ..noteListTitle = (fields[2] as List).cast<String>()
      ..noteListContent = (fields[3] as List).cast<String>()
      ..investigatorImagePath = fields[4] as String?
      ..investigatorAboutData = (fields[5] as Map).cast<String, String?>()
      ..characteristic = (fields[6] as List).cast<String>()
      ..characteristicLevel = (fields[7] as List).cast<int>()
      ..characterWealth = (fields[8] as List).cast<dynamic>()
      ..weapons = (fields[9] as List).cast<String>()
      ..backpackItems = (fields[10] as List).cast<String>()
      ..assets = (fields[11] as List).cast<String>();
  }

  @override
  void write(BinaryWriter writer, Player obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.skillList)
      ..writeByte(2)
      ..write(obj.noteListTitle)
      ..writeByte(3)
      ..write(obj.noteListContent)
      ..writeByte(4)
      ..write(obj.investigatorImagePath)
      ..writeByte(5)
      ..write(obj.investigatorAboutData)
      ..writeByte(6)
      ..write(obj.characteristic)
      ..writeByte(7)
      ..write(obj.characteristicLevel)
      ..writeByte(8)
      ..write(obj.characterWealth)
      ..writeByte(9)
      ..write(obj.weapons)
      ..writeByte(10)
      ..write(obj.backpackItems)
      ..writeByte(11)
      ..write(obj.assets);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PlayerAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
