// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'athlete.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AthleteAdapter extends TypeAdapter<Athlete> {
  @override
  final int typeId = 0;

  @override
  Athlete read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Athlete(
      rowId: fields[0] as int,
      name: fields[1] as String,
      email: fields[2] as String,
      password: fields[3] as String,
      gender: fields[4] as String,
      birthdate: fields[5] as String,
      city: fields[6] as int,
      club: fields[7] as int,
      company: fields[8] as int,
      stravaAthleteId: fields[9] as String,
      accessToken: fields[10] as String,
      expiresAt: fields[11] as String,
      refreshToken: fields[12] as String,
      clientId: fields[13] as int,
      clientSecret: fields[14] as String,
      remoteUpdate: fields[15] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Athlete obj) {
    writer
      ..writeByte(16)
      ..writeByte(0)
      ..write(obj.rowId)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.email)
      ..writeByte(3)
      ..write(obj.password)
      ..writeByte(4)
      ..write(obj.gender)
      ..writeByte(5)
      ..write(obj.birthdate)
      ..writeByte(6)
      ..write(obj.city)
      ..writeByte(7)
      ..write(obj.club)
      ..writeByte(8)
      ..write(obj.company)
      ..writeByte(9)
      ..write(obj.stravaAthleteId)
      ..writeByte(10)
      ..write(obj.accessToken)
      ..writeByte(11)
      ..write(obj.expiresAt)
      ..writeByte(12)
      ..write(obj.refreshToken)
      ..writeByte(13)
      ..write(obj.clientId)
      ..writeByte(14)
      ..write(obj.clientSecret)
      ..writeByte(15)
      ..write(obj.remoteUpdate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AthleteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
