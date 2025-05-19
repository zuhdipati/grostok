part of 'category_product_bloc.dart';

sealed class CategoryProductEvent extends Equatable {
  const CategoryProductEvent();

  @override
  List<Object> get props => [];
}

class GetCategoryTitleEvent extends CategoryProductEvent {}

class GetProductByCategoryEvent extends CategoryProductEvent {
  final String name;

  const GetProductByCategoryEvent(this.name);
}

class GetMoreProductByCategoryEvent extends CategoryProductEvent {
  final String name;

  const GetMoreProductByCategoryEvent(this.name);
}

class SearchProductEvent extends CategoryProductEvent {
  final String query;
  const SearchProductEvent(this.query);
}
