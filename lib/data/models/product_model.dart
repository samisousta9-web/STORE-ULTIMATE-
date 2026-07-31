class ProductModel {
  final int? id;
  final String name;
  final String? description;
  final String? image;
  final String? barcode;
  final String? qrCode;
  final String sku;
  final int categoryId;
  final int? brandId;
  final int? supplierId;
  final double purchasePrice;
  final double salePrice;
  final double taxRate;
  final double discount;
  final int quantity;
  final int minStock;
  final DateTime? expiryDate;
  final int branchId;
  final bool isActive;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    this.id,
    required this.name,
    this.description,
    this.image,
    this.barcode,
    this.qrCode,
    required this.sku,
    required this.categoryId,
    this.brandId,
    this.supplierId,
    required this.purchasePrice,
    required this.salePrice,
    this.taxRate = 0.0,
    this.discount = 0.0,
    required this.quantity,
    this.minStock = 0,
    this.expiryDate,
    required this.branchId,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image': image,
      'barcode': barcode,
      'qrCode': qrCode,
      'sku': sku,
      'categoryId': categoryId,
      'brandId': brandId,
      'supplierId': supplierId,
      'purchasePrice': purchasePrice,
      'salePrice': salePrice,
      'taxRate': taxRate,
      'discount': discount,
      'quantity': quantity,
      'minStock': minStock,
      'expiryDate': expiryDate?.toIso8601String(),
      'branchId': branchId,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'] as int?,
      name: map['name'] as String,
      description: map['description'] as String?,
      image: map['image'] as String?,
      barcode: map['barcode'] as String?,
      qrCode: map['qrCode'] as String?,
      sku: map['sku'] as String,
      categoryId: map['categoryId'] as int,
      brandId: map['brandId'] as int?,
      supplierId: map['supplierId'] as int?,
      purchasePrice: (map['purchasePrice'] as num).toDouble(),
      salePrice: (map['salePrice'] as num).toDouble(),
      taxRate: (map['taxRate'] as num?)?.toDouble() ?? 0.0,
      discount: (map['discount'] as num?)?.toDouble() ?? 0.0,
      quantity: map['quantity'] as int,
      minStock: map['minStock'] as int? ?? 0,
      expiryDate: map['expiryDate'] != null ? DateTime.tryParse(map['expiryDate']) : null,
      branchId: map['branchId'] as int,
      isActive: map['isActive'] == 1,
      createdAt: DateTime.tryParse(map['createdAt']) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(map['updatedAt']) ?? DateTime.now(),
    );
  }

  double get finalPrice => salePrice * (1 + taxRate / 100) * (1 - discount / 100);
  double get profit => salePrice - purchasePrice;
  bool get isLowStock => quantity <= minStock;
  bool get isOutOfStock => quantity <= 0;
}
