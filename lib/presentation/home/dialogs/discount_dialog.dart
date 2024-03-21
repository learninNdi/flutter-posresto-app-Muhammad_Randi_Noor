import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/presentation/home/bloc/checkout/checkout_bloc.dart';

import '../../../../core/core.dart';
import '../../setting/bloc/discount/discount_bloc.dart';

class DiscountDialog extends StatefulWidget {
  const DiscountDialog({super.key});

  @override
  State<DiscountDialog> createState() => _DiscountDialogState();
}

class _DiscountDialogState extends State<DiscountDialog> {
  @override
  void initState() {
    context.read<DiscountBloc>().add(const DiscountEvent.getDiscounts());
    super.initState();
  }

  List<int> discountChecked = [];

  void _onSelected(bool selected, int id) {
    setState(() {
      selected ? discountChecked.add(id) : discountChecked.remove(id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Stack(
        alignment: Alignment.center,
        children: [
          const Text(
            'DISKON',
            style: TextStyle(
              color: AppColors.primary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              onPressed: () {
                context.pop();
              },
              icon: const Icon(
                Icons.cancel,
                color: AppColors.primary,
                size: 30.0,
              ),
            ),
          ),
        ],
      ),
      content: BlocBuilder<DiscountBloc, DiscountState>(
        builder: (context, state) {
          return state.maybeWhen(
            orElse: () => const SizedBox.shrink(),
            loading: () => const Center(
              child: CircularProgressIndicator(),
            ),
            loaded: (discounts) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children:
                    // discounts
                    //     .map((discount) => ListTile(
                    //           title: Text('Nama Diskon: ${discount.name}'),
                    //           subtitle: Text('Potongan harga (${discount.value}%)'),
                    //           contentPadding: EdgeInsets.zero,
                    //           textColor: AppColors.primary,
                    //           trailing: Checkbox(
                    //             value: discount.id == discountIdSelected,
                    //             onChanged: (value) {
                    //               setState(() {
                    //                 discountIdSelected = discount.id!;

                    //                 context
                    //                     .read<CheckoutBloc>()
                    //                     .add(CheckoutEvent.addDiscount(discount));
                    //               });
                    //             },
                    //           ),
                    //           onTap: () {
                    //             context.pop();
                    //           },
                    //         ))
                    //     .toList(),
                    discounts
                        .map((discount) => ListTile(
                              title: Text('Nama Diskon: ${discount.name}'),
                              subtitle: Text(
                                  'Potongan harga (${discount.value!.replaceAll(".00", "")}%)'),
                              contentPadding: EdgeInsets.zero,
                              textColor: AppColors.primary,
                              trailing: Checkbox(
                                value: discountChecked.contains(discount.id!),
                                onChanged: (value) {
                                  setState(() {
                                    _onSelected(value!, discount.id!);

                                    context.read<CheckoutBloc>().add(
                                        CheckoutEvent.addDiscount(discount));
                                  });
                                },
                              ),
                              onTap: () {
                                context.pop();
                              },
                            ))
                        .toList(),
              );
            },
          );
        },
      ),
    );
  }
}
