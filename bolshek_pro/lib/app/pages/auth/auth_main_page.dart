import 'package:bolshek_pro/app/pages/auth/auth_number_page.dart';
import 'package:bolshek_pro/app/pages/auth/auth_page.dart';
import 'package:bolshek_pro/app/pages/auth/auth_register_page.dart';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/core/service/notification_service.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class AuthMainScreen extends StatefulWidget {
  @override
  _AuthMainScreenState createState() => _AuthMainScreenState();
}

class _AuthMainScreenState extends State<AuthMainScreen> {
  late Future<bool> _isAuthenticated;
  String?
      _lastSentFcmToken; // Переменная для хранения ранее отправленного токена

  @override
  void initState() {
    super.initState();
    _isAuthenticated = _checkAuthStatus();
  }

  Future<bool> _checkAuthStatus() async {
    try {
      // Загружаем данные авторизации через GlobalProvider
      await context.read<GlobalProvider>().loadAuthData(context);
      bool isAuth = context.read<GlobalProvider>().authResponse != null;
      if (isAuth) {
        // Получаем FCM-токен
        String? fcmToken = await FirebaseMessaging.instance.getToken();
        print("FCM Device Token: $fcmToken");
        if (fcmToken != null) {
          // Если токен не совпадает с ранее отправленным, отправляем его
          if (_lastSentFcmToken != fcmToken) {
            try {
              await NotificationService().sendDeviceToken(context, fcmToken);
              print("FCM token отправлен успешно");
              _lastSentFcmToken = fcmToken; // Обновляем сохранённый токен
            } catch (e) {
              print("Ошибка при отправке FCM token: $e");
            }
          } else {
            print("FCM token не изменился, повторная отправка не требуется.");
          }
        }
      }
      return isAuth;
    } catch (e) {
      print('Error checking auth status: $e');
      return false;
    }
  }

  Future<void> _openWhatsAppChat() async {
    const phoneNumber = '77001012200'; // Пример для Казахстана
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');

    if (await canLaunchUrl(whatsappUri)) {
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось открыть WhatsApp'),
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
    return FutureBuilder<bool>(
      future: _isAuthenticated,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
            backgroundColor: Colors.blueGrey[900],
            body: Center(
              child: CircularProgressIndicator(
                color: ThemeColors.orange,
              ),
            ),
          );
        }

        if (snapshot.data == true) {
          // Если пользователь авторизован, перенаправляем на MainControllerNavigator
          return MainControllerNavigator();
        }

        // Если пользователь не авторизован, отображаем экран входа/регистрации
        return Scaffold(
          backgroundColor: Colors.blueGrey[900],
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[900],
            elevation: 0,
            actions: [
              TextButton(
                onPressed: _openWhatsAppChat,
                child: Text(
                  'Поддержка',
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
                SizedBox(height: 20),
                SizedBox(height: 40),
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
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Я новый пользователь',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 15),
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
                      minimumSize: Size(double.infinity, 50),
                      side: BorderSide(color: ThemeColors.orange),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'У меня есть аккаунт. Войти',
                      style: TextStyle(
                        fontSize: 16,
                        color: ThemeColors.white,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      text:
                          'Пользуясь приложением, вы принимаете соглашение и ',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      children: [
                        TextSpan(
                          text: 'политику конфиденциальности',
                          style: const TextStyle(
                            decoration: TextDecoration.underline,
                            color: ThemeColors
                                .orange, // можно изменить цвет по желанию
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
