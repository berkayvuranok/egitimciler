import 'package:equatable/equatable.dart';

class ProfileState extends Equatable {
  final String fullName;
  final String email;
  final String role;
  final String gender;
  final String educationLevel;
  final String school;
  final bool isSaving;
  final bool isSuccess;
  final String? errorMessage;

  const ProfileState({
    this.fullName = "",
    this.email = "",
    this.role = "",
    this.gender = "",
    this.educationLevel = "",
    this.school = "",
    this.isSaving = false,
    this.isSuccess = false,
    this.errorMessage,
  });

  ProfileState copyWith({
    String? fullName,
    String? email,
    String? role,
    String? gender,
    String? educationLevel,
    String? school,
    bool? isSaving,
    bool? isSuccess,
    String? errorMessage,
  }) {
    return ProfileState(
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      role: role ?? this.role,
      gender: gender ?? this.gender,
      educationLevel: educationLevel ?? this.educationLevel,
      school: school ?? this.school,
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        fullName,
        email,
        role,
        gender,
        educationLevel,
        school,
        isSaving,
        isSuccess,
        errorMessage,
      ];
}
