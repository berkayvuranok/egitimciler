import 'package:equatable/equatable.dart';

abstract class CategoryEvent extends Equatable {
  const CategoryEvent();

  @override
  List<Object> get props => [];
}

class LoadCategoryProducts extends CategoryEvent {
  final String category;
  const LoadCategoryProducts(this.category);

  @override
  List<Object> get props => [category];
}

