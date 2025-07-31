import 'package:calendar_friend/core/auth/controller/google_oauth_contrller.dart';
import 'package:calendar_friend/core/utilities/log_manager.dart';
import 'package:calendar_friend/core/utilities/snackbar_helper.dart';
import 'package:calendar_friend/feature/edit_schedule/controller/edit_schedule_controller.dart';
import 'package:calendar_friend/feature/edit_schedule/screen/edit_schedule_screen.dart';
import 'package:calendar_friend/feature/task_list/screen/task_list_screen.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:get/get.dart';

import 'package:googleapis/calendar/v3.dart' as calendar;

class CalendarController extends GetxController {
  static CalendarController get to => Get.find<CalendarController>();
  final GoogleOAuthController _googleOAuthController;
  late final GoogleCalendarRepository _googleCalendarRepository;

  CalendarController(this._googleOAuthController);
  final DateTime _today = DateTime.now();

  late Rx<DateTime> focusedDay;
  late Rx<DateTime> selectedDay;

  void goToPrevious() {
    focusedDay.value = DateTime(
      focusedDay.value.year,
      focusedDay.value.month - 1,
      1,
    );
  }

  void goToNext() {
    focusedDay.value = DateTime(
      focusedDay.value.year,
      focusedDay.value.month + 1,
      1,
    );
  }

  void goToPreviousDay() {
    selectedDay.value = DateTime(
      selectedDay.value.year,
      selectedDay.value.month,
      selectedDay.value.day - 1,
    );
  }

  void goToNextDaty() {
    selectedDay.value = DateTime(
      selectedDay.value.year,
      selectedDay.value.month,
      selectedDay.value.day + 1,
    );
  }

  RxMap<DateTime, List<calendar.Event>> taskMap =
      <DateTime, List<calendar.Event>>{}.obs;

  List<calendar.Event> getEventsForDay(DateTime day) {
    final key = DateTime(day.year, day.month, day.day);
    return taskMap[key] ?? [];
  }

  final isLoading = false.obs;

  @override
  void onInit() {
    focusedDay = _today.obs;
    selectedDay = _today.obs;

    ever(_googleOAuthController.calendarApi, (calendarApi) {
      _googleCalendarRepository = GoogleCalendarRepository(calendarApi);
      loadMonthlyEvents(DateTime.now());
    });

    super.onInit();
  }

  Future<void> loadMonthlyEvents(DateTime month) async {
    try {
      isLoading(true);
      final events = await _googleCalendarRepository.fetchEventsByMonth(
        month: month,
      );
      Map<DateTime, List<calendar.Event>> map = {};
      for (var event in events) {
        final date =
            event.start?.dateTime?.toLocal() ?? event.start?.date?.toLocal();
        if (date != null) {
          final key = DateTime(date.year, date.month, date.day);
          map.putIfAbsent(key, () => []).add(event);
        }
      }
      allEvents.assignAll(events);
      taskMap.assignAll(map);
    } catch (e) {
      SnackBarHelper.showErrorSnackBar("$e");
      LogManager.error("$e");
    } finally {
      isLoading(false);
    }
  }

  void onDaySelected(DateTime selected, DateTime focused) async {
    focusedDay.value = focused;
    selectedDay.value = selected;

    DateTime dt = DateTime(selected.year, selected.month, selected.day);

    if (taskMap[dt] != null && taskMap[dt]!.isNotEmpty) {
      // 選択した日に予定がある
      Get.to(() => TaskListScreen(tasks: taskMap[dt]!));
      // _goToTaskListScreen();
    } else {
      goToEditScreen();
    }
  }

  void goToEditScreen() async {
    final event = await Get.to(
      () => EditScheduleScreen(),
      binding: BindingsBuilder.put(
        () => EditScheduleController(selectedDay: selectedDay.value),
      ),
    );

    if (event == null) return;
    try {
      isLoading(true);
      await _googleCalendarRepository.addEvent(event);
    } catch (e) {
      SnackBarHelper.showErrorSnackBar("$e");
    } finally {
      isLoading(false);
      loadMonthlyEvents(DateTime.now());
    }
  }

  // final _isShowDayView = false.obs;
  // bool get isShowDayView => _isShowDayView.value;
  // DateTime selectedDate = DateTime.now();
  final allEvents = <calendar.Event>[].obs;

  Future<void> delete(calendar.Event event) async {
    await _googleCalendarRepository.deleteEvent(event);
    await loadMonthlyEvents(selectedDay.value);
  }

  // void toggleDay(DateTime selected) {
  //   selectedDate = selected;
  //   // _isShowDayView.value = !_isShowDayView.value;
  // }
}
