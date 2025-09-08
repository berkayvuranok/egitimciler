import 'package:flutter/foundation.dart';

@immutable
abstract class WishlistEvent {}

class LoadWishlist extends WishlistEvent {}

class AddToWishlist extends WishlistEvent {
  final Map<String, dynamic> product;
  AddToWishlist(this.product);
}

class RemoveFromWishlist extends WishlistEvent {
  final int productId;
  RemoveFromWishlist(this.productId);
}
