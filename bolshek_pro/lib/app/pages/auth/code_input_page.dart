import 'dart:async';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/app/widgets/widget_from_bolshek/theme_text_style.dart';
import 'package:bolshek_pro/core/models/auth_response.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:provider/provider.dart';

class CodeInputPage extends StatefulWidget {
  final bool isRegistered;
  final String otpId;
  final String phoneNumber;

  CodeInputPage({
    required this.isRegistered,
    required this.otpId,
    required this.phoneNumber,
  });

  @override
  _CodeInputPageState createState() => _CodeInputPageState();
}

class _CodeInputPageState extends State<CodeInputPage> {
  final TextEditingController _codeController = TextEditingController();
  final AuthService _authService = AuthService();
  StreamController<ErrorAnimationType>? errorController =
      StreamController<ErrorAnimationType>();
  String currentText = "";
  Timer? _timer;
  int _start = 60;
  bool _isLoading = false;
  late String _otpId; // Хранение текущего otpId

  @override
  void initState() {
    super.initState();
    startTimer();
    _otpId = widget.otpId; // Инициализация начальным значением
  }

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
          timer.cancel();
        } else {
          setState(() {
            _start--;
          });
        }
      },
    );
  }

  Future<void> _sendSms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Повторно вызываем fetchOtpId для переотправки SMS
      final response =
          await _authService.fetchOtpId(context, widget.phoneNumber);
      final newOtpId = response['otpId'] as String;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SMS-код успешно отправлен'),
          backgroundColor: Colors.green,
        ),
      );

      // Сбрасываем таймер и запускаем снова
      setState(() {
        _otpId = newOtpId;

        _start = 60;
      });
      startTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Ошибка при отправке SMS: $e'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _verifyCode() async {
    if (currentText.length == 6) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Вызов метода signWithPhone из AuthService
        final response = await _authService.signWitpPhone(
          context,
          _otpId,
          currentText,
        );

        // Преобразование ответа в AuthResponse
        final authResponse = AuthResponse.fromJson(response);

        // Сохранение данных авторизации в GlobalProvider
        context.read<GlobalProvider>().setAuthData(authResponse);

        // Безвозвратный переход на главный экран
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainControllerNavigator()),
          (route) => false, // Удаляет все предыдущие маршруты
        );
      } catch (e) {
        String errorMessage = 'Ошибка регистрации: $e';

        // Обработка ошибок
        if (e.toString().contains('code: 10002')) {
          errorMessage =
              'Ваш аккаунт еще не активен. Пожалуйста, ждите ответа менеджера.';
        }
        if (errorController?.isClosed == false) {
          errorController?.add(ErrorAnimationType.shake);
        }
        if (e.toString().contains('otp_invalid: Invalid OTP code')) {
          errorMessage = 'Неправильный SMS-код. Попробуйте снова.';
        }
        if (e.toString().contains('otp_invalid: OTP is used or expired')) {
          errorMessage = 'Слишком много попыток. Попробуйте позже.';
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(errorMessage)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (errorController?.isClosed == false) {
        errorController?.add(ErrorAnimationType.shake);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Введите SMS-код"),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Text(
                "Подтверждение номера",
                style: ThemeTextMontserratBold.size21,
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Text(
                "Мы отправили код на ваш номер телефона.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                appContext: context,
                length: 6,
                animationType: AnimationType.fade,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  inactiveFillColor: Colors.grey[100],
                  activeFillColor: Colors.white,
                  selectedFillColor: Colors.grey[100],
                  inactiveColor: Colors.grey[100],
                  activeColor: Colors.orange[100],
                  selectedColor: Colors.orange[100],
                ),
                cursorColor: Colors.black,
                animationDuration: const Duration(milliseconds: 300),
                enableActiveFill: true,
                errorAnimationController: errorController,
                controller: _codeController,
                keyboardType: TextInputType.number,
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 2),
                    color: Colors.black12,
                    blurRadius: 5,
                  )
                ],
                onChanged: (value) {
                  currentText = value;
                },
                beforeTextPaste: (text) {
                  return true;
                },
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _verifyCode,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ThemeColors.orange,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: Text(
                    "Подтвердить",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 15),
              if (_start > 0)
                Text(
                  "Отправить повторно через $_start сек.",
                  style: TextStyle(color: Colors.grey),
                )
              else
                GestureDetector(
                  onTap: _isLoading ? null : _sendSms,
                  child: Text(
                    "Отправить код снова",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
