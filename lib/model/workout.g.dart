// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'workout.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class WorkoutAdapter extends TypeAdapter<Workout> {
  @override
  final int typeId = 1;

  @override
  Workout read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Workout(
      row_id: fields[0] as int,
      workout_date: fields[1] as DateTime,
      athlete_id: fields[2] as int,
      distance: fields[3] as double,
      activity_type: fields[4] as String,
      duration_hh: fields[5] as int,
      duration_mm: fields[6] as int,
      duration_ss: fields[7] as int,
      link: fields[8] as String,
      remote_update: fields[9] as int,
    );
  }

  @override
  void write(BinaryWriter writer, Workout obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.row_id)
      ..writeByte(1)
      ..write(obj.workout_date)
      ..writeByte(2)
      ..write(obj.athlete_id)
      ..writeByte(3)
      ..write(obj.distance)
      ..writeByte(4)
      ..write(obj.activity_type)
      ..writeByte(5)
      ..write(obj.duration_hh)
      ..writeByte(6)
      ..write(obj.duration_mm)
      ..writeByte(7)
      ..write(obj.duration_ss)
      ..writeByte(8)
      ..write(obj.link)
      ..writeByte(9)
      ..write(obj.remote_update);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is WorkoutAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
