import 'package:calendar_friend/feature/calendar/controller/calenda_controller.dart';
import 'package:calendar_friend/feature/edit_schedule/controller/edit_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:calendar_friend/core/widgets/custom_test_field.dart';
import 'package:calendar_friend/feature/edit_schedule/screen/widgets/change_date_button.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

class EditScheduleScreen extends GetView<EditScheduleController> {
  const EditScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        appBar: AppBar(
          actions: [
            if (controller.selectedEvent != null)
              IconButton(
                onPressed: controller.deleteEvent,
                icon: Icon(Icons.delete, color: Colors.redAccent),
              ),
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              GestureDetector(
                onTap: () => controller.saveSchedule(),
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  margin: EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      "保存",
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
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
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Stack(
              children: [
                Column(
                  children: [
                    CustomTestField(
                      hintText: "タイトル",
                      controller: controller.titleTeCtl,
                    ),
                    CustomTestField(
                      hintText: "開始",
                      readOnly: true,
                      widget: Row(
                        children: [
                          ChangeDateButton(
                            onTap:
                                () => controller.onChangeDate(
                                  context,
                                  isStartDate: true,
                                ),
                            label: controller.startDate,
                          ),
                          SizedBox(width: 10),
                          ChangeDateButton(
                            onTap:
                                () => controller.onChangeTime(
                                  context,
                                  isStartTime: true,
                                ),

                            label: controller.startTime,
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    CustomTestField(
                      hintText: "終了",
                      readOnly: true,
                      widget: Row(
                        children: [
                          ChangeDateButton(
                            onTap:
                                () => controller.onChangeDate(
                                  context,
                                  isStartDate: false,
                                ),
                            label: controller.endDate,
                          ),
                          SizedBox(width: 10),
                          ChangeDateButton(
                            onTap:
                                () => controller.onChangeTime(
                                  context,
                                  isStartTime: false,
                                ),

                            label: controller.endTime,
                          ),
                          SizedBox(width: 10),
                        ],
                      ),
                    ),
                    CustomTestField(),
                  ],
                ),

                if (controller.isLoading.value)
                  Center(child: CircularProgressIndicator.adaptive()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
