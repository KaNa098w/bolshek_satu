import 'package:bolshek_pro/app/pages/auth/preloader_screen.dart';
import 'package:bolshek_pro/generated/kz.dart';
import 'package:bolshek_pro/core/utils/locale_provider.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bolshek_pro/app/pages/auth/auth_main_page.dart';
import 'package:bolshek_pro/core/firebase/firebase_options.dart';
import 'core/utils/provider.dart';
import 'core/utils/theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

// Глобальный RouteObserver для отслеживания навигации
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

// Обработчик фоновых уведомлений
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("Фоновое сообщение: ${message.messageId}");
  // Дополнительная обработка, если необходимо.
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => GlobalProvider()),
        ChangeNotifierProvider(create: (_) => LocaleProvider()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _setupFirebaseMessaging();
  }

  Future<void> _setupFirebaseMessaging() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;
    NotificationSettings settings = await messaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Статус разрешения на уведомления: ${settings.authorizationStatus}");

    if (settings.authorizationStatus == AuthorizationStatus.authorized ||
        settings.authorizationStatus == AuthorizationStatus.provisional) {
      String? fcmToken = await messaging.getToken();
      print("FCM Device Token: $fcmToken");
    } else {
      print("Разрешение не предоставлено. Уведомления не будут получаться.");
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeProvider = Provider.of<LocaleProvider>(context);
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

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeColors.lightTheme,
      navigatorObservers: [routeObserver],
      // Передаём локаль, выбранную пользователем
      locale: localeProvider.locale,
      // Используем поддерживаемые локали из сгенерированного делегата
      supportedLocales: S.delegate.supportedLocales,
      // Подключаем делегаты локализации, включая наш S.delegate
      localizationsDelegates: const [
        S.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        KzMaterialLocalizationsDelegate(), // ваш кастомный делегат для казахской локали
      ],

      home: PreloaderScreen(),
    );
  }
}
