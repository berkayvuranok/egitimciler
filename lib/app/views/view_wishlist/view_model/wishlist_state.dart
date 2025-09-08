import 'package:flutter/foundation.dart';

@immutable
abstract class WishlistState {}

class WishlistLoading extends WishlistState {}

class WishlistLoaded extends WishlistState {
  final List<Map<String, dynamic>> products;

  WishlistLoaded(this.products);
}

class WishlistError extends WishlistState {
  final String message;
  WishlistError(this.message);
}
