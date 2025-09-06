import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'profile_event.dart';
import 'profile_state.dart';

class ProfileViewModel extends Bloc<ProfileEvent, ProfileState> {
  final supabase = Supabase.instance.client;

  ProfileViewModel() : super(const ProfileState()) {
    on<LoadProfile>(_onLoadProfile);
    on<ProfileFieldChanged>(_onFieldChanged);
    on<SaveProfile>(_onSaveProfile);
  }

  Future<void> _onLoadProfile(LoadProfile event, Emitter<ProfileState> emit) async {
    try {
      final userId = event.userId;
      if (userId == null) return;

      final profileResponse = await supabase
          .from('profiles')
          .select()
          .eq('user_id', userId)
          .maybeSingle();

      if (profileResponse != null) {
        emit(state.copyWith(
          fullName: profileResponse['full_name'] ?? '',
          email: profileResponse['email'] ?? event.email ?? '',
          role: profileResponse['role'] ?? '',
          gender: profileResponse['gender'] ?? '',
          educationLevel: profileResponse['education_level'] ?? '',
          school: profileResponse['school'] ?? '',
        ));
      }

      // Seller/Teacher ise ürün bilgilerini yükle
      final product = await supabase
          .from('products')
          .select()
          .eq('instructor', profileResponse?['full_name'])
          .maybeSingle();

      if (product != null) {
        emit(state.copyWith(
          lessonTitle: product['name'] ?? '',
          lessonDescription: product['description'] ?? '',
          lessonPrice: product['price']?.toString() ?? '',
          lessonImageUrl: product['image_url'] ?? '',
        ));
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: e.toString()));
    }
  }

  void _onFieldChanged(ProfileFieldChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      role: event.role ?? state.role,
      gender: event.gender ?? state.gender,
      educationLevel: event.educationLevel ?? state.educationLevel,
      school: event.school ?? state.school,
      fullName: event.fullName ?? state.fullName,
    ));
  }

  Future<void> _onSaveProfile(SaveProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isSaving: true, isSuccess: false, errorMessage: null));

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception("User not logged in");

      String? lessonImageUrl = state.lessonImageUrl;

      // Ürün görseli seçildiyse Storage'a yükle
      if (event.lessonImage != null) {
        final fileBytes = await event.lessonImage!.readAsBytes();
        final fileName = "products/${user.id}_${DateTime.now().millisecondsSinceEpoch}.png";
        await supabase.storage.from('products').uploadBinary(fileName, fileBytes);
        lessonImageUrl = supabase.storage.from('products').getPublicUrl(fileName);
      }

      // products tablosuna kaydet / güncelle
      if (state.lessonTitle.isNotEmpty) {
        await supabase.from('products').upsert({
          'name': state.lessonTitle,
          'description': state.lessonDescription,
          'price': state.lessonPrice,
          'image_url': lessonImageUrl ?? '',
          'instructor': state.fullName,
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'instructor');
      }

      // profiles tablosuna kaydet / güncelle
      await supabase.from('profiles').upsert({
        'user_id': user.id,
        'full_name': state.fullName,
        'email': state.email,
        'role': state.role,
        'gender': state.gender,
        'education_level': state.educationLevel,
        'school': state.school,
        'updated_at': DateTime.now().toIso8601String(),
      }, onConflict: 'user_id');

      emit(state.copyWith(isSaving: false, isSuccess: true));
    } catch (e) {
      emit(state.copyWith(isSaving: false, isSuccess: false, errorMessage: e.toString()));
    }
  }
}
