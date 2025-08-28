// splash_event.dart
import 'package:equatable/equatable.dart';

abstract class SplashEvent extends Equatable {
  const SplashEvent();

  @override
  List<Object?> get props => [];
}

// Event: splash ekranı başladı
class SplashStarted extends SplashEvent {}
