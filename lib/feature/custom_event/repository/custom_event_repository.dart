// lib/repository/custom_event_repository.dart

import 'package:calendar_friend/feature/custom_event/models/custom_event.dart';
import 'package:hive/hive.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

class CustomEventRepository {
  final Box<CustomEvent> box;

  CustomEventRepository(this.box);

  Future<void> addEvent(CustomEvent event) async {
    print('event : ${event}');

    await box.put(event.id, event);
  }

  Future<void> deleteEvent(CustomEvent event) async {
    if (event.isSyncedWithGoogle && event.id != null && event.id!.isNotEmpty) {
      try {
        // await calendarApi.events.delete("primary", event.id);
      } catch (e) {
        print("❌ Google 삭제 실패: $e");
      }
    }
    await box.delete(event.id);
  }

  List<CustomEvent> getAllEvents() {
    return box.values.toList();
  }

  List<CustomEvent> getEventsForMonth(DateTime month) {
    final year = month.year;
    final monthNum = month.month;

    return box.values.where((event) {
      if (event.startTime == null) return false;

      return event.startTime!.year == year &&
          event.startTime!.month == monthNum;
    }).toList();
  }

  Future<void> syncToGoogle(CustomEvent event) async {
    // final googleEvent = CustomEvent.toGoogleEvent(event);
    // final inserted = await calendarApi.events.insert(googleEvent, "primary");
    // event.id = inserted.id!;
    // event.isSyncedWithGoogle = true;
    // await event.save();
  }

  Future<void> pullFromGoogle(DateTime from, DateTime to) async {
    // final response = await calendarApi.events.list(
    //   "primary",
    //   timeMin: from.toUtc(),
    //   timeMax: to.toUtc(),
    //   singleEvents: true,
    //   orderBy: "startTime",
    // );

    // for (final e in response.items ?? []) {
    //   if (e.start?.dateTime == null || e.end?.dateTime == null || e.id == null)
    //     continue;
    //   final local = CustomEvent.fromGoogleEvent(e);
    //   await box.put(local.id, local);
    // }
  }
}
