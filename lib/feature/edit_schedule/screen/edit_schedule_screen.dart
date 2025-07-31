import 'package:calendar_friend/feature/calendar/controller/calenda_controller.dart';
import 'package:calendar_friend/feature/edit_schedule/controller/edit_schedule_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/state_manager.dart';
import 'package:calendar_friend/core/widgets/custom_test_field.dart';
import 'package:calendar_friend/feature/edit_schedule/screen/widgets/change_date_button.dart';
import 'package:googleapis/calendar/v3.dart' as calendar;

const Map<String, Color> googleColorIdMap = {
  '1': Color(0xFF7986CB), // Lavender
  '2': Color(0xFF33B679), // Sage
  '3': Color(0xFF8E24AA), // Grape
  '4': Color(0xFFE67C73), // Flamingo
  '5': Color(0xFFF6BF26), // Banana
  '6': Color(0xFFF4511E), // Tangerine
  '7': Color(0xFF039BE5), // Peacock
  '8': Color(0xFF616161), // Graphite
  '9': Color(0xFF3F51B5), // Blueberry
  '10': Color(0xFF0B8043), // Basil
  '11': Color(0xFFD60000), // Tomato
};

class ColorPickerWidget extends StatelessWidget {
  final String? selectedColorId;
  final void Function(String colorId) onColorSelected;

  const ColorPickerWidget({
    Key? key,
    required this.selectedColorId,
    required this.onColorSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children:
          googleColorIdMap.entries.map((entry) {
            final isSelected = entry.key == selectedColorId;
            return GestureDetector(
              onTap: () => onColorSelected(entry.key),
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: entry.value,
                  shape: BoxShape.circle,
                  border:
                      isSelected
                          ? Border.all(color: Colors.black, width: 3)
                          : null,
                ),
              ),
            );
          }).toList(),
    );
  }
}

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
                  decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  margin: EdgeInsets.symmetric(horizontal: 16),
                  child: Center(
                    child: Text(
                      '保存',
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
        body: _body(context),
      ),
    );
  }

  SafeArea _body(BuildContext context) {
    return SafeArea(
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

                SwitchListTile.adaptive(
                  dense: true,
                  title: Text('Googleカレンダ連携'),
                  value: controller.isSyncedWithGoogle.value,
                  onChanged: (v) => controller.toggleSyncedWithGoogle(),
                ),

                ColorPickerWidget(
                  selectedColorId: controller.selectedColorId.value,
                  onColorSelected: (v) => controller.changeColorId(v),
                ),
              ],
            ),

            if (controller.isLoading.value)
              Center(child: CircularProgressIndicator.adaptive()),
          ],
        ),
      ),
    );
  }
}
