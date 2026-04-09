import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/datasources/reward_remote_datasource.dart';
import '../../domain/entities/reward.dart';

final rewardCategoriesProvider =
    AsyncNotifierProvider<RewardCategoriesNotifier, List<RewardCategory>>(
  RewardCategoriesNotifier.new,
);

class RewardCategoriesNotifier extends AsyncNotifier<List<RewardCategory>> {
  @override
  Future<List<RewardCategory>> build() async {
    final ds = ref.read(rewardRemoteDatasourceProvider);
    final json = await ds.getCategories();
    final data = json['data'] as List<dynamic>? ?? [];
    return data.map((e) {
      final m = e as Map<String, dynamic>;
      return RewardCategory(
        categoryId: m['category_id'] ?? m['id'] ?? 0,
        name: m['name'] ?? '',
        icon: m['icon'] ?? '',
      );
    }).toList();
  }
}

final couponsByCategoryProvider = AsyncNotifierFamilyProvider<
    CouponsByCategoryNotifier, List<Coupon>, String>(
  CouponsByCategoryNotifier.new,
);

class CouponsByCategoryNotifier
    extends FamilyAsyncNotifier<List<Coupon>, String> {
  @override
  Future<List<Coupon>> build(String arg) async {
    final ds = ref.read(rewardRemoteDatasourceProvider);
    final json = await ds.getCouponsByCategory(arg);
    final data = json['data'] as List<dynamic>? ?? [];
    return data.map((e) => _parseCoupon(e as Map<String, dynamic>)).toList();
  }
}

final userCouponsProvider =
    AsyncNotifierProvider<UserCouponsNotifier, List<Coupon>>(
  UserCouponsNotifier.new,
);

class UserCouponsNotifier extends AsyncNotifier<List<Coupon>> {
  @override
  Future<List<Coupon>> build() async {
    final ds = ref.read(rewardRemoteDatasourceProvider);
    final json = await ds.getUserCoupons();
    final data = json['data'] as List<dynamic>? ?? [];
    return data
        .map((e) => _parseCoupon(e as Map<String, dynamic>, purchased: true))
        .toList();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(build);
  }
}

final buyCouponProvider =
    StateNotifierProvider<BuyCouponNotifier, AsyncValue<void>>((ref) {
  return BuyCouponNotifier(ref);
});

class BuyCouponNotifier extends StateNotifier<AsyncValue<void>> {
  final Ref _ref;

  BuyCouponNotifier(this._ref) : super(const AsyncData(null));

  Future<bool> buy(int couponId) async {
    state = const AsyncLoading();
    try {
      final ds = _ref.read(rewardRemoteDatasourceProvider);
      final json = await ds.buyCoupon(couponId);
      if (json['status'] == true) {
        state = const AsyncData(null);
        _ref.read(userCouponsProvider.notifier).refresh();
        return true;
      }
      state = AsyncError(
          json['message'] ?? 'Failed', StackTrace.current);
      return false;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      return false;
    }
  }
}

Coupon _parseCoupon(Map<String, dynamic> m, {bool purchased = false}) {
  return Coupon(
    couponId: m['coupon_id'] ?? m['id'] ?? 0,
    name: m['name'] ?? '',
    description: m['description'] ?? '',
    image: m['image'] ?? '',
    price: m['price'] ?? 0,
    expiryDate: m['expiry_date'] ?? '',
    categoryId: m['category_id'] ?? 0,
    isPurchased: purchased || (m['is_purchased'] ?? false),
  );
}
