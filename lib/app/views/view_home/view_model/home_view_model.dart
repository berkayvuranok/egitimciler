import 'package:flutter_bloc/flutter_bloc.dart';
import 'home_event.dart';
import 'home_state.dart';

class HomeViewModel extends Bloc<HomeEvent, HomeState> {
  HomeViewModel() : super(HomeInitial()) {
    on<LoadHomeData>(_onLoadHomeData);
    on<RefreshHomeData>(_onRefreshHomeData);
  }

  Future<void> _onLoadHomeData(LoadHomeData event, Emitter<HomeState> emit) async {
    emit(HomeLoading());
    try {
      // Simülasyon: API çağrısı yerine basit veri
      await Future.delayed(Duration(seconds: 1));
      final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
      emit(HomeLoaded(items));
    } catch (e) {
      emit(HomeError('Veri yüklenemedi'));
    }
  }

  Future<void> _onRefreshHomeData(RefreshHomeData event, Emitter<HomeState> emit) async {
    try {
      final items = ['Item 1', 'Item 2', 'Item 3', 'Item 4'];
      emit(HomeLoaded(items));
    } catch (e) {
      emit(HomeError('Yenileme başarısız'));
    }
  }
}
