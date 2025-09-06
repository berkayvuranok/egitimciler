import 'package:flutter/foundation.dart';

@immutable
abstract class ProductState {}

class ProductLoading extends ProductState {}

class ProductLoaded extends ProductState {
  final Map<String, dynamic> product;
  final double rating;
  final List<dynamic> comments;
  final bool isFavorite;

  ProductLoaded({
    required this.product,
    required this.rating,
    required this.comments,
    this.isFavorite = false,
  });

  ProductLoaded copyWith({
    Map<String, dynamic>? product,
    double? rating,
    List<dynamic>? comments,
    bool? isFavorite,
  }) {
    return ProductLoaded(
      product: product ?? this.product,
      rating: rating ?? this.rating,
      comments: comments ?? this.comments,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

class ProductError extends ProductState {
  final String message;
  ProductError(this.message);
}
