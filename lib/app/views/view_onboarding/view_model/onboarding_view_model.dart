import 'package:flutter_bloc/flutter_bloc.dart';
import 'onboarding_event.dart';
import 'onboarding_state.dart';

class OnboardingViewModel extends Bloc<OnboardingEvent, OnboardingState> {
  OnboardingViewModel() : super(const OnboardingState()) {
    on<OnboardingNext>(_onNext);
    on<OnboardingPrevious>(_onPrevious);
    on<OnboardingSkip>(_onSkip);
    on<OnboardingComplete>(_onComplete);
  }

  void _onNext(OnboardingNext event, Emitter<OnboardingState> emit) {
    if (state.currentPage < 2) { // toplam 3 sayfa (0,1,2)
      emit(state.copyWith(currentPage: state.currentPage + 1));
    }
  }

  void _onPrevious(OnboardingPrevious event, Emitter<OnboardingState> emit) {
    if (state.currentPage > 0) {
      emit(state.copyWith(currentPage: state.currentPage - 1));
    }
  }

  void _onSkip(OnboardingSkip event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(isCompleted: true));
  }

  void _onComplete(OnboardingComplete event, Emitter<OnboardingState> emit) {
    emit(state.copyWith(isCompleted: true));
  }
}
