part of 'wishlist_bloc.dart';

sealed class WishlistState extends Equatable {
  const WishlistState();

  @override
  List<Object> get props => [];
}

final class WishlistInitial extends WishlistState {}

final class WishlistLoading extends WishlistState {}

final class WishlistLoaded extends WishlistState {
  final List<ProductData> wishlistData;

  const WishlistLoaded({required this.wishlistData});

  @override
  List<Object> get props => [wishlistData];
}

final class WishlistError extends WishlistState {}
