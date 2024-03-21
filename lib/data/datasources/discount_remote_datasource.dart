import 'package:dartz/dartz.dart';
import 'package:flutter_posresto_app/core/constants/variables.dart';
import 'package:flutter_posresto_app/data/datasources/auth_local_datasource.dart';
import 'package:flutter_posresto_app/data/models/responses/discount_response_model.dart';
import 'package:http/http.dart' as http;

class DiscountRemoteDatasource {
  Future<Either<String, DiscountResponseModel>> getDiscounts() async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-discounts');
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.get(url, headers: {
      'Authorization': 'Bearer ${authData.token}',
    });

    if (response.statusCode == 200) {
      return Right(DiscountResponseModel.fromJson(response.body));
    }

    return const Left('Failed to get discounts');
  }

  Future<Either<String, bool>> addDiscount(
      String name, String description, int value) async {
    final url = Uri.parse('${Variables.baseUrl}/api/api-discounts');
    final authData = await AuthLocalDatasource().getAuthData();
    final response = await http.post(url, headers: {
      'Authorization': 'Bearer ${authData.token}',
    }, body: {
      'name': name,
      'description': description,
      'value': value.toString(),
      'type': 'percentage',
    });

    if (response.statusCode == 201) {
      return const Right(true);
    }

    return const Left('Failed to add discount');
  }
}
