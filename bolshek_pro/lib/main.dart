import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/app/pages/auth/auth_main_page.dart';
import 'package:bolshek_pro/core/service/firebase_api.dart';
import 'package:bolshek_pro/firebase_options.dart';
import 'core/utils/provider.dart';
import 'core/utils/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotifications();

  runApp(MyApp());
}

Future<void> setupFirebaseMessaging() async {
  FirebaseMessaging messaging = FirebaseMessaging.instance;

  // Запрос разрешения на уведомления для iOS
  NotificationSettings settings = await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Разрешение на уведомления получено.');
  } else if (settings.authorizationStatus == AuthorizationStatus.provisional) {
    print('Разрешение на уведомления предоставлено временно.');
  } else {
    print('Разрешение на уведомления не предоставлено.');
  }

  // Подписка на топик
  const topic = "user_topic_79474460-4437-47ef-a9d6-13c70588db8f";
  await messaging.subscribeToTopic(topic);
  print("Подписка на топик '$topic' успешно выполнена.");
}

class MyApp extends StatelessWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
          'Получено уведомление в активном приложении: ${message.notification?.title}');
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(message.notification?.title ?? 'Нет заголовка'),
          content: Text(message.notification?.body ?? 'Нет содержимого'),
        ),
      );
    });
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => GlobalProvider()), // Добавляем AuthProvider
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeColors.lightTheme,
        supportedLocales: const [
          Locale('ru'), // Русский
          Locale('en'), // Английский или любые другие
        ],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],

        // (Необязательно) Можете явно указать, чтобы приложение всегда было на русском:
        locale: const Locale('ru'),
        home: AuthMainScreen(), // Начальный экран
      ),
    );
  }
}
