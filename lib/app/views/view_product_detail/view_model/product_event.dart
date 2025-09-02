import 'package:equatable/equatable.dart';

abstract class ProductDetailEvent extends Equatable {
  const ProductDetailEvent();

  @override
  List<Object?> get props => [];
}

class LoadProductDetail extends ProductDetailEvent {
  final Map<String, dynamic> product;
  const LoadProductDetail(this.product);

  @override
  List<Object?> get props => [product];
}
