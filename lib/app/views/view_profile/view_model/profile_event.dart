import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object?> get props => [];
}

// Profil yükleme
class LoadProfile extends ProfileEvent {
  final String? userId;
  final String? email;

  const LoadProfile({this.userId, this.email});

  @override
  List<Object?> get props => [userId, email];
}

// Form alanı değişiklikleri
class ProfileFieldChanged extends ProfileEvent {
  final String? role;
  final String? gender;
  final String? educationLevel;
  final String? school;
  final String? fullName;
  final String? lessonTitle;
  final String? lessonDescription;
  final String? lessonPrice;
  final String? lessonDuration; // Yeni eklenen alan

  const ProfileFieldChanged({
    this.role,
    this.gender,
    this.educationLevel,
    this.school,
    this.fullName,
    this.lessonTitle,
    this.lessonDescription,
    this.lessonPrice,
    this.lessonDuration, // Yeni eklenen alan
  });

  @override
  List<Object?> get props => [
        role,
        gender,
        educationLevel,
        school,
        fullName,
        lessonTitle,
        lessonDescription,
        lessonPrice,
        lessonDuration, // Yeni eklenen alan
      ];
}

// Profil ve ürün kaydet
class SaveProfile extends ProfileEvent {
  final String? lessonTitle;
  final String? lessonDescription;
  final String? lessonPrice;
  final String? lessonDuration; // Yeni eklenen alan
  final XFile? lessonImage;

  const SaveProfile({
    this.lessonTitle,
    this.lessonDescription,
    this.lessonPrice,
    this.lessonDuration, // Yeni eklenen alan
    this.lessonImage,
  });

  @override
  List<Object?> get props => [
        lessonTitle,
        lessonDescription,
        lessonPrice,
        lessonDuration, // Yeni eklenen alan
        lessonImage,
      ];
}