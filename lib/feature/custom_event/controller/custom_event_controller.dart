// lib/controller/custom_event_controller.dart

import 'package:calendar_friend/core/auth/controller/google_oauth_contrller.dart';
import 'package:calendar_friend/core/utilities/log_manager.dart';
import 'package:calendar_friend/core/utilities/snackbar_helper.dart';
import 'package:calendar_friend/feature/custom_event/models/custom_event.dart';
import 'package:calendar_friend/feature/custom_event/repository/custom_event_repository.dart';
import 'package:calendar_friend/feature/edit_schedule/controller/edit_schedule_controller.dart';
import 'package:calendar_friend/feature/edit_schedule/screen/edit_schedule_screen.dart';
import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

enum MoveCalendarType { nextMonth, prevMonth, nextDay, prevDay }

class CustomEventController extends GetxController {
  final CustomEventRepository repository;
  final DateTime _today = DateTime.now();

  // late Rx<DateTime> focusedDay;
  late Rx<DateTime> selectedDay;

  final isLoading = false.obs;

  CustomEventController(this.repository);

  final RxList<CustomEvent> events = <CustomEvent>[].obs;

  @override
  void onInit() {
    super.onInit();

    // focusedDay = _today.obs;
    selectedDay = _today.obs;

    loadEvents();
    // ever(_googleOAuthController.calendarApi, (calendarApi) {
    //   _googleCalendarRepository = GoogleCalendarRepository(calendarApi);
    //   loadMonthlyEvents(DateTime.now());
    // });
  }

  void loadEvents() {
    try {
      isLoading(true);
      events.value = repository.getEventsForMonth(selectedDay.value);
    } catch (e) {
      SnackBarHelper.showErrorSnackBar("$e");
      LogManager.error("$e");
    } finally {
      isLoading(false);
    }
  }

  void goToEditScreen() async {
    CustomEvent? event = await Get.to(
      () => EditScheduleScreen(),
      binding: BindingsBuilder.put(
        () => EditScheduleController(selectedDay: selectedDay.value),
      ),
    );

    if (event == null) return;
    try {
      isLoading(true);
      await repository.addEvent(event);
      if (event.isSyncedWithGoogle) {
        GoogleCalendarRepository repository =
            Get.find<GoogleCalendarRepository>();

        await repository.addEvent(CustomEvent.toGoogleEvent(event));
      }
    } catch (e) {
      SnackBarHelper.showErrorSnackBar("$e");
    } finally {
      isLoading(false);
      loadEvents();
      // loadMonthlyEvents(DateTime.now());
    }
  }

  Future<void> addEvent(CustomEvent event) async {
    await repository.addEvent(event);
    loadEvents();
  }

  Future<void> deleteEvent(CustomEvent event) async {
    await repository.deleteEvent(event);
    loadEvents();
  }

  Future<void> syncToGoogle(CustomEvent event) async {
    await repository.syncToGoogle(event);
    loadEvents();
  }

  Future<void> syncFromGoogle(DateTime from, DateTime to) async {
    await repository.pullFromGoogle(from, to);
    loadEvents();
  }

  void changeCalendar({MoveCalendarType? type, DateTime? dateTime}) {
    DateTime prevDay = selectedDay.value;
    if (type != null) {
      switch (type) {
        case MoveCalendarType.nextMonth:
          selectedDay.value = DateTime(
            selectedDay.value.year,
            selectedDay.value.month + 1,
            1,
          );
        case MoveCalendarType.prevMonth:
          selectedDay.value = DateTime(
            selectedDay.value.year,
            selectedDay.value.month - 1,
            1,
          );
        case MoveCalendarType.nextDay:
          selectedDay.value = DateTime(
            selectedDay.value.year,
            selectedDay.value.month,
            selectedDay.value.day + 1,
          );
        case MoveCalendarType.prevDay:
          selectedDay.value = DateTime(
            selectedDay.value.year,
            selectedDay.value.month,
            selectedDay.value.day - 1,
          );
      }
    } else if (dateTime != null) {
      selectedDay.value = dateTime;
    }
    if (prevDay.month != selectedDay.value.month) {
      loadEvents();
    }
  }

  EventController<CustomEvent> eventController = EventController<CustomEvent>();
}
