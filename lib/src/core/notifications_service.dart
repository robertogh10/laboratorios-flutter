import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

class NotificationsService {
  NotificationsService({
    FirebaseMessaging? messaging,
    FirebaseAuth? auth,
    FirebaseFirestore? firestore,
    FlutterLocalNotificationsPlugin? localNotifications,
  }) : _messaging = messaging ?? FirebaseMessaging.instance,
       _auth = auth ?? FirebaseAuth.instance,
       _firestore = firestore ?? FirebaseFirestore.instance,
       _localNotifications =
           localNotifications ?? FlutterLocalNotificationsPlugin();

  static const _channel = AndroidNotificationChannel(
    'high_priority_notifications',
    'Avisos importantes',
    description: 'Compras, ventas y novedades importantes.',
    importance: Importance.high,
  );

  final FirebaseMessaging _messaging;
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FlutterLocalNotificationsPlugin _localNotifications;

  StreamSubscription<RemoteMessage>? _foregroundSubscription;
  StreamSubscription<RemoteMessage>? _openSubscription;
  StreamSubscription<String>? _tokenSubscription;
  StreamSubscription<User?>? _authSubscription;

  static void registerBackgroundHandler() {
    if (_supportsMobileNotifications) {
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);
    }
  }

  Future<RemoteMessage?> initialize({
    required ValueChanged<RemoteMessage> onNotificationOpened,
    required ValueChanged<String> onLocalNotificationOpened,
  }) async {
    if (!_supportsMobileNotifications) {
      return null;
    }

    await _messaging.requestPermission(alert: true, badge: true, sound: true);
    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(_channel);
    await _localNotifications.initialize(
      settings: const InitializationSettings(
        android: AndroidInitializationSettings('@mipmap/ic_launcher'),
        iOS: DarwinInitializationSettings(),
      ),
      onDidReceiveNotificationResponse: (response) {
        final destination = response.payload;

        if (destination != null && destination.isNotEmpty) {
          onLocalNotificationOpened(destination);
        }
      },
    );

    _foregroundSubscription = FirebaseMessaging.onMessage.listen(
      _showForegroundNotification,
    );
    _openSubscription = FirebaseMessaging.onMessageOpenedApp.listen(
      onNotificationOpened,
    );
    _tokenSubscription = _messaging.onTokenRefresh.listen(_saveToken);
    _authSubscription = _auth.authStateChanges().listen((user) async {
      if (user != null) {
        await _syncToken();
      }
    });
    await _syncToken();

    return _messaging.getInitialMessage();
  }

  Future<void> _showForegroundNotification(RemoteMessage message) async {
    final notification = message.notification;

    if (notification == null) {
      return;
    }

    await _localNotifications.show(
      id: notification.hashCode,
      title: notification.title ?? 'Notificacion',
      body: notification.body ?? '',
      payload: (message.data['route'] ?? message.data['pantalla'])?.toString(),
      notificationDetails: const NotificationDetails(
        android: AndroidNotificationDetails(
          'high_priority_notifications',
          'Avisos importantes',
          channelDescription: 'Compras, ventas y novedades importantes.',
          importance: Importance.high,
          priority: Priority.high,
        ),
        iOS: DarwinNotificationDetails(),
      ),
    );
  }

  Future<void> _syncToken() async {
    try {
      final token = await _messaging.getToken();

      if (token != null) {
        await _saveToken(token);
      }
    } on FirebaseException catch (error) {
      debugPrint('No se pudo sincronizar el token FCM: ${error.code}');
    }
  }

  Future<void> _saveToken(String token) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    await _firestore.collection('users').doc(user.uid).set({
      'email': user.email ?? '',
      'fcmToken': token,
      'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  void dispose() {
    _foregroundSubscription?.cancel();
    _openSubscription?.cancel();
    _tokenSubscription?.cancel();
    _authSubscription?.cancel();
  }

  static bool get _supportsMobileNotifications {
    return !kIsWeb &&
        {
          TargetPlatform.android,
          TargetPlatform.iOS,
        }.contains(defaultTargetPlatform);
  }
}
