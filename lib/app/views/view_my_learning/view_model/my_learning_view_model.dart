import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'my_learning_event.dart';
import 'my_learning_state.dart';

class MyLearningViewModel extends Bloc<MyLearningEvent, MyLearningState> {
  final SupabaseClient supabase;

  MyLearningViewModel(this.supabase) : super(MyLearningLoading()) {
    on<LoadMyCourses>(_onLoadMyCourses);
    on<AddCourse>(_onAddCourse);
    on<RemoveCourse>(_onRemoveCourse);
  }

  // Kullanıcının kurslarını yükleme
  Future<void> _onLoadMyCourses(LoadMyCourses event, Emitter<MyLearningState> emit) async {
    emit(MyLearningLoading());
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(MyLearningError("User not logged in"));
        return;
      }

      final data = await supabase
          .from('user_courses')
          .select('course:products(*)')
          .eq('user_id', user.id);

      final courses = (data as List<dynamic>)
          .where((e) => e['course'] != null)
          .map((e) => Map<String, dynamic>.from(e['course']))
          .toList();

      emit(MyLearningLoaded(courses));
    } catch (e) {
      emit(MyLearningError("Failed to load courses: $e"));
    }
  }

  // Kurs ekleme (upsert ile duplicate engelleme)
  Future<void> _onAddCourse(AddCourse event, Emitter<MyLearningState> emit) async {
  try {
    final user = supabase.auth.currentUser;
    if (user == null) {
      emit(MyLearningError("User not logged in"));
      return;
    }

    // Tek conflict sütunu kullanıyoruz (course_id)
    await supabase.from('user_courses').upsert({
      'user_id': user.id,
      'course_id': event.course['id'],
      'created_at': DateTime.now().toIso8601String(),
    }, onConflict: 'course_id'); // <-- BURASI artık String

    add(LoadMyCourses());
  } catch (e) {
    emit(MyLearningError("Failed to add course: $e"));
  }
}


  // Kurs silme
  Future<void> _onRemoveCourse(RemoveCourse event, Emitter<MyLearningState> emit) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase
          .from('user_courses')
          .delete()
          .eq('user_id', user.id)
          .eq('course_id', event.courseId);

      add(LoadMyCourses());
    } catch (e) {
      emit(MyLearningError("Failed to remove course: $e"));
    }
  }
}
