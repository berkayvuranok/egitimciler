import 'package:equatable/equatable.dart';

abstract class MyLearningState extends Equatable {
  const MyLearningState();

  @override
  List<Object?> get props => [];
}

// Yükleniyor durumu
class MyLearningLoading extends MyLearningState {}

// Hata durumu
class MyLearningError extends MyLearningState {
  final String message;

  const MyLearningError(this.message);

  @override
  List<Object?> get props => [message];
}

// Kurslar yüklendiğinde
class MyLearningLoaded extends MyLearningState {
  final List<Map<String, dynamic>> courses;

  const MyLearningLoaded(this.courses);

  @override
  List<Object?> get props => [courses];
}
