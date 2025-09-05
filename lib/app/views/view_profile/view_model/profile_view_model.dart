import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final SupabaseClient supabase;

  ProfileViewModel({required this.supabase}) : super(const ProfileState()) {
    on<LoadUserProfile>(_onLoadUserProfile);
    on<LogoutRequested>(_onLogoutRequested);
  }

  Future<void> _onLoadUserProfile(
      LoadUserProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      final user = supabase.auth.currentUser;
      if (user != null) {
        emit(state.copyWith(
          email: user.email,
          username: user.userMetadata?['username'] ?? "No username",
          isLoading: false,
        ));
      } else {
        emit(state.copyWith(
            isLoading: false, errorMessage: "No user is logged in"));
      }
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Error loading profile: $e"));
    }
  }

  Future<void> _onLogoutRequested(
      LogoutRequested event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isLoading: true, errorMessage: null));

    try {
      await supabase.auth.signOut();
      emit(const ProfileState(
          email: null, username: null, isLoading: false));
    } catch (e) {
      emit(state.copyWith(
          isLoading: false, errorMessage: "Error logging out: $e"));
    }
  }
}
