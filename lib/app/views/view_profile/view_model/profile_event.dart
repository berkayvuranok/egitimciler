import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  const ProfileEvent();
  @override
  List<Object?> get props => [];
}

class LoadProfile extends ProfileEvent {
  final String? userId;
  final String? email;

  const LoadProfile({this.userId, this.email});

  @override
  List<Object?> get props => [userId, email];
}

class ProfileFieldChanged extends ProfileEvent {
  final String? role;
  final String? gender;
  final String? educationLevel;
  final String? school;

  const ProfileFieldChanged({this.role, this.gender, this.educationLevel, this.school});

  @override
  List<Object?> get props => [role, gender, educationLevel, school];
}

class SaveProfile extends ProfileEvent {
  const SaveProfile();
}
