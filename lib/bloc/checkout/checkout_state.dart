part of 'checkout_bloc.dart';

abstract class CheckoutState extends Equatable {
  const CheckoutState();

  @override
  List<Object> get props => [];
}

class CheckoutInitial extends CheckoutState {}

class AddCheckoutLoading extends CheckoutState {}

class AddCheckoutLoaded extends CheckoutState {
  final CheckoutModel response;

  const AddCheckoutLoaded(this.response);

  @override
  List<Object> get props => [response];
}

class AddCheckoutError extends CheckoutState {
  final String error;

  const AddCheckoutError(this.error);

  @override
  List<Object> get props => [error];
}
