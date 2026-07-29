class CompanyModel {
  final int? id;
  final String name;
  final String? taxNumber;
  final String? commercialRegister;
  final String? address;
  final String? phone;
  final String? email;
  final String? logo;
  final String currency;
  final String? defaultTaxRate;
  final bool isActive;
  final DateTime createdAt;

  CompanyModel({
    this.id,
    required this.name,
    this.taxNumber,
    this.commercialRegister,
    this.address,
    this.phone,
    this.email,
    this.logo,
    this.currency = 'DZD',
    this.defaultTaxRate,
    this.isActive = true,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'name': name,
    'taxNumber': taxNumber,
    'commercialRegister': commercialRegister,
    'address': address,
    'phone': phone,
    'email': email,
    'logo': logo,
    'currency': currency,
    'defaultTaxRate': defaultTaxRate,
    'isActive': isActive ? 1 : 0,
    'createdAt': createdAt.toIso8601String(),
  };

  factory CompanyModel.fromMap(Map<String, dynamic> map) => CompanyModel(
    id: map['id'],
    name: map['name'],
    taxNumber: map['taxNumber'],
    commercialRegister: map['commercialRegister'],
    address: map['address'],
    phone: map['phone'],
    email: map['email'],
    logo: map['logo'],
    currency: map['currency'] ?? 'DZD',
    defaultTaxRate: map['defaultTaxRate'],
    isActive: map['isActive'] == 1,
    createdAt: DateTime.parse(map['createdAt']),
  );
}
