// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:sowandgrow/main.dart';
//
// class FirebaseApi {
//   //Firebase Push Notifications
//   final _firebaseMessaging = FirebaseMessaging.instance;
//
//   Future<void> initNotifications() async {
//     try {
//       await _firebaseMessaging.requestPermission();
//       final fCMToken = await _firebaseMessaging.getToken();
//       print("FCM Token: $fCMToken");
//       initPushNotifications();
//     } catch (e) {
//       print("Error fetching FCM token: $e");
//     }
//   }
//
//   void handleMessage(RemoteMessage? message) {
//     if (message == null) return;
//     navigatorKey.currentState?.pushNamed(
//       '/notification_page',
//       arguments: message,
//     );
//   }
//
//   Future initPushNotifications() async {
//     FirebaseMessaging.instance.getInitialMessage().then((handleMessage));
//     FirebaseMessaging.onMessageOpenedApp.listen(handleMessage);
//   }
// }
