import 'package:calendar_friend/test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:get/get.dart';

import 'package:googleapis/calendar/v3.dart' as calendar;

class GoogleOAuthController extends GetxController {
  static GoogleOAuthController get to => Get.find<GoogleOAuthController>();
  GoogleSignInAccount? currentUser;
  final Rxn<calendar.CalendarApi> calendarApi = Rxn<calendar.CalendarApi>();

  final _googleSignIn = GoogleSignIn(
    scopes: [calendar.CalendarApi.calendarScope],
  );
  @override
  void onInit() {
    _googleSignIn.onCurrentUserChanged.listen((account) async {
      if (account != null) {
        final authHeaders = await account.authHeaders;
        final client = GoogleHttpClient(authHeaders);
        calendarApi.value = calendar.CalendarApi(client);

        currentUser = account;
      }
    });
    _googleSignIn.signInSilently();
    super.onInit();
  }

  Future<void> handleSignIn() async {
    try {
      await _googleSignIn.signIn();
    } catch (error) {}
  }
}

class GoogleCalendarRepository {
  final calendar.CalendarApi? _calendarApi;
  GoogleCalendarRepository(this._calendarApi);

  Future<List<calendar.Event>> fetchEvents({
    required DateTime start,
    required DateTime end,
  }) async {
    if (_calendarApi == null) return [];
    return (await _calendarApi!.events.list(
          "primary",
          timeMin: start.toUtc(),
          timeMax: end.toUtc(),
          singleEvents: true,
          orderBy: "startTime",
        )).items ??
        [];
  }

  Future<List<calendar.Event>> fetchEventsByMonth({
    required DateTime month,
  }) async {
    print('_calendarApi : ${_calendarApi}');

    if (_calendarApi == null) return [];

    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(
      month.year,
      month.month + 1,
      0,
    ).add(Duration(days: 1));
    return (await _calendarApi.events.list(
          "primary",
          timeMin: firstDay.toUtc(),
          timeMax: lastDay.toUtc(),
          singleEvents: true,
          orderBy: "startTime",
        )).items ??
        [];
  }

  Future<void> addEvent(calendar.Event event) async {
    if (_calendarApi == null) return;

    await _calendarApi!.events.insert(event, "primary");
  }

  Future<void> deleteEvent(calendar.Event event) async {
    if (_calendarApi == null) return;

    await _calendarApi.events.delete('primary', event.id!);
  }
}
