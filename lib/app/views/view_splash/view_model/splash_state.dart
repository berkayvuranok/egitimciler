import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  final bool isLoading;
  final bool navigateToHome;
  final bool navigateToOnboarding;

  const SplashState({
    this.isLoading = true,
    this.navigateToHome = false,
    this.navigateToOnboarding = false,
  });

  SplashState copyWith({
    bool? isLoading,
    bool? navigateToHome,
    bool? navigateToOnboarding,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      navigateToHome: navigateToHome ?? this.navigateToHome,
      navigateToOnboarding: navigateToOnboarding ?? this.navigateToOnboarding,
    );
  }

  @override
  List<Object?> get props => [isLoading, navigateToHome, navigateToOnboarding];
}
