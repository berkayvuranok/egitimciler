abstract class CategoryEvent {}

class LoadCategoryProducts extends CategoryEvent {
  final String category;
  LoadCategoryProducts(this.category);
}
