class CouponModel {
  final int? id;
  final String code;
  final String type; // percentage, fixed, bogo
  final double value;
  final double? minOrderAmount;
  final double? maxDiscount;
  final DateTime? startDate;
  final DateTime? endDate;
  final int? usageLimit;
  final int usageCount;
  final bool isActive;
  final DateTime createdAt;

  CouponModel({
    this.id,
    required this.code,
    required this.type,
    required this.value,
    this.minOrderAmount,
    this.maxDiscount,
    this.startDate,
    this.endDate,
    this.usageLimit,
    this.usageCount = 0,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'code': code,
    'type': type,
    'value': value,
    'minOrderAmount': minOrderAmount,
    'maxDiscount': maxDiscount,
    'startDate': startDate?.toIso8601String(),
    'endDate': endDate?.toIso8601String(),
    'usageLimit': usageLimit,
    'usageCount': usageCount,
    'isActive': isActive ? 1 : 0,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CouponModel.fromMap(Map<String, dynamic> map) => CouponModel(
    id: map['id'],
    code: map['code'],
    type: map['type'],
    value: map['value'],
    minOrderAmount: map['minOrderAmount']?.toDouble(),
    maxDiscount: map['maxDiscount']?.toDouble(),
    startDate: map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
    endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
    usageLimit: map['usageLimit'],
    usageCount: map['usageCount'] ?? 0,
    isActive: map['isActive'] == 1,
    createdAt: DateTime.parse(map['createdAt']),
  );

  bool get isValid {
    if (!isActive) return false;
    if (startDate != null && DateTime.now().isBefore(startDate!)) return false;
    if (endDate != null && DateTime.now().isAfter(endDate!)) return false;
    if (usageLimit != null && usageCount >= usageLimit!) return false;
    return true;
  }

  double calculateDiscount(double orderTotal) {
    if (!isValid) return 0;
    if (minOrderAmount != null && orderTotal < minOrderAmount!) return 0;

    double discount = 0;
    if (type == 'percentage') {
      discount = orderTotal * (value / 100);
    } else if (type == 'fixed') {
      discount = value;
    } else if (type == 'bogo') {
      discount = value;
    }

    if (maxDiscount != null && discount > maxDiscount!) {
      discount = maxDiscount!;
    }
    return discount;
  }
}
