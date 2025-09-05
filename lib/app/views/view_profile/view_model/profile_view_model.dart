import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final supabase = Supabase.instance.client;

  ProfileViewModel() : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<ProfileFieldChanged>(_onFieldChanged);
    on<SaveProfile>(_onSaveProfile);
  }

  Future<void> _onLoadProfile(
    LoadProfile event,
    Emitter<ProfileState> emit,
  ) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null && event.userId == null && event.email == null) {
        emit(state.copyWith(errorMessage: "No authenticated user or parameters provided"));
        return;
      }

      final query = supabase.from('profiles').select();

      if (event.userId != null) {
        query.eq('user_id', event.userId!);
      } else if (event.email != null) {
        query.eq('email', event.email!);
      } else {
        query.eq('user_id', user!.id);
      }

      final row = await query.maybeSingle();

      if (row == null) {
        emit(state.copyWith(errorMessage: "Profile not found"));
        return;
      }

      emit(state.copyWith(
        fullName: row['full_name'] ?? "",
        email: row['email'] ?? "",
        role: row['role'] ?? "",
        gender: row['gender'] ?? "",
        educationLevel: row['education_Level'] ?? "",
        school: row['school'] ?? "",
        errorMessage: null,
        isSuccess: false,
      ));
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onFieldChanged(
    ProfileFieldChanged event,
    Emitter<ProfileState> emit,
  ) {
    emit(state.copyWith(
      role: event.role ?? state.role,
      gender: event.gender ?? state.gender,
      educationLevel: event.educationLevel ?? state.educationLevel,
      school: event.school ?? state.school,
      isSuccess: false,
      errorMessage: null,
    ));
  }

  Future<void> _onSaveProfile(
    SaveProfile event,
    Emitter<ProfileState> emit,
  ) async {
    emit(state.copyWith(isSaving: true, isSuccess: false, errorMessage: null));

    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(state.copyWith(isSaving: false, errorMessage: "User not found"));
        return;
      }

      await supabase.from('profiles').upsert({
        'user_id': user.id,
        'email': state.email,
        'full_name': state.fullName,
        'role': state.role,
        'gender': state.gender,
        'education_Level': state.educationLevel,
        'school': state.school,
        'updated_at': DateTime.now().toIso8601String(),
      });

      emit(state.copyWith(isSaving: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSaving: false, errorMessage: e.toString()));
    }
  }
}
