import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
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

      // Profil verisini çek
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

      // Ürün/lesson verisini çek (sadece fullName varsa)
      if (profileResponse?['full_name'] != null) {
        final product = await supabase
            .from('products')
            .select()
            .eq('instructor', profileResponse!['full_name'])
            .maybeSingle();

        if (product != null) {
          emit(state.copyWith(
            lessonTitle: product['name'] ?? '',
            lessonDescription: product['description'] ?? '',
            lessonPrice: product['price']?.toString() ?? '',
            lessonDuration: product['duration']?.toString() ?? '',
            lessonImageUrl: product['image_url'] ?? '',
          ));
        }
      }
    } catch (e) {
      emit(state.copyWith(errorMessage: "Profil yüklenirken hata: ${e.toString()}"));
    }
  }

  void _onFieldChanged(ProfileFieldChanged event, Emitter<ProfileState> emit) {
    emit(state.copyWith(
      role: event.role ?? state.role,
      gender: event.gender ?? state.gender,
      educationLevel: event.educationLevel ?? state.educationLevel,
      school: event.school ?? state.school,
      fullName: event.fullName ?? state.fullName,
      lessonTitle: event.lessonTitle ?? state.lessonTitle,
      lessonDescription: event.lessonDescription ?? state.lessonDescription,
      lessonPrice: event.lessonPrice ?? state.lessonPrice,
      lessonDuration: event.lessonDuration ?? state.lessonDuration,
      lessonImage: event.lessonImage ?? state.lessonImage,
    ));
  }

  Future<void> _onSaveProfile(SaveProfile event, Emitter<ProfileState> emit) async {
    emit(state.copyWith(isSaving: true, isSuccess: false, errorMessage: null));

    try {
      final user = supabase.auth.currentUser;
      if (user == null) throw Exception("Kullanıcı giriş yapmamış");

      String? lessonImageUrl = state.lessonImageUrl;
      final XFile? imageToUpload = event.lessonImage ?? state.lessonImage;

      // Eğer görsel seçildiyse Storage'a yükle
      if (imageToUpload != null) {
        final fileBytes = await File(imageToUpload.path).readAsBytes();
        final ext = imageToUpload.name.split('.').last;
        
        // DÜZELTME: Klasör yapısını düzgün oluştur
        final fileName = "${user.id}/${DateTime.now().millisecondsSinceEpoch}.$ext";

        try {
          await supabase.storage
              .from('images')
              .uploadBinary(fileName, fileBytes, fileOptions: FileOptions(contentType: 'image/$ext'));

          final publicUrl = supabase.storage.from('images').getPublicUrl(fileName);
          lessonImageUrl = publicUrl;
        } catch (storageError) {
          // Storage hatasını yakala ve kullanıcıya bildir
          emit(state.copyWith(
            isSaving: false,
            isSuccess: false,
            errorMessage: "Resim yüklenirken hata: $storageError\n"
                "Lütfen Supabase Storage politikalarını kontrol edin."
          ));
          return;
        }
      }

      final lessonTitle = event.lessonTitle ?? state.lessonTitle;
      final lessonDescription = event.lessonDescription ?? state.lessonDescription;
      final lessonPrice = event.lessonPrice ?? state.lessonPrice;
      final lessonDuration = event.lessonDuration ?? state.lessonDuration;

      // Fiyatı sayıya çevir (boşsa null yap)
      double? parsedPrice;
      if (lessonPrice.isNotEmpty) {
        parsedPrice = double.tryParse(lessonPrice);
      }

      if (lessonTitle.isNotEmpty) {
        await supabase.from('products').upsert({
          'name': lessonTitle,
          'description': lessonDescription,
          'price': parsedPrice,
          'duration': lessonDuration,
          'image_url': lessonImageUrl ?? '',
          'instructor': state.fullName,
          'updated_at': DateTime.now().toIso8601String(),
        }, onConflict: 'instructor');
      }

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

      emit(state.copyWith(
        isSaving: false,
        isSuccess: true,
        lessonImageUrl: lessonImageUrl ?? state.lessonImageUrl,
        lessonImage: null, // Yüklendikten sonra temizle
      ));
    } catch (e) {
      emit(state.copyWith(
        isSaving: false, 
        isSuccess: false, 
        errorMessage: "Profil kaydedilirken hata: ${e.toString()}"
      ));
    }
  }
}