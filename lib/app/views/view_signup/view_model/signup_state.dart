import 'package:equatable/equatable.dart';

class SignUpState extends Equatable {
  final String email;
  final String password;
  final String confirmPassword;
  final String fullName;
  final bool isSubmitting;
  final bool isSuccess;
  final String? errorMessage;

  const SignUpState({
    this.email = '',
    this.password = '',
    this.confirmPassword = '',
    this.fullName = '',
    this.isSubmitting = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  SignUpState copyWith({
    String? email,
    String? password,
    String? confirmPassword,
    String? fullName,
    bool? isSubmitting,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return SignUpState(
      email: email ?? this.email,
      password: password ?? this.password,
      confirmPassword: confirmPassword ?? this.confirmPassword,
      fullName: fullName ?? this.fullName,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  bool get isFormValid =>
      email.isNotEmpty &&
      password.isNotEmpty &&
      confirmPassword.isNotEmpty &&
      fullName.isNotEmpty &&
      password == confirmPassword;

  @override
  List<Object?> get props => [
    email,
    password,
    confirmPassword,
    fullName,
    isSubmitting,
    isSuccess,
    errorMessage,
  ];
}