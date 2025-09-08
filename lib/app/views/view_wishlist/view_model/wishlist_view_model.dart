import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'wishlist_event.dart';
import 'wishlist_state.dart';

class WishlistViewModel extends Bloc<WishlistEvent, WishlistState> {
  final SupabaseClient supabase;

  WishlistViewModel(this.supabase) : super(WishlistLoading()) {
    on<LoadWishlist>(_onLoadWishlist);
    on<AddToWishlist>(_onAddToWishlist);
    on<RemoveFromWishlist>(_onRemoveFromWishlist);
  }

  Future<void> _onLoadWishlist(LoadWishlist event, Emitter<WishlistState> emit) async {
    emit(WishlistLoading());
    try {
      final user = supabase.auth.currentUser;
      if (user == null) {
        emit(WishlistError("User not logged in"));
        return;
      }

      final data = await supabase
          .from('wishlist')
          .select()
          .eq('user_id', user.id);

      final products = (data as List<dynamic>)
          .map((e) => Map<String, dynamic>.from(e['product']))
          .toList();

      emit(WishlistLoaded(products));
    } catch (e) {
      emit(WishlistError("Failed to load wishlist: $e"));
    }
  }

  Future<void> _onAddToWishlist(AddToWishlist event, Emitter<WishlistState> emit) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase.from('wishlist').insert({
        'user_id': user.id,
        'product_id': event.product['id'],
        'product': event.product,
      });

      add(LoadWishlist());
    } catch (e) {
      emit(WishlistError("Failed to add to wishlist: $e"));
    }
  }

  Future<void> _onRemoveFromWishlist(RemoveFromWishlist event, Emitter<WishlistState> emit) async {
    try {
      final user = supabase.auth.currentUser;
      if (user == null) return;

      await supabase
          .from('wishlist')
          .delete()
          .eq('user_id', user.id)
          .eq('product_id', event.productId);

      add(LoadWishlist());
    } catch (e) {
      emit(WishlistError("Failed to remove from wishlist: $e"));
    }
  }
}
