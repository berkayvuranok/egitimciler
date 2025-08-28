// splash_state.dart
import 'package:equatable/equatable.dart';

class SplashState extends Equatable {
  final bool isLoading;
  final bool navigateToHome;

  const SplashState({
    this.isLoading = true,
    this.navigateToHome = false,
  });

  SplashState copyWith({
    bool? isLoading,
    bool? navigateToHome,
  }) {
    return SplashState(
      isLoading: isLoading ?? this.isLoading,
      navigateToHome: navigateToHome ?? this.navigateToHome,
    );
  }

  @override
  List<Object?> get props => [isLoading, navigateToHome];
}
