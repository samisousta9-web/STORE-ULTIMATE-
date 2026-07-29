class UserModel {
  final int? id;
  final String username;
  final String password;
  final String fullName;
  final String email;
  final String phone;
  final String role;
  final String? avatar;
  final bool isActive;
  final bool useFingerprint;
  final String? pin;
  final DateTime createdAt;
  final DateTime? lastLogin;
  final List<String> permissions;

  UserModel({
    this.id,
    required this.username,
    required this.password,
    required this.fullName,
    required this.email,
    required this.phone,
    required this.role,
    this.avatar,
    this.isActive = true,
    this.useFingerprint = false,
    this.pin,
    required this.createdAt,
    this.lastLogin,
    this.permissions = const [],
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'username': username,
      'password': password,
      'fullName': fullName,
      'email': email,
      'phone': phone,
      'role': role,
      'avatar': avatar,
      'isActive': isActive ? 1 : 0,
      'useFingerprint': useFingerprint ? 1 : 0,
      'pin': pin,
      'createdAt': createdAt.toIso8601String(),
      'lastLogin': lastLogin?.toIso8601String(),
      'permissions': permissions.join(','),
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      id: map['id'],
      username: map['username'],
      password: map['password'],
      fullName: map['fullName'],
      email: map['email'],
      phone: map['phone'],
      role: map['role'],
      avatar: map['avatar'],
      isActive: map['isActive'] == 1,
      useFingerprint: map['useFingerprint'] == 1,
      pin: map['pin'],
      createdAt: DateTime.parse(map['createdAt']),
      lastLogin: map['lastLogin'] != null ? DateTime.parse(map['lastLogin']) : null,
      permissions: map['permissions']?.toString().split(',').where((s) => s.isNotEmpty).toList() ?? [],
    );
  }

  UserModel copyWith({
    int? id,
    String? username,
    String? password,
    String? fullName,
    String? email,
    String? phone,
    String? role,
    String? avatar,
    bool? isActive,
    bool? useFingerprint,
    String? pin,
    DateTime? createdAt,
    DateTime? lastLogin,
    List<String>? permissions,
  }) {
    return UserModel(
      id: id ?? this.id,
      username: username ?? this.username,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      role: role ?? this.role,
      avatar: avatar ?? this.avatar,
      isActive: isActive ?? this.isActive,
      useFingerprint: useFingerprint ?? this.useFingerprint,
      pin: pin ?? this.pin,
      createdAt: createdAt ?? this.createdAt,
      lastLogin: lastLogin ?? this.lastLogin,
      permissions: permissions ?? this.permissions,
    );
  }
}
