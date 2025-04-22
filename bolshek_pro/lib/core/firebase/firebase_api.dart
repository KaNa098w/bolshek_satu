// firebase_api.dart
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/core/utils/provider.dart'; // Импортируйте GlobalProvider

class FirebaseApi {
  /// Инициализация уведомлений Firebase
  Future<void> initNotifications(BuildContext context) async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    // Запрос разрешения на получение уведомлений (важно для iOS)
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('Разрешение на уведомления получено.');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('Разрешение получено временно.');
    } else {
      print('Разрешение не предоставлено.');
      return;
    }

    // Получение FCM Device Token
    String? token = await messaging.getToken();
    print("FCM Device Token: $token");

    // Сохранение токена в провайдере
    if (token != null) {
      Provider.of<GlobalProvider>(context, listen: false).setFcmToken(token);
    }

    // Обновление токена при его измененииs
    FirebaseMessaging.instance.onTokenRefresh.listen((newToken) {
      print("Обновленный FCM Device Token: $newToken");
      Provider.of<GlobalProvider>(context, listen: false).setFcmToken(newToken);
    });

    // Прослушивание входящих уведомлений в foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Получено уведомление в foreground: ${message.notification?.title}');
      // Дополнительная логика по обработке уведомлений
    });
  }
}
