import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'search_event.dart';
import 'search_state.dart';

class SearchViewModel extends Bloc<SearchEvent, SearchState> {
  final SupabaseClient supabase = Supabase.instance.client;

  SearchViewModel() : super(SearchInitial()) {
    on<SearchTextChanged>(_onSearchTextChanged);
  }

  Future<void> _onSearchTextChanged(
      SearchTextChanged event, Emitter<SearchState> emit) async {
    final query = event.query.trim();
    if (query.isEmpty) {
      emit(SearchInitial());
      return;
    }

    emit(SearchLoading());
    try {
      final response = await supabase
          .from('products')
          .select()
          .ilike('name', '%$query%')
          .order('created_at', ascending: false);

      if (response != null) {
        emit(SearchLoaded(List<Map<String, dynamic>>.from(response)));
      } else {
        emit(SearchLoaded([]));
      }
    } catch (e) {
      emit(SearchError('Failed to search products'));
    }
  }
}
