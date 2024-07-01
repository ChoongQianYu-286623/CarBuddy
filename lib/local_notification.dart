import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:rxdart/rxdart.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class LocalNotifications {
  static final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static final onClickNotification = BehaviorSubject<String>();

  // on tap on any notification
  static void onNotificationTap(NotificationResponse notificationResponse) {
    onClickNotification.add(notificationResponse.payload!);
  }

  // Request notification permissions
  static Future<void> _requestPermissions() async {
    await Permission.notification.request();
  }

//initialize the local notifications
  static Future init() async{
    // initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
    const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/car_buddy');
    final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
        onDidReceiveLocalNotification: (id, title, body, payload) => null,);
    final LinuxInitializationSettings initializationSettingsLinux =
      LinuxInitializationSettings(
        defaultActionName: 'Open notification');
    final InitializationSettings initializationSettings = InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsDarwin,
        linux: initializationSettingsLinux);
  _flutterLocalNotificationsPlugin.initialize(initializationSettings,
    onDidReceiveNotificationResponse: onNotificationTap,
        onDidReceiveBackgroundNotificationResponse: onNotificationTap,
    );
  }

  //show simple notification
//   static Future showSimpleNotification({
//     required String title,
//     required String body,
//     required String payload,
//   })async{
//     const AndroidNotificationDetails androidNotificationDetails =
//     AndroidNotificationDetails('your channel id', 'your channel name',
//         channelDescription: 'your channel description',
//         importance: Importance.max,
//         priority: Priority.high,
//         ticker: 'ticker');
// const NotificationDetails notificationDetails =
//     NotificationDetails(android: androidNotificationDetails);
//     print(notificationDetails);
// await _flutterLocalNotificationsPlugin.show(
//     0, title, body, notificationDetails,
//     payload: payload);
//   }

  // to schedule a local notification
  static Future showScheduleNotification({
  required String title,
  required String body,
  required String payload,
  required DateTime scheduledDate,
}) async {
  tz.initializeTimeZones();

  // Calculate the notification time (1 day before the maintenance date)
  final notificationTime = scheduledDate.subtract(const Duration(days: 1));

  // Check if the notification time is in the future
  // if (notificationTime.isBefore(DateTime.now())) {
  //   print('Scheduled date must be a date in the future');
  //   return;
  // }

  await _flutterLocalNotificationsPlugin.zonedSchedule(
    0,
    title,
    body,
    tz.TZDateTime.from(notificationTime, tz.local), // Schedule the notification for the calculated time
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel 2', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    payload: payload,
  );
}

//scheduled notifications for insurance 
static Future showScheduleNotification2({
  required String title,
  required String body,
  required String payload,
  required DateTime scheduledDate,
}) async {
  tz.initializeTimeZones();

  // Calculate the notification time (1 day before the maintenance date)
  final notificationTime = scheduledDate.subtract(const Duration(days: 14));

  // Check if the notification time is in the future
  // if (notificationTime.isBefore(DateTime.now())) {
  //   print('Scheduled date must be a date in the future');
  //   return;
  // }

  await _flutterLocalNotificationsPlugin.zonedSchedule(
    1,
    title,
    body,
    tz.TZDateTime.from(notificationTime, tz.local), // Schedule the notification for the calculated time
    const NotificationDetails(
      android: AndroidNotificationDetails(
        'channel 2', 'your channel name',
        channelDescription: 'your channel description',
        importance: Importance.max,
        priority: Priority.high,
        ticker: 'ticker',
      ),
    ),
    androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
    uiLocalNotificationDateInterpretation: UILocalNotificationDateInterpretation.absoluteTime,
    payload: payload,
  );
}
}