import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchViewModel extends Bloc<SearchEvent, SearchState> {
  final SupabaseClient supabase = Supabase.instance.client;
  List<Map<String, dynamic>> _allProducts = [];

  SearchViewModel() : super(SearchInitial()) {
    on<LoadAllProducts>(_onLoadAllProducts);
    on<SearchTextChanged>(_onSearchTextChanged);
  }

  Future<void> _onLoadAllProducts(
      LoadAllProducts event, Emitter<SearchState> emit) async {
    emit(SearchLoading());
    try {
      final response = await supabase
          .from('products')
          .select()
          .order('created_at', ascending: false);

      _allProducts = List<Map<String, dynamic>>.from(response);
      emit(SearchLoaded(_allProducts));
    } catch (e) {
      emit(SearchError('Failed to load products: $e'));
    }
  }

  void _onSearchTextChanged(
      SearchTextChanged event, Emitter<SearchState> emit) {
    final query = event.query.trim().toLowerCase();

    if (query.isEmpty) {
      emit(SearchLoaded(_allProducts));
      return;
    }

    // Sadece baştan eşleşenler gösterilecek
    final matched = _allProducts.where((product) {
      final name = (product['name'] ?? '').toString().toLowerCase();
      return name.startsWith(query);
    }).toList();

    emit(SearchLoaded(matched));
  }
}
