import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_posresto_app/data/datasources/product_local_datasource.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_order/sync_order_bloc.dart';
import 'package:flutter_posresto_app/presentation/setting/bloc/sync_product/sync_product_bloc.dart';

class SyncDataPage extends StatefulWidget {
  const SyncDataPage({super.key});

  @override
  State<SyncDataPage> createState() => _SyncDataPageState();
}

class _SyncDataPageState extends State<SyncDataPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sync Data'),
      ),
      body: Column(
        children: [
          BlocConsumer<SyncProductBloc, SyncProductState>(
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  loaded: (productResponseModel) {
                    ProductLocalDatasource.instance.deleteAllProducts();
                    ProductLocalDatasource.instance
                        .insertProducts(productResponseModel.data!);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sync Product Success'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                );
              },
              builder: (context, state) => state.maybeWhen(
                    orElse: () => ElevatedButton(
                        onPressed: () {
                          context
                              .read<SyncProductBloc>()
                              .add(const SyncProductEvent.syncProduct());
                        },
                        child: const Text('Sync Product')),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  )),
          BlocConsumer<SyncOrderBloc, SyncOrderState>(
              builder: (context, state) => state.maybeWhen(
                    orElse: () => ElevatedButton(
                        onPressed: () {
                          context
                              .read<SyncOrderBloc>()
                              .add(const SyncOrderEvent.syncOrder());
                        },
                        child: const Text('Sync Order')),
                    loading: () => const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
              listener: (context, state) {
                state.maybeWhen(
                  orElse: () {},
                  error: (message) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(message),
                        backgroundColor: Colors.red,
                      ),
                    );
                  },
                  loaded: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Sync Order Success'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                );
              }),
        ],
      ),
    );
  }
}
