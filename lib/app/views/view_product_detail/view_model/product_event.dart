import 'package:flutter/foundation.dart';

@immutable
abstract class ProductEvent {}

class LoadProductDetail extends ProductEvent {
  final Map<String, dynamic> product;
  LoadProductDetail(this.product);
}

class UpdateRating extends ProductEvent {
  final double rating;
  UpdateRating(this.rating);
}

class AddComment extends ProductEvent {
  final String text;
  AddComment(this.text);
}

class EditComment extends ProductEvent {
  final int index;
  final String newText;
  EditComment(this.index, this.newText);
}

class DeleteComment extends ProductEvent {
  final int index;
  DeleteComment(this.index);
}

class ToggleFavorite extends ProductEvent {}
