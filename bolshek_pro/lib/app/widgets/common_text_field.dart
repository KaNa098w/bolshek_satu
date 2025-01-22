import 'package:bolshek_pro/app/widgets/widget_from_bolshek/theme_text_style.dart';
import 'package:bolshek_pro/core/utils/constants.dart';
import 'package:bolshek_pro/core/utils/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:translit/translit.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class CommonTextField extends StatelessWidget {
  final TextEditingController controller;
  final bool withSearch;
  final String hintText;
  final String? preffixText;
  final Function(String)? onChanged;
  final TextInputType? keyboardType;
  final FocusNode? focusNode;
  final bool? showCursor;
  final bool readOnly;
  final Function()? onTap;
  final int? maxLine;
  final List<TextInputFormatter>? inputFormatters;
  final bool isDense;
  final double? height;
  final String? Function(String?)? validator;
  final Function(String)? onFieldSubmitted;
  final int maxLines;
  final Color? fillColor; // Новый параметр для цвета фона
  final List<String>? suggestions; // Список для автозаполнения

  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.onChanged,
    this.withSearch = true,
    this.preffixText,
    this.keyboardType,
    this.focusNode,
    this.readOnly = false,
    this.showCursor,
    this.onTap,
    this.maxLine,
    this.inputFormatters,
    this.isDense = true,
    this.height,
    this.validator,
    this.onFieldSubmitted,
    this.maxLines = 1,
    this.fillColor,
    this.suggestions,
    required int maxLength,
    required TextAlign textAlign, // Добавлен параметр
  });

  @override
  Widget build(BuildContext context) {
    final translit = Translit();

    if (suggestions != null && suggestions!.isNotEmpty) {
      // Поле с автозаполнением
      return Autocomplete<String>(
        optionsBuilder: (TextEditingValue textEditingValue) {
          if (textEditingValue.text.isEmpty) {
            return const Iterable<String>.empty();
          }

          final query = textEditingValue.text.toLowerCase();
          final transliteratedQuery = translit.toTranslit(source: query);

          return suggestions!.where((suggestion) {
            final suggestionLowerCase = suggestion.toLowerCase();
            final transliteratedSuggestion =
                translit.toTranslit(source: suggestionLowerCase);

            return transliteratedSuggestion.contains(transliteratedQuery);
          });
        },
        onSelected: (String selection) {
          controller.text = selection;
        },
        fieldViewBuilder: (BuildContext context,
            TextEditingController textEditingController,
            FocusNode focusNode,
            VoidCallback onFieldSubmitted) {
          // Синхронизируем внутренний контроллер с внешним
          textEditingController.text = controller.text;
          textEditingController.addListener(() {
            controller.text = textEditingController.text;
          });

          return _buildTextField(
            context,
            textEditingController,
            focusNode,
          );
        },
        optionsViewBuilder: (BuildContext context,
            AutocompleteOnSelected<String> onSelected,
            Iterable<String> options) {
          return Align(
            alignment: Alignment.topLeft,
            child: Material(
              elevation: 3,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 252),
                  child: SingleChildScrollView(
                    child: Wrap(
                      spacing: 6.0,
                      runSpacing: 6.0,
                      children: options.map((option) {
                        return GestureDetector(
                          onTap: () => onSelected(option),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 12,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(24),
                              border: Border.all(color: ThemeColors.grey),
                              color: Colors.white,
                            ),
                            child: Text(
                              option,
                              style: ThemeTextInterMedium.size15.copyWith(
                                color: ThemeColors.grey5,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      // Стандартное текстовое поле
      return _buildTextField(context, controller, focusNode);
    }
  }

  Widget _buildTextField(BuildContext context, TextEditingController controller,
      FocusNode? focusNode) {
    return TextFormField(
      maxLines: maxLines,
      style: ThemeTextInterMedium.size15.copyWith(
        color: ThemeColors.black,
      ),
      focusNode: focusNode ?? FocusNode(),
      keyboardType: keyboardType,
      onChanged: onChanged,
      validator: validator,
      inputFormatters: inputFormatters,
      readOnly: readOnly,
      showCursor: showCursor,
      controller: controller,
      onTap: onTap,
      decoration: InputDecoration(
        isDense: isDense,
        hintText: hintText,
        filled: true,
        fillColor: fillColor ?? ThemeColors.grey2,
        contentPadding: EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 10,
        ),
        hintStyle: ThemeTextInterMedium.size15.copyWith(
          fontSize: 17,
          color: ThemeColors.grey3,
        ),
        prefixIconConstraints: withSearch
            ? BoxConstraints(
                maxHeight: 24,
                maxWidth: 41,
              )
            : null,
        prefixText: preffixText,
        prefixStyle: ThemeTextInterRegular.size11.copyWith(
          color: ThemeColors.grey3,
          fontSize: 12,
        ),
        prefixIcon: withSearch
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: SvgPicture.asset(
                  "assets/svg/search.svg",
                  width: 17,
                  height: 17,
                ),
              )
            : null,
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThemeColors.transparent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThemeColors.transparent),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: ThemeColors.transparent),
        ),
      ),
    );
  }
}

class FormattedNumberFeild extends StatelessWidget {
  const FormattedNumberFeild({
    Key? key,
    required this.onChange,
    this.label = 'Phone',
    this.initialValue,
    this.format = "+# (###) ### ####",
    required this.controller,
  }) : super(key: key);
  final Function(String) onChange;
  final String format;
  final String label;
  final String? initialValue;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      child: TextFormField(
        controller: controller,
        style: ThemeTextInterMedium.size15.copyWith(
          color: ThemeColors.black,
        ),
        cursorColor: Colors.black,
        maxLines: 1,
        // initialValue: initialValue != null ? getInitialFormattedNumber(format, initialValue!) : null,
        keyboardType: TextInputType.number,
        inputFormatters: [],
        validator: (value) {
          if (value == null) {
            return null;
          }
          if (value.length < 11) {
            return Constants.pleaseInputPhone;
          }
          return null;
        },
        decoration: InputDecoration(
          hintStyle: ThemeTextInterMedium.size15.copyWith(
            color: ThemeColors.grey3,
          ),
          fillColor: Colors.white,
          counterText: "",
          filled: true,
          isDense: true,
          labelText: label,
          enabledBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(
              color: Colors.grey,
            ),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.blueGrey),
          ),
          errorBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            borderSide: BorderSide(color: Colors.red),
          ),
        ),
        onChanged: onChange,
      ),
    );
  }
}

class MaskedTextInputFormatter extends TextInputFormatter {
  final String mask;
  final String separator;
  MaskedTextInputFormatter({
    required this.mask,
    required this.separator,
  });
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    if (newValue.text.isNotEmpty) {
      if (newValue.text.length > oldValue.text.length) {
        if (newValue.text.length > mask.length) return oldValue;
        if (newValue.text.length < mask.length &&
            mask[newValue.text.length - 1] == separator) {
          return TextEditingValue(
            text:
                '${oldValue.text}$separator${newValue.text.substring(newValue.text.length - 1)}',
            selection: TextSelection.collapsed(
              offset: newValue.selection.end + 1,
            ),
          );
        }
      }
    }
    return newValue;
  }
}

getInitialFormattedNumber(String format, String str) {
  if (str == '') return '';
  var mask = format;
  str.split("").forEach((item) => mask = mask.replaceFirst('x', item));
  return mask.replaceAll('x', "");
}
