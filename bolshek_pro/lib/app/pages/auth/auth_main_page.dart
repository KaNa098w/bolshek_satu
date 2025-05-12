import 'package:bolshek_pro/app/pages/auth/auth_number_page.dart';
import 'package:bolshek_pro/app/pages/auth/auth_register_page.dart';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/core/service/notification_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/locale_provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:bolshek_pro/generated/l10n.dart';

class AuthMainScreen extends StatefulWidget {
  @override
  _AuthMainScreenState createState() => _AuthMainScreenState();
}

class _AuthMainScreenState extends State<AuthMainScreen> {
  late Future<bool> _isAuthenticated;
  String? _lastSentFcmToken;

  @override
  void initState() {
    super.initState();
    _isAuthenticated = _checkAuthStatus();
  }

  Future<bool> _checkAuthStatus() async {
    try {
      await context.read<GlobalProvider>().loadAuthData(context);
      bool isAuth = context.read<GlobalProvider>().authResponse != null;
      if (isAuth) {
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        print("FCM Device Token: $fcmToken");
        if (fcmToken != null && _lastSentFcmToken != fcmToken) {
          try {
            await NotificationService().sendDeviceToken(context, fcmToken);
            print("FCM token отправлен успешно");
            _lastSentFcmToken = fcmToken;
          } catch (e) {
            print("Ошибка при отправке FCM token: $e");
          }
        } else {
          print("FCM token не изменился, повторная отправка не требуется.");
        }
      }
      return isAuth;
    } catch (e) {
      print('Error checking auth status: $e');
      return false;
    }
  }

  Future<void> _openWhatsAppChat() async {
    const phoneNumber = '77001012200';
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).support),
        ),
      );
    }
  }

  void _launchURL() async {
    final url = 'https://bolshek.kz/legal/privacy';
    if (!await launchUrl(Uri.parse(url))) {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Использование FutureBuilder для проверки аутентификации
    return FutureBuilder<bool>(
      future: _isAuthenticated,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.blueGrey[900],
            body: Center(
                child: SvgPicture.asset(
              'assets/svg/logo_3.svg',
              width: 200,
            )),
          );
        }

        if (snapshot.data == true) {
          return MainControllerNavigator();
        }

        return Scaffold(
          backgroundColor: Colors.blueGrey[900],
          appBar: AppBar(
            // Оборачиваем кнопку выбора языка, чтобы задать направление LTR независимо от выбранной локали
            leading: Directionality(
              textDirection: TextDirection.ltr,
              child: PopupMenuButton<Locale>(
                onSelected: (Locale locale) {
                  Provider.of<LocaleProvider>(context, listen: false)
                      .setLocale(locale);
                },
                icon: const Icon(
                  Icons.language,
                  color: ThemeColors.orange,
                ),
                itemBuilder: (BuildContext context) => <PopupMenuEntry<Locale>>[
                  const PopupMenuItem<Locale>(
                    value: Locale('en'),
                    child: Text("English"),
                  ),
                  const PopupMenuItem<Locale>(
                    value: Locale('ar'),
                    child: Text("العربية"),
                  ),
                  const PopupMenuItem<Locale>(
                    value: Locale('zh'),
                    child: Text("中文"),
                  ),
                  const PopupMenuItem<Locale>(
                    value: Locale('ru'),
                    child: Text("Русский"),
                  ),
                  const PopupMenuItem<Locale>(
                    value: Locale('kk'),
                    child: Text("Қазақ"),
                  ),
                ],
              ),
            ),
            backgroundColor: Colors.blueGrey[900],
            elevation: 0,
            actions: [
              TextButton(
                onPressed: _openWhatsAppChat,
                child: Text(
                  S.of(context).support,
                  style: TextStyle(
                    color: ThemeColors.orange,
                    fontSize: 15,
                  ),
                ),
              ),
            ],
          ),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SvgPicture.asset(
                  'assets/svg/logo_3.svg',
                  width: 90,
                  height: 90,
                ),
                const SizedBox(height: 20),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthRegisterScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: ThemeColors.orange,
                      minimumSize: const Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      S
                          .of(context)
                          .newUser, // Локализованный текст для нового пользователя
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AuthPage(),
                        ),
                      );
                    },
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 50),
                      side: const BorderSide(color: ThemeColors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      S.of(context).login, // Локализованный текст для входа
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeColors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text: S.of(context).agreementText,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: S.of(context).privacyPolicy,
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: ThemeColors.orange,
                          ),
                          recognizer: TapGestureRecognizer()
                            ..onTap = _launchURL,
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
