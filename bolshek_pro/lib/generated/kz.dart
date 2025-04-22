import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class KzMaterialLocalizationsDelegate
    extends LocalizationsDelegate<MaterialLocalizations> {
  const KzMaterialLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => locale.languageCode == 'kk';

  @override
  Future<MaterialLocalizations> load(Locale locale) async {
    // Здесь возвращаем локализацию для ru в качестве fallback
    return await GlobalMaterialLocalizations.delegate.load(const Locale('ru'));
  }

  @override
  bool shouldReload(LocalizationsDelegate<MaterialLocalizations> old) => false;
}
