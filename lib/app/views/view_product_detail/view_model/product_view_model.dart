import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'product_event.dart';
import 'product_state.dart';

class ProductViewModel extends Bloc<ProductEvent, ProductState> {
  final SupabaseClient supabase;

  ProductViewModel(this.supabase) : super(ProductLoading()) {
    on<LoadProductDetail>(_onLoadProductDetail);
    on<UpdateRating>(_onUpdateRating);
    on<AddComment>(_onAddComment);
    on<EditComment>(_onEditComment);
    on<DeleteComment>(_onDeleteComment);
    on<ToggleFavorite>(_onToggleFavorite);
  }

  Future<void> _onLoadProductDetail(LoadProductDetail event, Emitter<ProductState> emit) async {
    emit(ProductLoading());
    try {
      final id = event.product['id'].toString(); // UUID/text uyumlu
      final data = await supabase.from('products').select().eq('id', id).maybeSingle();

      if (data == null) {
        emit(ProductError('Product not found'));
        return;
      }

      final rating = (data['rating'] ?? 0.0).toDouble();
      final comments = List<dynamic>.from(data['comments'] ?? []);
      final isFavorite = data['is_favorite'] ?? false;

      emit(ProductLoaded(product: data, rating: rating, comments: comments, isFavorite: isFavorite));
    } catch (e) {
      emit(ProductError('Failed to load product: $e'));
    }
  }

  Future<void> _onUpdateRating(UpdateRating event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      emit(current.copyWith(rating: event.rating));

      try {
        await supabase.from('products').update({'rating': event.rating}).eq('id', current.product['id']);
      } catch (_) {}
    }
  }

  Future<void> _onAddComment(AddComment event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      final newComments = List<dynamic>.from(current.comments)
        ..add({'text': event.text, 'date': DateTime.now().toIso8601String()});
      emit(current.copyWith(comments: newComments));

      try {
        await supabase.from('products').update({'comments': newComments}).eq('id', current.product['id']);
      } catch (_) {}
    }
  }

  Future<void> _onEditComment(EditComment event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      final newComments = List<dynamic>.from(current.comments);
      newComments[event.index]['text'] = event.newText;
      emit(current.copyWith(comments: newComments));

      try {
        await supabase.from('products').update({'comments': newComments}).eq('id', current.product['id']);
      } catch (_) {}
    }
  }

  Future<void> _onDeleteComment(DeleteComment event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      final newComments = List<dynamic>.from(current.comments)..removeAt(event.index);
      emit(current.copyWith(comments: newComments));

      try {
        await supabase.from('products').update({'comments': newComments}).eq('id', current.product['id']);
      } catch (_) {}
    }
  }

  Future<void> _onToggleFavorite(ToggleFavorite event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      final newFav = !current.isFavorite;
      emit(current.copyWith(isFavorite: newFav));

      try {
        await supabase.from('products').update({'is_favorite': newFav}).eq('id', current.product['id']);
      } catch (_) {}
    }
  }
}
