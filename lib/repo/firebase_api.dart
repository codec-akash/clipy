import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    if (Platform.isAndroid) {
      await _firebaseMessaging.requestPermission();
      final String? fcmToken = await _firebaseMessaging.getToken();
      debugPrint("fcm token is -- $fcmToken");
      FirebaseMessaging.onBackgroundMessage(handleBackgroundMessage);
      try {
        FirebaseMessaging.onMessage.distinct().listen((event) {
          if (event.contentAvailable) {
            debugPrint("payload - ${event.data}");
          }
        });
      } catch (e) {}
    }
  }
}

Future<void> handleBackgroundMessage(RemoteMessage message) async {
  debugPrint("title: ${message.notification?.title}");
  debugPrint("body: ${message.notification?.body}");
  debugPrint("payload: ${message.data}");
}
