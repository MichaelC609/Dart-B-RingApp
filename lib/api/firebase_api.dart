import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:test_app/main.dart';

class FirebaseApi {
  final _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> initNotifications() async {
    await _firebaseMessaging.requestPermission();
    final fCMtoken = await _firebaseMessaging.getToken();

    initPushNotifications();
    print('Token: $fCMtoken');
  }

  void handleMessage(RemoteMessage? message, BuildContext context) {
    if (message == null) return;

    // Show dialog for foreground notifications
    if (message.notification != null) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(message.notification!.title ?? 'No Title'),
          content: Text(message.notification!.body ?? 'No message body.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
                navigatorKey.currentState?.pushNamed(
                  '/log_screen',
                  arguments: message,
                );
              },
              child: const Text('View'),
            ),
          ],
        ),
      );
    }
  }

  Future<void> initPushNotifications() async {
    // Remove handling of initial message
    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      navigatorKey.currentState?.pushNamed(
        '/notification_screen',
        arguments: message,
      );
    });

    FirebaseMessaging.onMessage.listen((message) {
      if (navigatorKey.currentState?.context != null) {
        handleMessage(message, navigatorKey.currentState!.context);
      }
    });
  }
}
