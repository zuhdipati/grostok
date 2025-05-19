part of 'search_product_bloc.dart';

sealed class SearchProductEvent extends Equatable {
  const SearchProductEvent();

  @override
  List<Object> get props => [];
}

class GetSearchProductEvent extends SearchProductEvent {
  final String query;

  const GetSearchProductEvent({required this.query});

  @override
  List<Object> get props => [query];
}

class GetMoreSearchProductEvent extends SearchProductEvent {
  final String query;

  const GetMoreSearchProductEvent({required this.query});

  @override
  List<Object> get props => [query];
}
