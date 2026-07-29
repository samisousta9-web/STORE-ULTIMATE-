import '../../data/database/database_helper.dart';

class AuditService {
  static final AuditService _instance = AuditService._internal();
  factory AuditService() => _instance;
  AuditService._internal();

  final DatabaseHelper _db = DatabaseHelper();

  Future<void> logAction({
    required int userId,
    required String action,
    required String tableName,
    String? recordId,
    String? oldValue,
    String? newValue,
    String? ipAddress,
    String? deviceInfo,
  }) async {
    final db = await _db.database;
    await db.insert('audit_logs', {
      'userId': userId,
      'action': action,
      'tableName': tableName,
      'recordId': recordId,
      'oldValue': oldValue,
      'newValue': newValue,
      'ipAddress': ipAddress,
      'deviceInfo': deviceInfo,
      'createdAt': DateTime.now().toIso8601String(),
    });
  }

  Future<List<Map<String, dynamic>>> getAuditLogs({
    int? userId,
    String? tableName,
    String? action,
    DateTime? startDate,
    DateTime? endDate,
    int limit = 100,
    int offset = 0,
  }) async {
    final db = await _db.database;
    String whereClause = '1=1';
    List<dynamic> whereArgs = [];

    if (userId != null) {
      whereClause += ' AND userId = ?';
      whereArgs.add(userId);
    }
    if (tableName != null) {
      whereClause += ' AND tableName = ?';
      whereArgs.add(tableName);
    }
    if (action != null) {
      whereClause += ' AND action = ?';
      whereArgs.add(action);
    }
    if (startDate != null) {
      whereClause += ' AND createdAt >= ?';
      whereArgs.add(startDate.toIso8601String());
    }
    if (endDate != null) {
      whereClause += ' AND createdAt <= ?';
      whereArgs.add(endDate.toIso8601String());
    }

    return await db.query(
      'audit_logs',
      where: whereClause,
      whereArgs: whereArgs,
      orderBy: 'createdAt DESC',
      limit: limit,
      offset: offset,
    );
  }
}
