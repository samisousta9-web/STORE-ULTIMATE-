class SaleModel {
  final int? id;
  final String invoiceNumber;
  final int? customerId;
  final int userId;
  final int branchId;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double total;
  final double paid;
  final String paymentMethod;
  final String? paymentReference;
  final String status;
  final String? notes;
  final DateTime createdAt;
  final List<SaleItemModel> items;

  SaleModel({
    this.id,
    required this.invoiceNumber,
    this.customerId,
    required this.userId,
    required this.branchId,
    required this.subtotal,
    required this.taxAmount,
    required this.discountAmount,
    required this.total,
    required this.paid,
    required this.paymentMethod,
    this.paymentReference,
    required this.status,
    this.notes,
    required this.createdAt,
    this.items = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'invoiceNumber': invoiceNumber,
      'customerId': customerId,
      'userId': userId,
      'branchId': branchId,
      'subtotal': subtotal,
      'taxAmount': taxAmount,
      'discountAmount': discountAmount,
      'total': total,
      'paid': paid,
      'paymentMethod': paymentMethod,
      'paymentReference': paymentReference,
      'status': status,
      'notes': notes,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SaleModel.fromMap(Map<String, dynamic> map) {
    return SaleModel(
      id: map['id'],
      invoiceNumber: map['invoiceNumber'],
      customerId: map['customerId'],
      userId: map['userId'],
      branchId: map['branchId'],
      subtotal: map['subtotal'],
      taxAmount: map['taxAmount'],
      discountAmount: map['discountAmount'],
      total: map['total'],
      paid: map['paid'],
      paymentMethod: map['paymentMethod'],
      paymentReference: map['paymentReference'],
      status: map['status'],
      notes: map['notes'],
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}

class SaleItemModel {
  final int? id;
  final int saleId;
  final int productId;
  final String productName;
  final double unitPrice;
  final int quantity;
  final double discount;
  final double tax;
  final double total;

  SaleItemModel({
    this.id,
    required this.saleId,
    required this.productId,
    required this.productName,
    required this.unitPrice,
    required this.quantity,
    this.discount = 0.0,
    this.tax = 0.0,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'saleId': saleId,
      'productId': productId,
      'productName': productName,
      'unitPrice': unitPrice,
      'quantity': quantity,
      'discount': discount,
      'tax': tax,
      'total': total,
    };
  }

  factory SaleItemModel.fromMap(Map<String, dynamic> map) {
    return SaleItemModel(
      id: map['id'],
      saleId: map['saleId'],
      productId: map['productId'],
      productName: map['productName'],
      unitPrice: map['unitPrice'],
      quantity: map['quantity'],
      discount: map['discount'] ?? 0.0,
      tax: map['tax'] ?? 0.0,
      total: map['total'],
    );
  }
}
