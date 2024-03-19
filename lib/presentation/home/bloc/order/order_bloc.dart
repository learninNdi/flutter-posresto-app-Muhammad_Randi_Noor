import 'package:bloc/bloc.dart';
import 'package:flutter_posresto_app/core/core.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/home/models/order_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../models/product_quantity.dart';

part 'order_event.dart';
part 'order_state.dart';
part 'order_bloc.freezed.dart';

class OrderBloc extends Bloc<OrderEvent, OrderState> {
  OrderBloc() : super(const _Initial()) {
    on<_Order>((event, emit) async {
      emit(const _Loading());

      final subTotal = event.items.fold<int>(
          0,
          (previousValue, element) =>
              previousValue +
              (element.product.price!.toIntegerFromText * element.quantity));

      final total = subTotal + event.tax + event.serviceCharge - event.discount;
      final totalItem = event.items.fold<int>(
          0, (previousValue, element) => previousValue + element.quantity);

      final userData = await AuthLocalDatasource().getAuthData();

      // save to local storage
      final dataInput = OrderModel(
          paymentAmount: event.paymentAmount,
          subTotal: subTotal.toInt(),
          tax: event.tax,
          discount: event.discount,
          serviceCharge: event.serviceCharge,
          total: total.toInt(),
          paymentMethod: 'Cash',
          totalItem: totalItem,
          idKasir: userData.user!.id!,
          namaKasir: userData.user!.name!,
          transactionTime: DateTime.now().toIso8601String(),
          isSync: 0,
          orderItems: event.items);

      await ProductLocalDatasource.instance.saveOrder(dataInput);

      emit(_Loaded(dataInput));
    });
  }
}