class CustomerModel {
  final int? id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final double balance;
  final double debt;
  final int loyaltyPoints;
  final String? notes;
  final bool isActive;
  final DateTime createdAt;

  CustomerModel({
    this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.balance = 0.0,
    this.debt = 0.0,
    this.loyaltyPoints = 0,
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
      'balance': balance,
      'debt': debt,
      'loyaltyPoints': loyaltyPoints,
      'notes': notes,
      'isActive': isActive ? 1 : 0,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map) {
    return CustomerModel(
      id: map['id'],
      name: map['name'],
      phone: map['phone'],
      email: map['email'],
      address: map['address'],
      balance: map['balance'] ?? 0.0,
      debt: map['debt'] ?? 0.0,
      loyaltyPoints: map['loyaltyPoints'] ?? 0,
      notes: map['notes'],
      isActive: map['isActive'] == 1,
      createdAt: DateTime.parse(map['createdAt']),
    );
  }
}
