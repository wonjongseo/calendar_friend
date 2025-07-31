// import 'package:calendar_friend/core/auth/controller/google_oauth_contrller.dart';
// import 'package:calendar_friend/feature/calendar/controller/calenda_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';

// import 'package:table_calendar/table_calendar.dart';
// import 'package:googleapis/calendar/v3.dart' as calendar;

// class CalendarScreen extends GetView<CalendarController> {
//   const CalendarScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => Scaffold(
//         floatingActionButton: FloatingActionButton(
//           onPressed: () {
//             GoogleOAuthController.to.handleSignIn();
//           },
//         ),
//         backgroundColor: controller.isLoading.value ? Colors.grey : null,
//         body: SafeArea(
//           child: Stack(
//             children: [
//               TableCalendar(
//                 firstDay: DateTime.utc(2020, 1, 1),
//                 lastDay: DateTime.utc(2030, 12, 31),
//                 focusedDay: controller.focusedDay.value,
//                 headerStyle: HeaderStyle(
//                   titleCentered: true,
//                   formatButtonVisible: false,
//                 ),
//                 locale: "ja-JP",
//                 selectedDayPredicate:
//                     (d) => isSameDay(controller.selectedDay.value, d),
//                 shouldFillViewport: true,
//                 onDaySelected: (selected, focused) {
//                   controller.onDaySelected(selected, focused);
//                 },
//                 eventLoader: controller.getEventsForDay,
//               ),
//               if (controller.isLoading.value)
//                 Center(child: CircularProgressIndicator.adaptive()),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:calendar_friend/core/auth/controller/google_oauth_contrller.dart';
import 'package:calendar_friend/feature/calendar/controller/calenda_controller.dart';
import 'package:calendar_friend/feature/calendar/screen/calendar_day_screen.dart';
import 'package:calendar_friend/feature/edit_schedule/controller/edit_schedule_controller.dart';
import 'package:calendar_friend/feature/edit_schedule/screen/edit_schedule_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:intl/intl.dart';

class CalendarScreen extends GetView<CalendarController> {
  const CalendarScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            GoogleOAuthController.to.handleSignIn();
          },
        ),
        backgroundColor: controller.isLoading.value ? Colors.grey : null,
        body: SafeArea(
          child: Stack(
            children: [
              Column(
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
                          onPressed: () => controller.goToPrevious(),
                        ),
                        Text(
                          DateFormat.yMMMM(
                            'ja_JP',
                          ).format(controller.focusedDay.value),
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.chevron_right),
                          onPressed: () => controller.goToNext(),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: MonthView<calendar.Event>(
                      key: ValueKey(controller.focusedDay.value),
                      initialMonth: controller.focusedDay.value,
                      headerBuilder: (_) => SizedBox(),
                      weekDayBuilder: (int dayIndex) {
                        const weekdaysJa = ['日', '月', '火', '水', '木', '金', '土'];
                        return Center(
                          child: Text(
                            weekdaysJa[dayIndex % 7],
                            style: TextStyle(
                              // fontWeight: FontWeight.bold,
                              fontSize: 20,
                            ),
                          ),
                        );
                      },

                      onEventTap: (event, date) {
                        Get.to(
                          () => EditScheduleScreen(),
                          binding: BindingsBuilder.put(
                            () => EditScheduleController(
                              selectedDay: controller.selectedDay.value,
                              selectedEvent: event.event,
                            ),
                          ),
                        );
                      },
                      onCellTap: (events, date) {
                        controller.selectedDay.value = date;
                        Get.to(() => CalendarDayScreen());
                      },
                      controller:
                          EventController()
                            ..addAll(_toCalendarEvents(controller.allEvents)),
                    ),
                  ),
                ],
              ),
              if (controller.isLoading.value)
                Center(child: CircularProgressIndicator.adaptive()),
            ],
          ),
        ),
      ),
    );
  }

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
        titleStyle: TextStyle(fontSize: 14),
        date: start,
        startTime: start,
        endTime: end,
        event: event,
      );
    }).toList();
  }
}
