class SupplierModel {
  final int? id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double debt;
  final double paid;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;

  SupplierModel({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.debt = 0.0,
    this.paid = 0.0,
    this.notes,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'debt': debt,
      'paid': paid,
      'notes': notes,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory SupplierModel.fromMap(Map<String, dynamic> map) {
    return SupplierModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      debt: map['debt'] ?? 0.0,
      paid: map['paid'] ?? 0.0,
      notes: map['notes'],
      isActive: map['isActive'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
