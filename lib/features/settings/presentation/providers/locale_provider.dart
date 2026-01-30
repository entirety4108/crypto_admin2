import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supported locales
const supportedLocales = [
  Locale('ja'),
  Locale('en'),
];

/// Locale provider
final localeProvider = StateNotifierProvider<LocaleNotifier, Locale>((ref) {
  return LocaleNotifier();
});

/// Locale notifier
class LocaleNotifier extends StateNotifier<Locale> {
  LocaleNotifier() : super(const Locale('ja'));

  void setLocale(Locale locale) {
    if (supportedLocales.contains(locale)) {
      state = locale;
    }
  }

  void toggleLocale() {
    if (state.languageCode == 'ja') {
      state = const Locale('en');
    } else {
      state = const Locale('ja');
    }
  }
}
