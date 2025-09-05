import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'signup_event.dart';
import 'signup_state.dart';

class SignUpViewModel extends Bloc<SignUpEvent, SignUpState> {
  SignUpViewModel() : super(const SignUpState()) {
    on<SignUpEmailChanged>(_onEmailChanged);
    on<SignUpPasswordChanged>(_onPasswordChanged);
    on<SignUpConfirmPasswordChanged>(_onConfirmPasswordChanged);
    on<SignUpFullNameChanged>(_onFullNameChanged);
    on<SignUpSubmitted>(_onSubmitted);
  }

  void _onEmailChanged(SignUpEmailChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(email: event.email));
  }

  void _onPasswordChanged(SignUpPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(password: event.password));
  }

  void _onConfirmPasswordChanged(SignUpConfirmPasswordChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(confirmPassword: event.confirmPassword));
  }

  void _onFullNameChanged(SignUpFullNameChanged event, Emitter<SignUpState> emit) {
    emit(state.copyWith(fullName: event.fullName));
  }

  Future<void> _onSubmitted(SignUpSubmitted event, Emitter<SignUpState> emit) async {
    if (!state.isFormValid) {
      emit(state.copyWith(errorMessage: 'Please fill all fields correctly'));
      return;
    }

    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      final AuthResponse response = await Supabase.instance.client.auth.signUp(
        email: state.email,
        password: state.password,
        data: {
          'full_name': state.fullName,
        },
      );

      if (response.user != null) {
        emit(state.copyWith(isSubmitting: false, isSuccess: true));
      } else {
        emit(state.copyWith(
          isSubmitting: false,
          errorMessage: 'Registration failed. Please try again.',
        ));
      }
    } catch (e) {
      emit(state.copyWith(
        isSubmitting: false,
        errorMessage: 'Registration error: $e',
      ));
    }
  }
}