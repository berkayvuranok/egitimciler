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
      final id = event.product['id'].toString();
      final data = await supabase.from('products').select().eq('id', id).maybeSingle();

      if (data == null) {
        emit(ProductError('Product not found'));
        return;
      }

      // Yorumları güvenli şekilde parse et
      final rawComments = data['comments'];
      final List<String> comments = [];

      if (rawComments is List) {
        for (var c in rawComments) {
          if (c is String) {
            comments.add(c);
          } else if (c is Map && c.containsKey('text')) comments.add(c['text'].toString());
          else comments.add(c.toString());
        }
      } else if (rawComments is String) {
        comments.add(rawComments);
      }

      final rating = (data['rating'] ?? 0.0).toDouble();
      final isFavorite = data['is_favorite'] ?? false;

      emit(ProductLoaded(
        product: data,
        rating: rating,
        comments: comments,
        isFavorite: isFavorite,
      ));
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
      final newComments = List<String>.from(current.comments)..add(event.text);
      emit(current.copyWith(comments: newComments));

      try {
        await supabase.from('products').update({'comments': newComments}).eq('id', current.product['id']);
      } catch (_) {}
    }
  }

  Future<void> _onEditComment(EditComment event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      final newComments = List<String>.from(current.comments);
      if (event.index >= 0 && event.index < newComments.length) {
        newComments[event.index] = event.newText;
        emit(current.copyWith(comments: newComments));

        try {
          await supabase.from('products').update({'comments': newComments}).eq('id', current.product['id']);
        } catch (_) {}
      }
    }
  }

  Future<void> _onDeleteComment(DeleteComment event, Emitter<ProductState> emit) async {
    if (state is ProductLoaded) {
      final current = state as ProductLoaded;
      final newComments = List<String>.from(current.comments)..removeAt(event.index);
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
