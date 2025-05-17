import 'dart:async';

import 'package:bolshek_pro/app/widgets/main_controller.dart';
import 'package:bolshek_pro/app/widgets/widget_from_bolshek/theme_text_style.dart';
import 'package:bolshek_pro/core/models/auth_response.dart';
import 'package:bolshek_pro/core/service/auth_service.dart';
import 'package:bolshek_pro/core/utils/provider.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:bolshek_pro/generated/l10n.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:provider/provider.dart';

/// Экран ввода SMS-кода.  
/// После успешной верификации выполняет всю «прелоадерную» инициализацию,
/// а затем переводит пользователя в [MainControllerNavigator].
class CodeInputPage extends StatefulWidget {
  const CodeInputPage({
    super.key,
    required this.isRegistered,
    required this.otpId,
    required this.phoneNumber,
  });

  final bool isRegistered;
  final String otpId;
  final String phoneNumber;

  @override
  State<CodeInputPage> createState() => _CodeInputPageState();
}

class _CodeInputPageState extends State<CodeInputPage> {
  final TextEditingController _codeController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final StreamController<ErrorAnimationType> _errorController =
      StreamController<ErrorAnimationType>();
  final AuthService _authService = AuthService();

  String _currentText = '';
  late String _otpId;

  Timer? _timer;
  int _secondsLeft = 60;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _otpId = widget.otpId;
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    _errorController.close();
    _pinFocusNode.dispose();
    _codeController.dispose();
    super.dispose();
  }

  /* ─────────────────────────  Таймер  ───────────────────────── */

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    _timer?.cancel();
    _timer = Timer.periodic(oneSec, (t) {
      if (_secondsLeft == 0) {
        t.cancel();
      } else {
        setState(() => _secondsLeft--);
      }
    });
  }

  /* ─────────────────────  Повторная отправка SMS  ───────────────────── */

  Future<void> _sendSmsAgain() async {
    setState(() => _isLoading = true);

    try {
      final resp = await _authService.fetchOtpId(context, widget.phoneNumber);
      _otpId = resp['otpId'] as String;

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green,
        content: Text(S.of(context).smsSentMessageSuccess),
      ));

      setState(() {
        _secondsLeft = 60;
      });
      _startTimer();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.red,
        content: Text(S.of(context).smsSentMessageError(e.toString())),
      ));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /* ─────────────────────  Пост-авторизационный bootstrap  ───────────────────── */

  Future<void> _postLoginInit(AuthResponse auth) async {
    final global = context.read<GlobalProvider>();

    // сохраняем auth-данные в провайдер и SharedPreferences
    global.setAuthData(auth);

    // подтягиваем расширенную сессию
    final session = await AuthService().fetchAuthSession(context);

    global
      ..setPermissions(session.permissions ?? [])
      ..getWarehouseId(session.user?.warehouses?.first.id ?? '')
      ..getManager(session.user?.roles?.first.role?.name ?? '')
      ..setOrganizationName(session.user?.organization?.name ?? 'Без названия');
  }

  /* ─────────────────────  Проверка введённого кода  ───────────────────── */

  Future<void> _verifyCode() async {
    if (_currentText.length != 6) {
      _errorController.add(ErrorAnimationType.shake);
      return;
    }

    setState(() => _isLoading = true);

    try {
      final raw = await _authService.signWitpPhone(
        context,
        _otpId,
        _currentText,
      );
      final auth = AuthResponse.fromJson(raw);

      await _postLoginInit(auth);

      // успешный вход в приложение
      if (!mounted) return;
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const MainControllerNavigator()),
        (_) => false,
      );
    } catch (e) {
      _handleVerifyError(e);
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _handleVerifyError(Object e) {
    String msg = S.of(context).registerError(e.toString());

    if (e.toString().contains('code: 9040') ||
        e.toString().contains('User account deactivated')) {
      msg = S.of(context).accountNotActive;
    } else if (e.toString().contains('otp_invalid: Invalid OTP code')) {
      msg = S.of(context).invalidOtp;
    } else if (e.toString().contains('otp_invalid: OTP is used or expired')) {
      msg = S.of(context).otpExpired;
    }

    _errorController.add(ErrorAnimationType.shake);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  /* ──────────────────────────  UI  ────────────────────────── */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(S.of(context).smsCodeInputTitle),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 30),
              Text(
                S.of(context).phoneConfirmation,
                style: ThemeTextMontserratBold.size21,
              ),
              const SizedBox(height: 10),
              Text(
                S.of(context).smsSentText,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 30),

              /* ─── PIN коды ─── */
              PinCodeTextField(
                appContext: context,
                focusNode: _pinFocusNode,
                length: 6,
                autoFocus: true,
                controller: _codeController,
                errorAnimationController: _errorController,
                keyboardType: TextInputType.number,
                animationType: AnimationType.fade,
                animationDuration: const Duration(milliseconds: 300),
                beforeTextPaste: (_) => true,
                onChanged: (v) => _currentText = v,
                enableActiveFill: true,
                cursorColor: Colors.black,
                pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(10),
                  fieldHeight: 50,
                  fieldWidth: 45,
                  inactiveFillColor: Colors.grey[100],
                  inactiveColor: Colors.grey[100],
                  selectedFillColor: Colors.grey[100],
                  selectedColor: Colors.orange[100],
                  activeFillColor: Colors.white,
                  activeColor: Colors.orange[100],
                ),
                boxShadows: const [
                  BoxShadow(
                    offset: Offset(0, 2),
                    blurRadius: 5,
                    color: Colors.black12,
                  )
                ],
              ),
              const SizedBox(height: 20),

              /* ─── Кнопка подтверждения ─── */
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
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          S.of(context).verifyButtonText,
                          style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold),
                        ),
                ),
              ),
              const SizedBox(height: 15),

              /* ─── Повторная отправка ─── */
              _secondsLeft > 0
                  ? Text(
                      S.of(context).resendTimerText(_secondsLeft),
                      style: const TextStyle(color: Colors.grey),
                    )
                  : GestureDetector(
                      onTap: _isLoading ? null : _sendSmsAgain,
                      child: Text(
                        S.of(context).resendText,
                        style: const TextStyle(
                            fontSize: 16,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600),
                      ),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
