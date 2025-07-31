import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

part 'custom_event.g.dart'; // build_runner 필요

@HiveType(typeId: 0)
class CustomEvent extends HiveObject {
  static String boxName = "custom-event-box";
  @HiveField(0)
  String? id;

  @HiveField(1)
  String? status;

  @HiveField(2)
  String? htmlLink;

  @HiveField(3)
  String? created;

  @HiveField(4)
  String? updated;

  @HiveField(5)
  String? summary;

  @HiveField(6)
  String? description;

  @HiveField(7)
  String? location;

  @HiveField(8)
  DateTime? startTime;

  @HiveField(9)
  DateTime? endTime;

  @HiveField(10)
  bool? allDay;

  @HiveField(11)
  String? timeZone;

  @HiveField(12)
  List<String>? recurrence;

  @HiveField(13)
  String? recurringEventId;

  @HiveField(14)
  bool? recurring;

  @HiveField(15)
  List<String>? attendeeEmails;

  @HiveField(16)
  bool? anyoneCanAddSelf;

  @HiveField(17)
  bool? guestsCanModify;

  @HiveField(18)
  bool? guestsCanInviteOthers;

  @HiveField(19)
  bool? guestsCanSeeOtherGuests;

  @HiveField(20)
  String? colorId;

  @HiveField(21)
  String? visibility;

  @HiveField(22)
  String? transparency;

  @HiveField(23)
  String? organizerEmail;

  @HiveField(24)
  bool isSyncedWithGoogle; // 로컬 전용 필드

  CustomEvent({
    this.id,
    this.status,
    this.htmlLink,
    this.created,
    this.updated,
    this.summary,
    this.description,
    this.location,
    this.startTime,
    this.endTime,
    this.allDay,
    this.timeZone,
    this.recurrence,
    this.recurringEventId,
    this.recurring,
    this.attendeeEmails,
    this.anyoneCanAddSelf,
    this.guestsCanModify,
    this.guestsCanInviteOthers,
    this.guestsCanSeeOtherGuests,
    this.colorId,
    this.visibility,
    this.transparency,
    this.organizerEmail,
    this.isSyncedWithGoogle = false,
  });

  static CustomEvent fromGoogleEvent(calendar.Event e) {
    return CustomEvent(
      id: e.id,
      status: e.status,
      htmlLink: e.htmlLink,
      created: e.created?.toIso8601String(),
      updated: e.updated?.toIso8601String(),
      summary: e.summary,
      description: e.description,
      location: e.location,
      startTime: e.start?.dateTime ?? e.start?.date,
      endTime: e.end?.dateTime ?? e.end?.date,
      allDay: e.start?.date != null,
      timeZone: e.start?.timeZone,
      recurrence: e.recurrence,
      recurringEventId: e.recurringEventId,
      recurring: e.recurringEventId != null,
      attendeeEmails:
          e.attendees
              ?.where((a) => a.email != null)
              .map((a) => a.email!)
              .toList(),
      anyoneCanAddSelf: e.anyoneCanAddSelf,
      guestsCanModify: e.guestsCanModify,
      guestsCanInviteOthers: e.guestsCanInviteOthers,
      guestsCanSeeOtherGuests: e.guestsCanSeeOtherGuests,
      colorId: e.colorId,
      visibility: e.visibility,
      transparency: e.transparency,
      organizerEmail: e.organizer?.email,
      isSyncedWithGoogle: true,
    );
  }

  static calendar.Event toGoogleEvent(CustomEvent e) {
    return calendar.Event(
      status: e.status,
      htmlLink: e.htmlLink,
      created: e.created != null ? DateTime.tryParse(e.created!) : null,
      updated: e.updated != null ? DateTime.tryParse(e.updated!) : null,
      summary: e.summary,
      description: e.description,
      location: e.location,
      start: calendar.EventDateTime(
        dateTime: e.allDay == true ? null : e.startTime,
        date: e.allDay == true ? e.startTime : null,
        timeZone: e.timeZone,
      ),
      end: calendar.EventDateTime(
        dateTime: e.allDay == true ? null : e.endTime,
        date: e.allDay == true ? e.endTime : null,
        timeZone: e.timeZone,
      ),
      recurrence: e.recurrence,
      recurringEventId: e.recurringEventId,
      attendees:
          e.attendeeEmails?.map((email) {
            return calendar.EventAttendee(email: email);
          }).toList(),
      anyoneCanAddSelf: e.anyoneCanAddSelf,
      guestsCanModify: e.guestsCanModify,
      guestsCanInviteOthers: e.guestsCanInviteOthers,
      guestsCanSeeOtherGuests: e.guestsCanSeeOtherGuests,
      colorId: e.colorId,
      visibility: e.visibility,
      transparency: e.transparency,
      organizer:
          e.organizerEmail != null
              ? calendar.EventOrganizer(email: e.organizerEmail)
              : null,
    );
  }

  @override
  String toString() {
    return 'CustomEvent(id: $id, status: $status, htmlLink: $htmlLink, created: $created, updated: $updated, summary: $summary, description: $description, location: $location, startTime: $startTime, endTime: $endTime, allDay: $allDay, timeZone: $timeZone, recurrence: $recurrence, recurringEventId: $recurringEventId, recurring: $recurring, attendeeEmails: $attendeeEmails, anyoneCanAddSelf: $anyoneCanAddSelf, guestsCanModify: $guestsCanModify, guestsCanInviteOthers: $guestsCanInviteOthers, guestsCanSeeOtherGuests: $guestsCanSeeOtherGuests, colorId: $colorId, visibility: $visibility, transparency: $transparency, organizerEmail: $organizerEmail, isSyncedWithGoogle: $isSyncedWithGoogle)';
  }
}
