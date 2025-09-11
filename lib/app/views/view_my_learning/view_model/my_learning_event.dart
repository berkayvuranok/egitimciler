import 'package:equatable/equatable.dart';

abstract class MyLearningEvent extends Equatable {
  const MyLearningEvent();

  @override
  List<Object?> get props => [];
}

// Kullanıcının kurslarını yüklemek için
class LoadMyCourses extends MyLearningEvent {}

// Kullanıcıya kurs eklemek için
class AddCourse extends MyLearningEvent {
  final Map<String, dynamic> course;

  const AddCourse(this.course);

  @override
  List<Object?> get props => [course];
}

// Kullanıcıdan kurs silmek için
class RemoveCourse extends MyLearningEvent {
  final int courseId;

  const RemoveCourse(this.courseId);

  @override
  List<Object?> get props => [courseId];
}
