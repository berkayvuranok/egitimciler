import 'package:equatable/equatable.dart';

class OnboardingState extends Equatable {
  final int currentPage;
  final bool isCompleted;

  const OnboardingState({
    this.currentPage = 0,
    this.isCompleted = false,
  });

  OnboardingState copyWith({
    int? currentPage,
    bool? isCompleted,
  }) {
    return OnboardingState(
      currentPage: currentPage ?? this.currentPage,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  @override
  List<Object?> get props => [currentPage, isCompleted];
}
