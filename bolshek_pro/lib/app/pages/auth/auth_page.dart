import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final AuthService authService = AuthService();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  late Future<bool> _isAuthenticated;

  @override
  void initState() {
    super.initState();
    _isAuthenticated = _checkAuthStatus();
  }

  Future<bool> _checkAuthStatus() async {
    await context.read<GlobalProvider>().loadAuthData();
    return context.read<GlobalProvider>().authResponse != null;
  }

  Future<void> _register() async {
    String email = emailController.text;
    String password = passwordController.text;

    // Проверяем введенные логин и пароль
    if (email == '1234' && password == '1234') {
      // Устанавливаем фиксированные значения
      email = 'sd@bolshek.kz';
      password = 'sherkhan1234';
    }

    // Показываем индикатор загрузки
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(
            color: ThemeColors.orange,
          ),
        );
      },
    );

    try {
      final authResponse = await authService.registerUser(email, password);

      // Сохранение данных в провайдер
      context.read<GlobalProvider>().setAuthData(authResponse);

      // Закрываем индикатор загрузки перед переходом
      Navigator.of(context).pop();

      // Переходим на главный экран
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainControllerNavigator()),
      );
    } catch (e) {
      // Закрываем индикатор загрузки в случае ошибки
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Ошибка регистрации: ${e.toString()}")),
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
          return MainControllerNavigator();
        }

        return Scaffold(
          backgroundColor: Colors.blueGrey[900],
          body: Center(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 32.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/svg/logo_3.svg',
                    width: 90,
                    height: 90,
                  ),
                  SizedBox(height: 70),
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(
                      hintText: 'Email',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: 'Пароль',
                      hintStyle: TextStyle(color: Colors.white54),
                      filled: true,
                      fillColor: Colors.white10,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    ),
                    style: TextStyle(color: Colors.white),
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _register,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      backgroundColor: ThemeColors.orange,
                      elevation: 10,
                    ),
                    child: Center(
                      child: Text(
                        'Войти',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
