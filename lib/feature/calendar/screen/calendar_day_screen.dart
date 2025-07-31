import 'package:calendar_friend/feature/calendar/controller/calenda_controller.dart';
import 'package:calendar_friend/feature/edit_schedule/controller/edit_schedule_controller.dart';
import 'package:calendar_friend/feature/edit_schedule/screen/edit_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:intl/intl.dart';

class CalendarDayScreen extends GetView<CalendarController> {
  const CalendarDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              controller.goToEditScreen();
            },
            icon: Icon(Icons.add),
          ),
        ],
      ),
      body: SafeArea(
        child: Obx(
          () => Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.chevron_left),
                      onPressed: () => controller.goToPreviousDay(),
                    ),
                    Text(
                      DateFormat.yMMMMd(
                        'ja_JP',
                      ).format(controller.selectedDay.value),
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.chevron_right),
                      onPressed: () => controller.goToNextDaty(),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: DayView<calendar.Event>(
                  key: ValueKey(controller.selectedDay.value),
                  headerStyle: HeaderStyle(),
                  initialDay: controller.selectedDay.value,
                  showLiveTimeLineInAllDays: true,
                  onEventTap: (event, data) {
                    Get.to(
                      () => EditScheduleScreen(),
                      binding: BindingsBuilder.put(
                        () => EditScheduleController(
                          selectedDay: controller.selectedDay.value,
                          selectedEvent: event.first.event,
                        ),
                      ),
                    );
                  },
                  dayTitleBuilder: (_) => SizedBox(),
                  controller:
                      EventController()
                        ..addAll(_toCalendarEvents(controller.allEvents)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // calendar.Event calendarEventDataToGoogleEvent(
  //   CalendarEventData<Object?> data,
  // ) {
  //   return calendar.Event(
  //     summary: data.title,
  //     description: data.description,
  //     start: calendar.EventDateTime(dateTime: data.startTime),
  //     end: calendar.EventDateTime(dateTime: data.endTime),
  //   );
  // }

  List<CalendarEventData<calendar.Event>> _toCalendarEvents(
    List<calendar.Event> googleEvents,
  ) {
    return googleEvents.map((event) {
      final start =
          event.start?.dateTime?.toLocal() ??
          event.start?.date?.toLocal() ??
          DateTime.now();
      final end =
          event.end?.dateTime?.toLocal() ??
          event.end?.date?.toLocal() ??
          start.add(Duration(hours: 1));

      return CalendarEventData<calendar.Event>(
        title: event.summary ?? '제목 없음',
        titleStyle: TextStyle(fontSize: 12),
        date: start,
        startTime: start,
        endTime: end,
        event: event,
      );
    }).toList();
  }
}
