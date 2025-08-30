// splash_view_model.dart
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_event.dart';
import 'splash_state.dart';

class SplashViewModel extends Bloc<SplashEvent, SplashState> {
  SplashViewModel() : super(const SplashState()) {
    on<SplashStarted>(_onSplashStarted);
  }

  Future<void> _onSplashStarted(SplashStarted event, Emitter<SplashState> emit) async {
    // Splash ekranını 2 saniye göster
    await Future.delayed(const Duration(seconds: 2));

    // SharedPreferences üzerinden onboarding gösterilip gösterilmediğini kontrol et
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingShown = prefs.getBool('onboardingShown') ?? false;

    if (!onboardingShown) {
      // Onboarding daha önce gösterilmediyse, navigateToOnboarding true yap
      emit(state.copyWith(isLoading: false, navigateToOnboarding: true));
    } else {
      // Onboarding daha önce gösterildiyse, doğrudan ana ekrana git
      emit(state.copyWith(isLoading: false, navigateToHome: true));
    }
  }
}

