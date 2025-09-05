import 'package:equatable/equatable.dart';

abstract class SignUpEvent extends Equatable {
  const SignUpEvent();

  @override
  List<Object?> get props => [];
}

class SignUpEmailChanged extends SignUpEvent {
  final String email;
  
  const SignUpEmailChanged(this.email);

  @override
  List<Object?> get props => [email];
}

class SignUpPasswordChanged extends SignUpEvent {
  final String password;
  
  const SignUpPasswordChanged(this.password);

  @override
  List<Object?> get props => [password];
}

class SignUpConfirmPasswordChanged extends SignUpEvent {
  final String confirmPassword;
  
  const SignUpConfirmPasswordChanged(this.confirmPassword);

  @override
  List<Object?> get props => [confirmPassword];
}

class SignUpFullNameChanged extends SignUpEvent {
  final String fullName;
  
  const SignUpFullNameChanged(this.fullName);

  @override
  List<Object?> get props => [fullName];
}

class SignUpSubmitted extends SignUpEvent {
  const SignUpSubmitted();
}