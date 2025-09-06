abstract class CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Map<String, dynamic>> products;
  CategoryLoaded(this.products);
}

class CategoryError extends CategoryState {
  final String message;
  CategoryError(this.message);
}
