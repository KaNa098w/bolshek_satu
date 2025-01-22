import 'dart:async';

import 'package:bolshek_pro/app/pages/auth/auth_register_page.dart';
import 'package:bolshek_pro/app/pages/auth/code_input_page.dart';
import 'package:bolshek_pro/app/widgets/phone_number_formatter.dart';
import 'package:bolshek_pro/app/widgets/widget_from_bolshek/theme_text_style.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math';

import 'package:pin_code_fields/pin_code_fields.dart';

class AuthPage extends StatefulWidget {
  @override
  _AuthPageState createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextEditingController _phoneController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  StreamController<ErrorAnimationType>? errorController;
  String currentText = "";
  Timer? _timer;
  int _start = 60;
  bool _isLoading = false;

  final AuthService _authService = AuthService();

  @override
  void dispose() {
    _timer?.cancel();
    errorController?.close();
    super.dispose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (_start == 0) {
          if (mounted) {
            setState(() {
              timer.cancel();
            });
          }
        } else {
          if (mounted) {
            setState(() {
              _start--;
            });
          }
        }
      },
    );
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: true, // Запрет закрытия окна по клику вне его
      builder: (BuildContext context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20), // Закругленные углы
          ),
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: 10,
                ),
                Icon(
                  Icons.no_accounts_outlined,
                  size: 59,
                  color: Colors.grey,
                ),
                const SizedBox(height: 16),
                Text(
                  "Ваш номер не зарегистрирован.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Пожалуйста, переходите на \nстраницу регистрации.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'InterRegular',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
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
                      backgroundColor: ThemeColors.orange, // Жёлтый цвет кнопки
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      elevation: 0,
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: const Text(
                      "Перейти",
                      style: TextStyle(
                        fontFamily: 'InterRegular',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.white,
                      ),
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

  Future<void> _handleSendSms() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      String phoneNumber =
          _phoneController.text.replaceAll(RegExp(r'[^\d+]'), '');

      try {
        final response = await _authService.fetchOtpId(context, phoneNumber);

        final isRegistered = response['isRegistered'] as bool;
        final otpId = response['otpId'] as String;

        if (isRegistered == true) {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CodeInputPage(
                isRegistered: isRegistered,
                otpId: otpId,
                phoneNumber: phoneNumber,
              ),
            ),
          );
        } else {
          _showSuccessDialog();
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.grey,
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void sendSmsCode() {
    // Логика отправки SMS
    startTimer();
  }

  @override
  void initState() {
    super.initState();
    errorController = StreamController<ErrorAnimationType>();
    startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Text(
                  Constants.welcome1,
                  textAlign: TextAlign.center,
                  style: ThemeTextMontserratBold.size21,
                  maxLines: 1,
                ),
                const SizedBox(height: 10),
                Text(
                  "Мы используем ваш номер телефона для уведомлений о заказе",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 30),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(12)),
                  child: TextFormField(
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                    cursorColor: ThemeColors.orange,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      PhoneNumberFormatter(),
                    ],
                    decoration: InputDecoration(
                        contentPadding:
                            EdgeInsets.only(left: 20, top: 10, bottom: 10),
                        labelText: "Введите номер телефона",
                        hintText: "+7 777 777-77-77",
                        labelStyle: TextStyle(color: Colors.black54),
                        hintStyle: TextStyle(color: Colors.grey),
                        // prefixIcon: Icon(
                        //   Icons.phone,
                        //   color: ThemeColors.grey,
                        // ),
                        border: InputBorder.none
                        // border: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(12),
                        // ),
                        // enabledBorder: OutlineInputBorder(
                        //     borderRadius: BorderRadius.circular(12),
                        //     borderSide: BorderSide(color: ThemeColors.grey)),
                        // focusedBorder: OutlineInputBorder(
                        //   borderRadius: BorderRadius.circular(12),
                        //   borderSide: BorderSide(
                        //     color: ThemeColors
                        //         .orange, // Цвет границы, когда поле в фокусе
                        //     width: 2.0,
                        //   ),
                        // ),
                        ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Введите номер телефона";
                      }
                      if (value.length != 16) {
                        return "Введите корректный номер";
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _isLoading
                        ? null
                        : _handleSendSms, // Блокировка кнопки во время загрузки
                    style: ElevatedButton.styleFrom(
                        backgroundColor: ThemeColors.orange,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0),
                    child: _isLoading
                        ? SizedBox(
                            width: 24,
                            height: 24,
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(Colors.white),
                              strokeWidth: 2.5,
                            ),
                          )
                        : Text(
                            "Отправить SMS",
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
