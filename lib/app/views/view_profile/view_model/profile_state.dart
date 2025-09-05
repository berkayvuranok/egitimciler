import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String? email;
  final String? username;
  final bool isLoading;
  final String? errorMessage;

  const ProfileState({
    this.email,
    this.username,
    this.isLoading = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? email,
    String? username,
    bool? isLoading,
    String? errorMessage,
  }) {
    return ProfileState(
      email: email ?? this.email,
      username: username ?? this.username,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [email, username, isLoading, errorMessage];
}
