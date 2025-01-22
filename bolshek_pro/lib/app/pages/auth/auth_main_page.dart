import 'package:bolshek_pro/app/pages/auth/auth_number_page.dart';
import 'package:bolshek_pro/app/pages/auth/auth_page.dart';
import 'package:bolshek_pro/app/pages/auth/auth_register_page.dart';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
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

  @override
  void initState() {
    super.initState();
    _isAuthenticated = _checkAuthStatus();
  }

  Future<bool> _checkAuthStatus() async {
    try {
      // Проверяем авторизационные данные через GlobalProvider
      await context.read<GlobalProvider>().loadAuthData(context);
      return context.read<GlobalProvider>().authResponse != null;
    } catch (e) {
      print('Error checking auth status: $e');
      return false;
    }
  }

  Future<void> _openWhatsAppChat() async {
    const phoneNumber = '77001012200'; // Пример для Казахстана
    final Uri whatsappUri = Uri.parse('https://wa.me/$phoneNumber');

    // Проверяем, можно ли запустить ссылку
    if (await canLaunchUrl(whatsappUri)) {
      // Используем launchUrl с LaunchMode.externalApplication
      await launchUrl(
        whatsappUri,
        mode: LaunchMode.externalApplication,
      );
    } else {
      // Показываем сообщение об ошибке
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Не удалось открыть WhatsApp'),
        ),
      );
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

        // Если пользователь не авторизован, отображаем стандартный экран
        return Scaffold(
          backgroundColor: Colors.blueGrey[900],
          appBar: AppBar(
            backgroundColor: Colors.blueGrey[900],
            elevation: 0,
            actions: [
              TextButton(
                onPressed: () {
                  _openWhatsAppChat();
                },
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
                            builder: (context) => AuthRegisterScreen()),
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
                          fontWeight: FontWeight.bold),
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
                      style: TextStyle(fontSize: 16, color: ThemeColors.white),
                    ),
                  ),
                ),
                SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30.0),
                  child: Text(
                    'Пользуясь приложением, вы принимаете соглашение и политику конфиденциальности',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
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
