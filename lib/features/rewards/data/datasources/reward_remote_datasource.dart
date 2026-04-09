import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/network/api_client.dart';
import '../../../../core/network/api_endpoints.dart';

final rewardRemoteDatasourceProvider =
    Provider<RewardRemoteDatasource>((ref) {
  return RewardRemoteDatasource(ref.watch(dioProvider));
});

class RewardRemoteDatasource {
  final Dio _dio;

  RewardRemoteDatasource(this._dio);

  Future<Map<String, dynamic>> getCategories() async {
    final response = await _dio.get(ApiEndpoints.rewardCategories);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCouponsByCategory(String categoryId) async {
    final response =
        await _dio.get(ApiEndpoints.couponsByCategory(categoryId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getCouponDetail(String couponId) async {
    final response = await _dio.get(ApiEndpoints.couponDetail(couponId));
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> getUserCoupons() async {
    final response = await _dio.get(ApiEndpoints.userCoupons);
    return response.data as Map<String, dynamic>;
  }

  Future<Map<String, dynamic>> buyCoupon(int couponId) async {
    final response = await _dio.post(
      ApiEndpoints.buyCoupon,
      data: {'coupon_id': couponId},
    );
    return response.data as Map<String, dynamic>;
  }
}
