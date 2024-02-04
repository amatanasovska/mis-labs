import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final AndroidNotificationDetails androidPlatformChannelSpecifics =
      const AndroidNotificationDetails(
    "123",
    "name",
    channelDescription: "Desc",
  );

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();


  Future showNotification(String content) async {
    print("Show notif now");
    await flutterLocalNotificationsPlugin.show(
        12345,
        "Exam app",
        content,
        NotificationDetails(android: androidPlatformChannelSpecifics),
        payload: 'data');
  }

  Future selectNotification(String? payload) async {
    // Handle notification tapped logic here
  }

  void onDidReceiveLocalNotification(int x, String? y, String? z, String? t) async {
    // todo
  }

  Future<void> init() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('finki');

    final IOSInitializationSettings initializationSettingsIOS =
        IOSInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
      onDidReceiveLocalNotification: onDidReceiveLocalNotification,
    );

    final InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS,
            macOS: null);

    await flutterLocalNotificationsPlugin.initialize(initializationSettings, onSelectNotification: selectNotification);
  }
}
