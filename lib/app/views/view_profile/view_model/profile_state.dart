import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

class ProfileState extends Equatable {
  final String fullName;
  final String email;
  final String role;
  final String gender;
  final String educationLevel;
  final String school;

  final String lessonTitle;
  final String lessonDescription;
  final String lessonPrice;
  final String lessonDuration;
  final String lessonImageUrl;
  final XFile? lessonImage;

  final bool isSaving;
  final bool isSuccess;
  final String? errorMessage;

  const ProfileState({
    this.fullName = '',
    this.email = '',
    this.role = '',
    this.gender = '',
    this.educationLevel = '',
    this.school = '',
    this.lessonTitle = '',
    this.lessonDescription = '',
    this.lessonPrice = '',
    this.lessonDuration = '',
    this.lessonImageUrl = '',
    this.lessonImage,
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
    String? lessonTitle,
    String? lessonDescription,
    String? lessonPrice,
    String? lessonDuration,
    String? lessonImageUrl,
    XFile? lessonImage,
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
      lessonTitle: lessonTitle ?? this.lessonTitle,
      lessonDescription: lessonDescription ?? this.lessonDescription,
      lessonPrice: lessonPrice ?? this.lessonPrice,
      lessonDuration: lessonDuration ?? this.lessonDuration,
      lessonImageUrl: lessonImageUrl ?? this.lessonImageUrl,
      lessonImage: lessonImage ?? this.lessonImage,
      isSaving: isSaving ?? this.isSaving,
      isSuccess: isSuccess ?? this.isSuccess,
      errorMessage: errorMessage ?? this.errorMessage,
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
        lessonTitle,
        lessonDescription,
        lessonPrice,
        lessonDuration,
        lessonImageUrl,
        lessonImage,
        isSaving,
        isSuccess,
        errorMessage,
      ];
}