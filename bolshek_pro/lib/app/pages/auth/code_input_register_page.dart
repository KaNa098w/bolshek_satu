import 'dart:async';
import 'package:bolshek_pro/app/pages/auth/auth_main_page.dart';
import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/app/widgets/widget_from_bolshek/theme_text_style.dart';
import 'package:bolshek_pro/core/models/auth_response.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:provider/provider.dart';

class CodeInputRegister extends StatefulWidget {
  final String otpId;
  final String phoneNumber;
  final String firstName;
  final String lastName;
  final double? longitude;
  final double? latitude;
  final String address;
  final String shopName;
  final List<String> selectedCategoryIds;
  final List<String> selectedBrandIds;

  CodeInputRegister({
    required this.otpId,
    required this.phoneNumber,
    required this.firstName,
    required this.lastName,
    this.longitude,
    this.latitude,
    required this.address,
    required this.shopName,
    required this.selectedCategoryIds,
    required this.selectedBrandIds,
  });

  @override
  _CodeInputRegisterState createState() => _CodeInputRegisterState();
}

class _CodeInputRegisterState extends State<CodeInputRegister> {
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
    _otpId = widget.otpId; // Инициализация начальным значением
    startTimer();
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

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false, // Запрет закрытия окна по клику вне его
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
                SvgPicture.asset(
                  'assets/svg/check_icon.svg',
                  width: 59, // Задайте ширину
                  height: 59, // Задайте высоту
                ),
                const SizedBox(height: 16),
                Text(
                  "Ваш запрос на\nрегистрацию отправлен!",
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
                  "Пожалуйста, ожидайте ответа\nот менеджера.",
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
                          builder: (context) => AuthMainScreen(),
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
                      "Хорошо",
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

  Future<void> _registerUser() async {
    try {
      final response = await _authService.sendRegister(
        context,
        _otpId,
        _codeController.text,
        widget.firstName,
        widget.lastName,
        widget.longitude ?? 0.0,
        widget.latitude ?? 0.0,
        widget.address,
        widget.shopName,
        widget.selectedCategoryIds.toList(),
        widget.selectedBrandIds.toList(),
      );

      if (response != null) {
        _showSuccessDialog();
      }
    } catch (e) {
      String errorMessage = 'Ошибка регистрации: $e';

      if (e.toString().contains('otp_invalid: Invalid OTP code')) {
        errorMessage = 'Неправильный SMS-код. Попробуйте снова.';
      }
      if (e.toString().contains('otp_invalid: OTP is used or expired')) {
        errorMessage = 'Слишком много попыток. Попробуйте позже.';
      }
      if (e
          .toString()
          .contains('user_already_registered: User already registered')) {
        errorMessage =
            'Магазин "${widget.shopName}" уже существует. Придумайте другое.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    }
  }

  Future<void> _sendSms() async {
    setState(() {
      _isLoading = true;
    });

    try {
      String phoneNumber = widget.phoneNumber.replaceAll(RegExp(r'[^\d+]'), '');
      final response = await _authService.fetchOtpId(context, phoneNumber);
      final newOtpId = response['otpId'] as String;

      // Обновляем _otpId с новым значением
      setState(() {
        _otpId = newOtpId;
        _start = 60; // Перезапуск таймера
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('SMS-код успешно отправлен'),
          backgroundColor: Colors.green,
        ),
      );

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
    if (_isLoading) return; // Предотвращаем повторное нажатие во время загрузки

    if (currentText.length == 6) {
      setState(() {
        _isLoading = true;
      });

      try {
        await _registerUser();
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Ошибка подтверждения: ${e.toString().replaceAll('Exception: ', '')}',
            ),
            backgroundColor: Colors.red,
          ),
        );
        if (errorController?.isClosed == false) {
          errorController?.add(ErrorAnimationType.shake);
        }
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
                "Мы отправили код на номер \n${widget.phoneNumber}.",
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
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          height: 24,
                          width: 24,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          "Подтвердить",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
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