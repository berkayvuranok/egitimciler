import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryViewModel extends Bloc<CategoryEvent, CategoryState> {
  final SupabaseClient supabase;

  CategoryViewModel(this.supabase) : super(CategoryLoading()) {
    on<LoadCategoryProducts>(_onLoadCategoryProducts);
  }

  Future<void> _onLoadCategoryProducts(LoadCategoryProducts event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final response = await supabase
          .from('products')
          .select()
          .eq('category', event.category)
          .order('created_at', ascending: false);

      if (response != null) {
        emit(CategoryLoaded(List<Map<String, dynamic>>.from(response)));
      } else {
        emit(CategoryLoaded([]));
      }
    } catch (e) {
      emit(CategoryError('Failed to load products: $e'));
    }
  }
}
