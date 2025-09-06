import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  final SupabaseClient supabase;
  HomeViewModel(this.supabase) : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      final response = await supabase.from('products').select().order('created_at', ascending: false);
      if (response != null) {
        final products = List<Map<String, dynamic>>.from(response);
        emit(HomeLoaded(products));
      } else {
        emit(HomeError('No products found'));
      }
    } catch (e) {
      emit(HomeError('Failed to load data: $e'));
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeData event, Emitter<HomeState> emit) async {
    try {
      final response = await supabase.from('products').select().order('created_at', ascending: false);
      if (response != null) {
        final products = List<Map<String, dynamic>>.from(response);
        emit(HomeLoaded(products));
      }
    } catch (e) {
      emit(HomeError('Refresh failed: $e'));
    }
  }
}