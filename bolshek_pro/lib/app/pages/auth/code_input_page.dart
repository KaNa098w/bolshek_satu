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
import 'package:bolshek_pro/generated/l10n.dart'; // Импортируйте сгенерированные локализации

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
  final FocusNode _pinFocusNode = FocusNode();
  StreamController<ErrorAnimationType>? errorController =
      StreamController<ErrorAnimationType>();
  AuthService _authService = AuthService();
  String currentText = "";
  Timer? _timer;
  int _start = 60;
  bool _isLoading = false;
  late String _otpId;

  @override
  void initState() {
    super.initState();
    startTimer();
    _otpId = widget.otpId;
  }

  @override
  void dispose() {
    _timer?.cancel();
    errorController?.close();
    _pinFocusNode.dispose();
    _codeController.dispose();
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
      final response =
          await _authService.fetchOtpId(context, widget.phoneNumber);
      final newOtpId = response['otpId'] as String;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
              S.of(context).smsSentMessageSuccess), // Локализованное сообщение
          backgroundColor: Colors.green,
        ),
      );

      setState(() {
        _otpId = newOtpId;
        _start = 60;
      });
      startTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(S.of(context).smsSentMessageError(e.toString())),
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
        final response = await _authService.signWitpPhone(
          context,
          _otpId,
          currentText,
        );

        final authResponse = AuthResponse.fromJson(response);

        context.read<GlobalProvider>().setAuthData(authResponse);

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainControllerNavigator()),
          (route) => false,
        );
      } catch (e) {
        String errorMessage = S.of(context).registerError(e.toString());

        if (e.toString().contains('code: 9040') ||
            e.toString().contains('User account deactivated')) {
          errorMessage = S.of(context).accountNotActive;
        }
        if (errorController?.isClosed == false) {
          errorController?.add(ErrorAnimationType.shake);
        }
        if (e.toString().contains('otp_invalid: Invalid OTP code')) {
          errorMessage = S.of(context).invalidOtp;
        }
        if (e.toString().contains('otp_invalid: OTP is used or expired')) {
          errorMessage = S.of(context).otpExpired;
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
        title: Text(
            S.of(context).smsCodeInputTitle), // например, "Введите SMS-код"
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
                S
                    .of(context)
                    .phoneConfirmation, // например, "Подтверждение номера"
                style: ThemeTextMontserratBold.size21,
                maxLines: 1,
              ),
              const SizedBox(height: 10),
              Text(
                S
                    .of(context)
                    .smsSentText, // например, "Мы отправили код на ваш номер телефона."
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),
              PinCodeTextField(
                appContext: context,
                autoFocus: true,
                focusNode: _pinFocusNode,
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
                beforeTextPaste: (text) => true,
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
                  ),
                  child: Text(
                    S.of(context).verifyButtonText, // "Подтвердить"
                    style: const TextStyle(
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
                  S.of(context).resendTimerText(
                      _start), // например, "Отправить повторно через {seconds} сек."
                  style: const TextStyle(color: Colors.grey),
                )
              else
                GestureDetector(
                  onTap: _isLoading ? null : _sendSms,
                  child: Text(
                    S.of(context).resendText, // "Отправить код снова"
                    style: const TextStyle(
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
