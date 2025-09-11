import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryViewModel extends Bloc<CategoryEvent, CategoryState> {
  final SupabaseClient supabase;
  CategoryViewModel(this.supabase) : super(CategoryLoading()) {
    on<LoadCategoryProducts>(_onLoadCategoryProducts);
  }

  Future<void> _onLoadCategoryProducts(
      LoadCategoryProducts event, Emitter<CategoryState> emit) async {
    emit(CategoryLoading());
    try {
      final query = supabase.from('products').select();

      final response = event.category == 'All'
          ? await query
          : await query.eq('category', event.category);

      final products = List<Map<String, dynamic>>.from(response);

      // Debug için → konsolda görürsün
      print("Category: ${event.category}");
      print("Fetched products: $products");

      emit(CategoryLoaded(products));
    } catch (e) {
      emit(CategoryError(e.toString()));
    }
  }
}
