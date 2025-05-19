part of 'checkout_bloc.dart';

sealed class CheckoutEvent extends Equatable {
  const CheckoutEvent();

  @override
  List<Object> get props => [];
}

class AddToCheckoutEvent extends CheckoutEvent {
  final AddToCheckoutRequestModel model;

  const AddToCheckoutEvent(this.model);

  @override
  List<Object> get props => [model];
}
