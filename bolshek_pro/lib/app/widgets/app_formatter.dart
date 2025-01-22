import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

abstract class AppInputFormatters {
  static MaskTextInputFormatter phoneNumber = MaskTextInputFormatter(
    mask: '+# (###) ###-##-##',
    filter: {"#": RegExp(r'[0-9]')},
    type: MaskAutoCompletionType.eager,
  );
}
