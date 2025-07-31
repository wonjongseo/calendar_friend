import 'package:calendar_friend/feature/calendar/controller/calenda_controller.dart';
import 'package:calendar_friend/feature/custom_event/controller/custom_event_controller.dart';
import 'package:calendar_friend/feature/custom_event/models/custom_event.dart';
import 'package:calendar_friend/feature/edit_schedule/controller/edit_schedule_controller.dart';
import 'package:calendar_friend/feature/edit_schedule/screen/edit_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:intl/intl.dart';

class CalendarDayScreen extends GetView<CustomEventController> {
  const CalendarDayScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          title: topNavigation(),
          centerTitle: true,
          // actions: [
          //   IconButton(
          //     onPressed: () => controller.goToEditScreen(),
          //     icon: Icon(Icons.add),
          //   ),
          // ],
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => controller.goToEditScreen(),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      '新規登録',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: DayView<CustomEvent>(
                  key: ValueKey(controller.selectedDay.value),
                  initialDay: controller.selectedDay.value,
                  onPageChange:
                      (date, page) => controller.changeCalendar(dateTime: date),
                  showLiveTimeLineInAllDays: true,
                  onDateTap: (date) {
                    Get.to(
                      () => EditScheduleScreen(),
                      binding: BindingsBuilder.put(
                        () => EditScheduleController(selectedDay: date),
                      ),
                    );
                  },
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
                      controller.eventController
                        ..addAll(_toCalendarEvents(controller.events)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget topNavigation() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.chevron_left),
          onPressed:
              () => controller.changeCalendar(type: MoveCalendarType.prevDay),
        ),
        Text(
          DateFormat.yMMMMd('ja_JP').format(controller.selectedDay.value),
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed:
              () => controller.changeCalendar(type: MoveCalendarType.nextDay),
        ),
      ],
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

  List<CalendarEventData<CustomEvent>> _toCalendarEvents(
    List<CustomEvent> googleEvents,
  ) {
    return googleEvents.map((event) {
      final start = event.startTime ?? DateTime.now();
      final end = event.endTime ?? start.add(Duration(hours: 1));

      return CalendarEventData<CustomEvent>(
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
