class AuditLogModel {
  final int? id;
  final int userId;
  final String action;
  final String tableName;
  final String? recordId;
  final String? oldValue;
  final String? newValue;
  final String? ipAddress;
  final String? deviceInfo;
  final DateTime createdAt;

  AuditLogModel({
    this.id,
    required this.userId,
    required this.action,
    required this.tableName,
    this.recordId,
    this.oldValue,
    this.newValue,
    this.ipAddress,
    this.deviceInfo,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'userId': userId,
    'action': action,
    'tableName': tableName,
    'recordId': recordId,
    'oldValue': oldValue,
    'newValue': newValue,
    'ipAddress': ipAddress,
    'deviceInfo': deviceInfo,
    'createdAt': createdAt.toIso8601String(),
  };

  factory AuditLogModel.fromMap(Map<String, dynamic> map) => AuditLogModel(
    id: map['id'],
    userId: map['userId'],
    action: map['action'],
    tableName: map['tableName'],
    recordId: map['recordId'],
    oldValue: map['oldValue'],
    newValue: map['newValue'],
    ipAddress: map['ipAddress'],
    deviceInfo: map['deviceInfo'],
    createdAt: DateTime.parse(map['createdAt']),
  );
}
