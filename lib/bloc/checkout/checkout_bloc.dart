import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:grostok/data/models/add_checkout_model.dart';
import 'package:grostok/data/models/checkout_model.dart';
import 'package:grostok/data/repositories/checkout/checkout_repository.dart';

part 'checkout_event.dart';
part 'checkout_state.dart';

class CheckoutBloc extends Bloc<CheckoutEvent, CheckoutState> {
  final CheckoutRepository repository;

  CheckoutBloc(this.repository) : super(CheckoutInitial()) {
    on<AddToCheckoutEvent>(_onAddToCheckout);
  }

  Future<void> _onAddToCheckout(AddToCheckoutEvent event, emit) async {
    emit(AddCheckoutLoading());
    try {
      Map<String, dynamic> response =
          await repository.addToCheckout(event.model);
      if (response["error"] == true) {
        throw response["message"];
      } else {
        CheckoutModel checkoutData = CheckoutModel.fromJson(response['data']);
        emit(AddCheckoutLoaded(checkoutData));
      }
    } catch (e) {
      emit(AddCheckoutError(e.toString()));
    }
  }
}
