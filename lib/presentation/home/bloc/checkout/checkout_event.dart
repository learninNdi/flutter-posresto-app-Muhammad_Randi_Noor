part of 'checkout_bloc.dart';

@freezed
class CheckoutEvent with _$CheckoutEvent {
  const factory CheckoutEvent.started() = _Started;

  // add item
  const factory CheckoutEvent.addItem(Product product) = _AddItem;

  // remove item
  const factory CheckoutEvent.removeItem(Product product) = _RemoveItem;

  const factory CheckoutEvent.addDiscount(Discount discount) = _AddDiscount;
  const factory CheckoutEvent.removeDiscount() = _RemoveDiscount;

  const factory CheckoutEvent.addTax(int tax) = _AddTax;
  // const factory CheckoutEvent.removeTax() = _RemoveTax;

  const factory CheckoutEvent.addServiceCharge(int serviceCharge) =
      _AddServiceCharge;
  // const factory CheckoutEvent.removeServiceCharge() = _RemoveServiceCharge;
}
