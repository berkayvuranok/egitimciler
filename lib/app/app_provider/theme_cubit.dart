import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// ThemeCubit: Uygulamanın temasını yönetir (light <-> dark)
class ThemeCubit extends Cubit<ThemeMode> {
  ThemeCubit() : super(ThemeMode.light);

  /// Tema değiştirme (dark <-> light)
  void toggleTheme() {
    emit(state == ThemeMode.light ? ThemeMode.dark : ThemeMode.light);
  }
}
