import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:test_app/main.dart';

class FirebaseApi {
  // create FCM instance
  final _firebaseMessaging = FirebaseMessaging.instance;

  // initialize notifs
  Future<void> initNotifications() async {
    // request perms
    await _firebaseMessaging.requestPermission();
    // fetch FCM token
    final fCMtoken = await _firebaseMessaging.getToken();

    initPushNotifications();
    print('Token: $fCMtoken');
  }

  // function to handle notifications
  void handleMessage(RemoteMessage? message) {
    // do nothing if empty message
    if (message == null) return;

    navigatorKey.currentState
        ?.pushNamed('/notification_screen', arguments: message);
  }

  // function for background settings
  Future initPushNotifications() async {
    // handle notifications if app was closed and opened
    FirebaseMessaging.instance.getInitialMessage().then(handleMessage);

    // attach event listeners
    FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
  }
}
