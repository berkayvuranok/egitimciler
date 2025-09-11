import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final SupabaseClient supabase;

  HomeViewModel(this.supabase) : super(HomeLoading()) {
    on<LoadHomeData>(_onLoadHomeData);
  }

  Future<void> _onLoadHomeData(
    LoadHomeData event,
    Emitter<HomeState> emit,
  ) async {
    emit(HomeLoading());

    try {
      // products tablosundan gerekli alanları çekiyoruz
      final data = await supabase
          .from('products')
          .select('id, name, price, description, image_url, rating, duration, instructor, category')
          .order('updated_at', ascending: false);

      emit(HomeLoaded(List<Map<String, dynamic>>.from(data)));
    } catch (e) {
      emit(HomeError(e.toString()));
    }
  }
}
