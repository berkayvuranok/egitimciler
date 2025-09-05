import 'package:equatable/equatable.dart';

abstract class ProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadUserProfile extends ProfileEvent {}

class LogoutRequested extends ProfileEvent {}
