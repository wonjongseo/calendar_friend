import 'package:calendar_friend/core/app_string.dart';
import 'package:calendar_friend/core/auth/controller/google_oauth_contrller.dart';
import 'package:calendar_friend/core/utilities/log_manager.dart';
import 'package:calendar_friend/feature/calendar/controller/calenda_controller.dart';
import 'package:calendar_friend/feature/calendar/screen/calendar_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:get/get.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // MobileAds.instance.initialize();
  initializeDateFormatting();
  await _initializeTimeZone();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home: CalendarScreen(),
      fallbackLocale: const Locale('ja', 'JP'),
      locale: Locale(Get.locale.toString()),
      translations: AppTranslations(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      initialBinding: InitialBinding(),
    );
  }
}

class InitialBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GoogleOAuthController());
    Get.lazyPut(
      () => GoogleCalendarRepository(
        Get.find<GoogleOAuthController>().calendarApi.value,
      ),
    );
    Get.lazyPut(() => CalendarController(Get.find()));
  }
}

Future<void> _initializeTimeZone() async {
  tz.initializeTimeZones();
  final String currentTimeZone = await FlutterTimezone.getLocalTimezone();
  LogManager.info("📌 Timezone: $currentTimeZone");
  tz.setLocalLocation(tz.getLocation(currentTimeZone));
}
