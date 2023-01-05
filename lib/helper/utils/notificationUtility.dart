// ignore_for_file: use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:egrocer/helper/utils/constant.dart';
import 'package:egrocer/helper/utils/routeGenerator.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';

class NotificationUtility {
  static String defaultNotificationType = "default";

  static void onReceivedNotification(
      Map<String, dynamic> data, BuildContext context) async {}

  static void _onTapNotificationScreenNavigateCallback(
      {required String notificationType, required BuildContext context}) {
    if (notificationType == defaultNotificationType) {
      if (currentRoute != notificationListScreen) {
        Navigator.pushNamed(context, notificationListScreen);
      }
    }
  }

  static final FlutterLocalNotificationsPlugin
      _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  static Future<void> setUpNotificationService(
      BuildContext buildContext) async {
    NotificationSettings notificationSettings =
        await FirebaseMessaging.instance.getNotificationSettings();

    //ask for permission
    if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.notDetermined) {
      notificationSettings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: true,
        sound: true,
      );

      //if permission is provisional or authorised
      if (notificationSettings.authorizationStatus ==
              AuthorizationStatus.authorized ||
          notificationSettings.authorizationStatus ==
              AuthorizationStatus.provisional) {
        initNotificationListener(buildContext);
      }

      //if permission denied
    } else if (notificationSettings.authorizationStatus ==
        AuthorizationStatus.denied) {
      return;
    }
    initNotificationListener(buildContext);
  }

  static void initNotificationListener(BuildContext buildContext) {
    FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
      alert: true, // Required to display a heads up notification
      badge: true,
      sound: true,
    );
    FirebaseMessaging.onMessage.listen((remoteMessage) {
      foregroundMessageListener(remoteMessage, buildContext);
    });
    FirebaseMessaging.onBackgroundMessage(onBackgroundMessage);
    FirebaseMessaging.onMessageOpenedApp.listen((remoteMessage) {
      onMessageOpenedAppListener(remoteMessage, buildContext);
    });
    _initLocalNotification(buildContext);
  }

  static Future<void> onBackgroundMessage(RemoteMessage remoteMessage) async {
    //perform any background task if needed here
  }

  static void foregroundMessageListener(
      RemoteMessage remoteMessage, BuildContext context) async {
    await FirebaseMessaging.instance.getToken();

    final additionalData = Map<String, dynamic>.from(
        jsonDecode(remoteMessage.data['data'].toString()));

    onReceivedNotification(additionalData, context);

    _createLocalNotification(
        imageUrl: (additionalData['image'] ?? "").toString(),
        title: remoteMessage.notification?.title ?? "You have new notification",
        body: remoteMessage.notification?.body ?? "",
        payload: (additionalData['type'] ?? "").toString());
  }

  static void onMessageOpenedAppListener(
      RemoteMessage remoteMessage, BuildContext buildContext) {
    _onTapNotificationScreenNavigateCallback(
        context: buildContext,
        notificationType: remoteMessage.data['type'] ?? "");
  }

  static void _initLocalNotification(BuildContext context) async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    final DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
            onDidReceiveLocalNotification:
                (int id, String? title, String? body, String? payLoad) {});

    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsIOS,
    );
    _requestPermissionsForIos();
    await _flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) {
        _onTapNotificationScreenNavigateCallback(
            context: context, notificationType: details.payload ?? "");
      },
    );
  }

  static Future<void> _requestPermissionsForIos() async {
    if (Platform.isIOS) {
      _flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions();
    }
  }

  static Future<void> _createLocalNotification(
      {required String title,
      required String body,
      required String imageUrl,
      required String payload}) async {
    late AndroidNotificationDetails androidPlatformChannelSpecifics;
    if (imageUrl.isNotEmpty) {
      final downloadedImagePath = await _downloadAndSaveFile(imageUrl);
      if (downloadedImagePath.isEmpty) {
        //If somehow failed to download image
        androidPlatformChannelSpecifics = AndroidNotificationDetails(
            Constant.packageName, //channel id
            'Local notification', //channel name
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
      } else {
        var bigPictureStyleInformation = BigPictureStyleInformation(
            FilePathAndroidBitmap(downloadedImagePath),
            hideExpandedLargeIcon: true,
            contentTitle: title,
            htmlFormatContentTitle: true,
            summaryText: title,
            htmlFormatSummaryText: true);

        androidPlatformChannelSpecifics = AndroidNotificationDetails(
            Constant.packageName, //channel id
            'Local notification', //channel name
            importance: Importance.max,
            priority: Priority.high,
            largeIcon: FilePathAndroidBitmap(downloadedImagePath),
            styleInformation: bigPictureStyleInformation,
            ticker: 'ticker');
      }
    } else {
      androidPlatformChannelSpecifics = AndroidNotificationDetails(
          Constant.packageName, //channel id
          'Local notification', //channel name
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker');
    }
    const DarwinNotificationDetails iosNotificationDetails =
        DarwinNotificationDetails();

    var platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics, iOS: iosNotificationDetails);
    await _flutterLocalNotificationsPlugin
        .show(0, title, body, platformChannelSpecifics, payload: payload);
  }

  static Future<String> _downloadAndSaveFile(String imageUrl) async {
    String documentDirectory = "";
    if (Platform.isIOS) {
      documentDirectory = (await getApplicationDocumentsDirectory()).path;
    } else {
      documentDirectory = (await getExternalStorageDirectory())!.path;
    }

    final File file = File("$documentDirectory/${imageUrl.split("/").last}");
    var response = await get(Uri.parse(imageUrl));
    file.writeAsBytes(response.bodyBytes);
    return file.path;
  }
}
