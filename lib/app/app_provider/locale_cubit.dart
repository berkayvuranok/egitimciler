import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

class LocaleCubit extends Cubit<Locale> {
  LocaleCubit() : super(const Locale('en'));

  /// Dil değiştir
  void changeLocale(Locale newLocale) {
    emit(newLocale);
  }

  /// Kısa yol
  void toggleLocale() {
    if (state.languageCode == 'en') {
      emit(const Locale('tr'));
    } else {
      emit(const Locale('en'));
    }
  }
}
