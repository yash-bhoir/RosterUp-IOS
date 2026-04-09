class RewardCategory {
  final int categoryId;
  final String name;
  final String icon;

  const RewardCategory({
    required this.categoryId,
    required this.name,
    this.icon = '',
  });
}

class Coupon {
  final int couponId;
  final String name;
  final String description;
  final String image;
  final int price;
  final String expiryDate;
  final int categoryId;
  final bool isPurchased;

  const Coupon({
    required this.couponId,
    required this.name,
    this.description = '',
    this.image = '',
    this.price = 0,
    this.expiryDate = '',
    this.categoryId = 0,
    this.isPurchased = false,
  });
}
