import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:laboratorio_experinece_app/src/domain/entities/sale.dart';
import 'package:laboratorio_experinece_app/src/ui/routing/app_router.dart';

@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }
}

class NotificationsService {
  static final instance = NotificationsService();

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
  bool _localInitialized = false;

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

    _localInitialized = true;
    final launchDetails = await _localNotifications
        .getNotificationAppLaunchDetails();
    final launchPayload = launchDetails?.notificationResponse?.payload;
    if (launchDetails?.didNotificationLaunchApp == true &&
        launchPayload != null &&
        launchPayload.isNotEmpty) {
      onLocalNotificationOpened(launchPayload);
    }

    await _localNotifications
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.requestNotificationsPermission();

    try {
      await _messaging.requestPermission(alert: true, badge: true, sound: true);
    } catch (error) {
      debugPrint('No se pudo solicitar permiso FCM: $error');
    }

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

    try {
      return await _messaging.getInitialMessage();
    } catch (error) {
      debugPrint('No se pudo leer el mensaje inicial FCM: $error');
      return null;
    }
  }

  Future<void> showPurchaseConfirmation(Sale sale) async {
    if (!_supportsMobileNotifications || !_localInitialized) return;

    await _localNotifications.show(
      id: sale.id.hashCode & 0x7fffffff,
      title: 'Compra registrada',
      body:
          'Tu compra por € ${sale.total.toStringAsFixed(2)} fue registrada. Toca para ver el resumen.',
      payload: AppRoutes.storeSale(sale.id),
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
    } catch (error) {
      debugPrint('No se pudo sincronizar el token FCM: $error');
    }
  }

  Future<void> _saveToken(String token) async {
    final user = _auth.currentUser;

    if (user == null) {
      return;
    }

    try {
      await _firestore.collection('users').doc(user.uid).set({
        'email': user.email ?? '',
        'fcmToken': token,
        'fcmTokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (error) {
      debugPrint('No se pudo guardar el token FCM: $error');
    }
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
