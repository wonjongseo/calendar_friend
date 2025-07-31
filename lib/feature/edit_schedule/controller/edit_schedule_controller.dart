import 'package:calendar_friend/core/app_string.dart';
import 'package:calendar_friend/core/auth/controller/google_oauth_contrller.dart';
import 'package:calendar_friend/core/notification/notification_service.dart';
import 'package:calendar_friend/core/utilities/log_manager.dart';
import 'package:calendar_friend/core/utilities/snackbar_helper.dart';
import 'package:calendar_friend/feature/calendar/controller/calenda_controller.dart';
import 'package:calendar_friend/feature/custom_event/models/custom_event.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:calendar_friend/core/utilities/datetime_helper.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;
import 'package:uuid/uuid.dart';

class EditScheduleController extends GetxController {
  final isSyncedWithGoogle = false.obs;

  void toggleSyncedWithGoogle() async {
    final turnedOn = !isSyncedWithGoogle.value;

    if (turnedOn) {
      final success = await GoogleOAuthController.to.ensureSignedIn();
      print('success : ${success}');

      if (success) {
        isSyncedWithGoogle.value = true;
      } else {
        Get.snackbar("로그인 실패", "Google 계정에 로그인할 수 없습니다");
      }
    } else {
      isSyncedWithGoogle.value = false;
    }
  }

  late Rx<DateTime> _startDateTime;
  late Rx<DateTime> _endDateTime;

  String get startDate => DatetimeHelper.dateTime2ymd(_startDateTime.value);
  String get endDate => DatetimeHelper.dateTime2ymd(_endDateTime.value);

  String get startTime => DatetimeHelper.dateTime2hm(_startDateTime.value);
  String get endTime => DatetimeHelper.dateTime2hm(_endDateTime.value);

  late TextEditingController titleTeCtl;

  // final calendar.CalendarApi _calendarApi;
  final DateTime selectedDay;
  final CustomEvent? selectedEvent;

  final selectedColorId = "".obs;
  EditScheduleController({required this.selectedDay, this.selectedEvent});

  @override
  void onInit() {
    titleTeCtl = TextEditingController();
    DateTime dt = selectedDay;
    int hour = dt.hour;
    if (selectedDay.hour == 0) {
      DateTime now = DateTime.now();
      hour = now.hour;
    }
    _startDateTime = DateTime(dt.year, dt.month, dt.day, hour).obs;
    _endDateTime = DateTime(dt.year, dt.month, dt.day, hour + 1).obs;

    if (selectedEvent != null) {
      DateTime startDate = selectedEvent!.startTime ?? _startDateTime.value;
      DateTime endDate = selectedEvent!.endTime ?? _endDateTime.value;

      _startDateTime.value = startDate;
      _endDateTime.value = endDate;

      titleTeCtl.text = selectedEvent!.summary ?? '';
      selectedColorId.value = selectedEvent!.colorId ?? '';
    }

    super.onInit();
  }

  void changeColorId(String colorId) {
    selectedColorId.value = colorId;
  }

  @override
  void dispose() {
    titleTeCtl.dispose();
    super.dispose();
  }

  void onChangeDate(BuildContext context, {required bool isStartDate}) async {
    DateTime? dt = await DatetimeHelper.showDatePicker(
      context,
      initialDate: isStartDate ? _startDateTime.value : _endDateTime.value,
    );
    if (dt != null) {
      isStartDate ? _startDateTime.value = dt : _endDateTime.value = dt;
    }
  }

  void onChangeTime(BuildContext context, {required bool isStartTime}) async {
    TimeOfDay timeOfDay =
        isStartTime
            ? TimeOfDay.fromDateTime(_startDateTime.value)
            : TimeOfDay.fromDateTime(_endDateTime.value);

    TimeOfDay? td = await DatetimeHelper.showTimePicker(
      context,
      timeOfDay: timeOfDay,
    );

    if (td != null) {
      DateTime dt = isStartTime ? _startDateTime.value : _endDateTime.value;

      if (isStartTime) {
        _startDateTime.value = DateTime(
          dt.year,
          dt.month,
          dt.day,
          td.hour,
          td.minute,
        );
      } else {
        _endDateTime.value = DateTime(
          dt.year,
          dt.month,
          dt.day,
          td.hour,
          td.minute,
        );
      }
    }
  }

  void test() async {
    DateTime now = DateTime.now();

    await NotificationService().scheduleWeeklyNotification(
      title: '📖  ${AppString.studyAlram.tr}',
      message: 'test',
      id: 1234,
      weekday: now.weekday,
      hour: now.hour,
      minute: now.minute,
      second: now.second + 5,
    );
  }

  void saveSchedule() async {
    var difference = _endDateTime.value.difference(_startDateTime.value);
    if (difference.isNegative) {
      print("InValid!!");
      return;
    }

    String title = titleTeCtl.text.trim();
    if (title.isEmpty) {
      print("title is isEmpty, InValid!!");
      return;
    }
    test();

    final event = CustomEvent(
      id: const Uuid().v4(),
      summary: title,
      startTime: _startDateTime.value,
      endTime: _endDateTime.value,
      isSyncedWithGoogle: isSyncedWithGoogle.value,
      colorId: selectedColorId.value,
    );

    Get.back(result: event);
    return;
  }

  final isLoading = false.obs;
  void deleteEvent() async {
    if (selectedEvent == null) return;
    try {
      isLoading(true);
      // await CalendarController.to.delete(selectedEvent!);
    } catch (e) {
      SnackBarHelper.showErrorSnackBar("$e");
      LogManager.error("$e");
    } finally {
      isLoading(false);
      Get.back();
    }
  }
}
