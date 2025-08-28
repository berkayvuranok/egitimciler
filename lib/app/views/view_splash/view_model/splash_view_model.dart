// splash_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashViewModel extends Bloc<SplashEvent, SplashState> {
  SplashViewModel() : super(const SplashState()) {
    on<SplashStarted>(_onSplashStarted);
  }

  void _onSplashStarted(SplashStarted event, Emitter<SplashState> emit) async {
    // Splash ekranı 2 saniye göster
    await Future.delayed(const Duration(seconds: 2));

    // Ana ekrana yönlendir
    emit(state.copyWith(isLoading: false, navigateToHome: true));
  }
}
