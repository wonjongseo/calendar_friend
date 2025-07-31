// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'custom_event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CustomEventAdapter extends TypeAdapter<CustomEvent> {
  @override
  final int typeId = 0;

  @override
  CustomEvent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CustomEvent(
      id: fields[0] as String?,
      status: fields[1] as String?,
      htmlLink: fields[2] as String?,
      created: fields[3] as String?,
      updated: fields[4] as String?,
      summary: fields[5] as String?,
      description: fields[6] as String?,
      location: fields[7] as String?,
      startTime: fields[8] as DateTime?,
      endTime: fields[9] as DateTime?,
      allDay: fields[10] as bool?,
      timeZone: fields[11] as String?,
      recurrence: (fields[12] as List?)?.cast<String>(),
      recurringEventId: fields[13] as String?,
      recurring: fields[14] as bool?,
      attendeeEmails: (fields[15] as List?)?.cast<String>(),
      anyoneCanAddSelf: fields[16] as bool?,
      guestsCanModify: fields[17] as bool?,
      guestsCanInviteOthers: fields[18] as bool?,
      guestsCanSeeOtherGuests: fields[19] as bool?,
      colorId: fields[20] as String?,
      visibility: fields[21] as String?,
      transparency: fields[22] as String?,
      organizerEmail: fields[23] as String?,
      isSyncedWithGoogle: fields[24] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CustomEvent obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.status)
      ..writeByte(2)
      ..write(obj.htmlLink)
      ..writeByte(3)
      ..write(obj.created)
      ..writeByte(4)
      ..write(obj.updated)
      ..writeByte(5)
      ..write(obj.summary)
      ..writeByte(6)
      ..write(obj.description)
      ..writeByte(7)
      ..write(obj.location)
      ..writeByte(8)
      ..write(obj.startTime)
      ..writeByte(9)
      ..write(obj.endTime)
      ..writeByte(10)
      ..write(obj.allDay)
      ..writeByte(11)
      ..write(obj.timeZone)
      ..writeByte(12)
      ..write(obj.recurrence)
      ..writeByte(13)
      ..write(obj.recurringEventId)
      ..writeByte(14)
      ..write(obj.recurring)
      ..writeByte(15)
      ..write(obj.attendeeEmails)
      ..writeByte(16)
      ..write(obj.anyoneCanAddSelf)
      ..writeByte(17)
      ..write(obj.guestsCanModify)
      ..writeByte(18)
      ..write(obj.guestsCanInviteOthers)
      ..writeByte(19)
      ..write(obj.guestsCanSeeOtherGuests)
      ..writeByte(20)
      ..write(obj.colorId)
      ..writeByte(21)
      ..write(obj.visibility)
      ..writeByte(22)
      ..write(obj.transparency)
      ..writeByte(23)
      ..write(obj.organizerEmail)
      ..writeByte(24)
      ..write(obj.isSyncedWithGoogle);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CustomEventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
