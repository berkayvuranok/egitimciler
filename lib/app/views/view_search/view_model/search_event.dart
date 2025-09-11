abstract class SearchEvent {}

class LoadAllProducts extends SearchEvent {}

class SearchTextChanged extends SearchEvent {
  final String query;
  SearchTextChanged(this.query);
}
